% extract firing rate from All speakers in ALL EFiles 
% will generate 6 figures:
% Firing rate mean, percent bars, SD, Driven rate mean, percent bars, spontaneous rate
% prefer and nonprefer stim for all neurons, no need for overlapping
% 2023-03-02

clear;clc;close all
load('Basic_AU_Data.mat')
N=length(Basic_AU_Data);
onset_time=10;
offset_time=50;
TSpkr_Rank=nan(N,1);
EU_File_me_sd_driven=nan(N, 7); % 7 for p-value of rate
EU_File_me_sd_firing=nan(N, 7); 
EU_File_me_sd_spontn=nan(N, 4);
Driven_all_units=cell(N,7); 
Firing_all_units=cell(N,7); % EFile_all & EFile_target & UFile+unit+ch+rank
for n = 1 : N
    U=Basic_AU_Data{1, n};
    ani=U.Monkey_ID; ch=U.Ch_Num; TSpkr_Rank(n)=U.TSpkr_Rank;
    switch ani
        case 'M50p'
            File_Dir = 'D:\SU\Sheng\M50p\Spikes\';
            Driven_all_units{n,4}=1; Firing_all_units{n,4}=1;
        case 'M43s'
            File_Dir = 'D:\SU\Sheng\M43s\Spikes\';
            Driven_all_units{n,4}=2; Firing_all_units{n,4}=2;
        case 'M43q'
            File_Dir = 'D:\SU\Sheng\M43q\Spikes\'; 
            Driven_all_units{n,4}=3; Firing_all_units{n,4}=3;
    end    
    
    N_Efiles=numel(U.EFile_Numbers);
    EFile_firing_all=[];EFile_driven_all=[]; 
    copyfile ("EFile_rate_processing.m", File_Dir);
    wd = cd; eval(['cd ' File_Dir ';']); 
    for e = 1 : N_Efiles
        Efile=U.EFile_Numbers(e); 
        if Efile<1000&&Efile>=100
            File_Name=strcat(ani,'0',num2str(Efile));
        elseif Efile<100
            File_Name=strcat(ani,'00',num2str(Efile));
        else
            File_Name=strcat(ani,num2str(Efile));
        end 
        eval(['x1=' File_Name ';']);   
        [firing_rates,driven_rates]=EFile_rate_processing(x1,ch,onset_time,offset_time);
        EFile_firing_all=[EFile_firing_all;firing_rates(:)];
        EFile_driven_all=[EFile_driven_all;driven_rates(:)];
    end   
    EFile_spont_all=U.Patch_Data.EFile_Spont_Rates_All_Spkrs;%same as my computations

    EFile_driven_T=1000*U.Patch_Data.EFile_Rel_Driven_Spcounts_TSpkr/U.Patch_Data.Analysis_Window_Length;
    EFile_firing_T=1000*U.Patch_Data.EFile_Driven_Spcounts_TSpkr/U.Patch_Data.Analysis_Window_Length;
    if mean(EFile_firing_T)==0
%         disp(n)
    end    
    EFile_spont_T=U.Patch_Data.EFile_Spont_Rates_TSpkr;

    UFile_driven_rates=1000*U.Patch_Data.UFile_Rel_Driven_Spcounts/U.Patch_Data.Analysis_Window_Length;
    UFile_firing_rates=1000*U.Patch_Data.UFile_Driven_Spcounts/U.Patch_Data.Analysis_Window_Length;
    UFile_spont_rate=U.Patch_Data.UFile_Spont_Rates;
    %not necessary
%     p_val_driven=ranksum(U.Patch_Data.EFile_Rel_Driven_Spcounts_TSpkr,...
%         U.Patch_Data.UFile_Rel_Driven_Spcounts);
%     p_val_firing=ranksum(U.Patch_Data.EFile_Driven_Spcounts_TSpkr,...
%         U.Patch_Data.UFile_Driven_Spcounts);
    
    p_val_driven=ranksum(EFile_driven_T,UFile_driven_rates);
    p_val_firing=ranksum(EFile_firing_T,UFile_firing_rates);
    p_val_spon=ranksum(EFile_spont_T, UFile_spont_rate);

    EU_File_me_sd_driven(n,:)=[mean(EFile_driven_all);mean(EFile_driven_T);mean(UFile_driven_rates);...
        std(EFile_driven_all);std(EFile_driven_T);std(UFile_driven_rates); p_val_driven];
    EU_File_me_sd_firing(n,:)=[mean(EFile_firing_all); mean(EFile_firing_T);...
        mean(UFile_firing_rates);std(EFile_firing_all);std(EFile_firing_T);...
        std(UFile_firing_rates);p_val_firing];
    EU_File_me_sd_spontn(n,:)=[mean(EFile_spont_all); mean(EFile_spont_T);...
        mean(UFile_spont_rate);p_val_spon];
    
    Driven_all_units{n,1}=EFile_driven_all; Driven_all_units{n,2}=EFile_driven_T;
    Driven_all_units{n,3}=UFile_driven_rates;Driven_all_units{n,5}=U.Unit_Num;
    Driven_all_units{n,6}=ch; Driven_all_units{n,7}=U.TSpkr_Rank;
    Firing_all_units{n,1}=EFile_firing_all; Firing_all_units{n,2}=EFile_firing_T;
    Firing_all_units{n,3}=UFile_firing_rates;Firing_all_units{n,5}=U.Unit_Num;
    Firing_all_units{n,6}=ch; Firing_all_units{n,7}=U.TSpkr_Rank;

    eval(['cd ' wd ';']);    
    clear wd;
end
%%
AUC=nan(N,3);
for i = 1: N
    AUC(i,1)=Firing_all_units{i,4};
    AUC(i,2)=Firing_all_units{i,5};
    AUC(i,3)=Firing_all_units{i,6};
end    
[C,ia,ic] = unique(AUC,'rows','stable');
%% Firing rates---use <EU_File_me_sd_firing>
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; r_axis=[0, 2];
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color',[0.5,0.5,0.5]); hold on

T1x=EU_File_me_sd_firing(TSpkr_Rank<=3,1); %equal-prob 15 spkrs
T1y=EU_File_me_sd_firing(TSpkr_Rank<=3,3); %100%/UFile
T15x=EU_File_me_sd_firing(TSpkr_Rank>=13,1); 
T15y=EU_File_me_sd_firing(TSpkr_Rank>=13,3);

p_cut=EU_File_me_sd_firing(:,7)<0.05;

% c1=find(ismember(T1x,T15x));c15=find(ismember(T15x,T1x));
xt=T1x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));%(c1)
yt=T1y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
% scatter(xt,yt,sz,rgb('SteelBlue'),'Marker','.','MarkerFaceAlpha',.5); hold on
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(0.1, 1.8, ['Prefer stim.  Y>X=',num2str(pert),'% n=',num2str(numel(yt))])
xt=T15x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0)); %(c15)
yt=T15y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
% scatter(xt,yt,sz,rgb('SandyBrown'),'Marker','.','MarkerFaceAlpha',.5); hold on
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
pert=round(100*numel(find(xt>yt))/numel(xt)); 
text(0.5, 0.2, ['Non-prefer stim  X>Y=',num2str(pert),'% n=',num2str(numel(yt))])
xlim(r_axis); ylim(r_axis);
xticks([0 1 2]); xticklabels({'0', '10', '100'});% for log scale
yticks([0 1 2]); yticklabels({'0', '10', '100'});
xlabel('Equal prob. 15 spkrs'); ylabel('100% prob. target spkr.');
title('Firing rate mean (spikes/s)')
%
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
% compute proportion
pre_supp=find((EU_File_me_sd_firing(:,2)>=EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3));
pre_faci=find((EU_File_me_sd_firing(:,2)<EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3));
pre_supp_percent_sess=round(100*numel(pre_supp)/(numel(pre_supp)+numel(pre_faci)));
[~,pre_supp_neu,~]=unique(AUC(pre_supp,:),'rows','stable');
[~,pre_faci_neu,~]=unique(AUC(pre_faci,:),'rows','stable');
pre_supp_percent_neu=round(100*numel(pre_supp_neu)/(numel(pre_supp_neu)+numel(pre_faci_neu)));
pre_supp_p=find((EU_File_me_sd_firing(:,2)>=EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_faci_p=find((EU_File_me_sd_firing(:,2)<EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_supp_percent_sess_p=round(100*numel(pre_supp_p)/(numel(pre_supp_p)+numel(pre_faci_p)));
[~,pre_supp_neu_p,~]=unique(AUC(pre_supp_p,:),'rows','stable');
[~,pre_faci_neu_p,~]=unique(AUC(pre_faci_p,:),'rows','stable');
pre_supp_percent_neu_p=round(100*numel(pre_supp_neu_p)/...
    (numel(pre_supp_neu_p)+numel(pre_faci_neu_p)));

text(0.3, 0.4, ['Pre. supp sess.=',num2str(pre_supp_percent_sess),...
    '% ',num2str(numel(pre_supp)),'/',num2str((numel(pre_supp)+numel(pre_faci)))]);
text(0.3, 0.3, ['Pre. supp sess. sig=',num2str(pre_supp_percent_sess_p),...
    '% ',num2str(numel(pre_supp_p)),'/',num2str((numel(pre_supp_p)+numel(pre_faci_p)))]);
text(0.3, 0.2, ['Pre. supp neu.=',num2str(pre_supp_percent_neu),...
    '% ',num2str(numel(pre_supp_neu)),'/',num2str((numel(pre_supp_neu)+numel(pre_faci_neu)))]);
text(0.3, 0.1, ['Pre. supp neu. sig =',num2str(pre_supp_percent_neu_p),...
    '% ',num2str(numel(pre_supp_neu_p)),'/',num2str((numel(pre_supp_neu_p)+numel(pre_faci_neu_p)))]);

npre_supp=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));
npre_faci=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));
npre_faci_percent_sess=round(100*numel(npre_faci)/(numel(npre_supp)+numel(npre_faci)));
[~,npre_supp_neu,~]=unique(AUC(npre_supp,:),'rows','stable');
[~,npre_faci_neu,~]=unique(AUC(npre_faci,:),'rows','stable');
npre_faci_percent_neu=round(100*numel(npre_faci_neu)/(numel(npre_supp_neu)+numel(npre_faci_neu)));
npre_supp_p=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_p=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_percent_sess_p=round(100*numel(npre_faci_p)/(numel(npre_supp_p)+numel(npre_faci_p)));
[~,npre_supp_neu_p,~]=unique(AUC(npre_supp_p,:),'rows','stable');
[~,npre_faci_neu_p,~]=unique(AUC(npre_faci_p,:),'rows','stable');
npre_faci_percent_neu_p=round(100*numel(npre_faci_neu_p)/...
    (numel(npre_supp_neu_p)+numel(npre_faci_neu_p)));

text(0, 1.9, ['Np. faci sess.=',num2str(npre_faci_percent_sess),...
    '% ',num2str(numel(npre_faci)),'/',num2str((numel(npre_supp)+numel(npre_faci)))]);
text(0, 1.8, ['Np. faci sess. sig=',num2str(npre_faci_percent_sess_p),...
    '% ',num2str(numel(npre_faci_p)),'/',num2str((numel(npre_supp_p)+numel(npre_faci_p)))]);
text(0, 1.7, ['Np. faci neu.=',num2str(npre_faci_percent_neu),...
    '% ',num2str(numel(npre_faci_neu)),'/',num2str((numel(npre_supp_neu)+numel(npre_faci_neu)))]);
text(0, 1.6, ['Np. faci neu. sig =',num2str(npre_faci_percent_neu_p),...
    '% ',num2str(numel(npre_faci_neu_p)),'/',num2str((numel(npre_supp_neu_p)+numel(npre_faci_neu_p)))]);

% plot the proportion

xt= log10(1+EU_File_me_sd_firing(npre_supp,2));
yt= log10(1+EU_File_me_sd_firing(npre_supp,3));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(npre_faci,2));
yt= log10(1+EU_File_me_sd_firing(npre_faci,3));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(npre_supp_p,2));
yt= log10(1+EU_File_me_sd_firing(npre_supp_p,3));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(npre_faci_p,2));
yt= log10(1+EU_File_me_sd_firing(npre_faci_p,3));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);

xt= log10(1+EU_File_me_sd_firing(pre_supp,2));
yt= log10(1+EU_File_me_sd_firing(pre_supp,3));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(pre_faci,2));
yt= log10(1+EU_File_me_sd_firing(pre_faci,3));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(pre_supp_p,2));
yt= log10(1+EU_File_me_sd_firing(pre_supp_p,3));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);
xt= log10(1+EU_File_me_sd_firing(pre_faci_p,2));
yt= log10(1+EU_File_me_sd_firing(pre_faci_p,3));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);

xlim(r_axis); ylim(r_axis); 
xticks([0 1 2]); xticklabels({'0', '10', '100'});% for log scale
yticks([0 1 2]); yticklabels({'0', '10', '100'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Firing rate mean (spikes/s)')
exportgraphics(gcf,'firing_rate.pdf','ContentType','vector', 'BackgroundColor','none')
%% proportion stacked bar of pre/nonpre for session and neuron
figure
tiledlayout(1,2,"TileSpacing","compact"); %1 line
nexttile;
pre_bars_1=[numel(pre_faci) numel(pre_supp)];
pre_bars_2=[numel(pre_faci_p) numel(pre_supp_p)];
pre_bars_3=[numel(pre_faci_neu) numel(pre_supp_neu)];
pre_bars_4=[numel(pre_faci_neu_p) numel(pre_supp_neu_p)];
bar(1:4, [pre_bars_1/sum(pre_bars_1);pre_bars_2/sum(pre_bars_2);...
    pre_bars_3/sum(pre_bars_3);pre_bars_4/sum(pre_bars_4)],'stacked')
nexttile;
npre_bars_1=[numel(npre_faci) numel(npre_supp)];
npre_bars_2=[numel(npre_faci_p) numel(npre_supp_p)];
npre_bars_3=[numel(npre_faci_neu) numel(npre_supp_neu)];
npre_bars_4=[numel(npre_faci_neu_p) numel(npre_supp_neu_p)];
bar(1:4, [npre_bars_1/sum(npre_bars_1);npre_bars_2/sum(npre_bars_2);...
    npre_bars_3/sum(npre_bars_3);npre_bars_4/sum(npre_bars_4)],'stacked')
%% Firing rates standard deviation
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; r_axis=[0, 25];
nexttile; %no need to display
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
T1x=EU_File_me_sd_firing(TSpkr_Rank<=3,5); 
T1y=EU_File_me_sd_firing(TSpkr_Rank<=3,6);
T15x=EU_File_me_sd_firing(TSpkr_Rank>=13,5); 
T15y=EU_File_me_sd_firing(TSpkr_Rank>=13,6);
xt=T1x; yt=T1y;
scatter(xt, yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);%linear scale
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 23, ['Prefer  X>Y',num2str(pert),'%'])
xt=T15x; yt=T15y;
scatter(xt, yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 21, ['Non-prefer  X>Y',num2str(pert),'%'])
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Firing rate standard deviation');xlim([0 25]);ylim([0 25])
exportgraphics(gcf,'firing_rate_SD.pdf','ContentType','vector', 'BackgroundColor','none')
%% Driven rates 1vs15 or 1-3vs13-15, log or linear axis
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; r_axis=[-1, 2]; 
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color',[0.5,0.5,0.5]); hold on
T1x=EU_File_me_sd_driven(TSpkr_Rank<=3,1); % equal-prob firing rate
T1y=EU_File_me_sd_driven(TSpkr_Rank<=3,3); % 100%-prob firing rate
T15x=EU_File_me_sd_driven(TSpkr_Rank>=13,1); 
T15y=EU_File_me_sd_driven(TSpkr_Rank>=13,3);
xt=T1x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(-0.6, 1.8, ['Prefer stim.  Y>X=',num2str(pert),'% n=',num2str(numel(yt))])
xt=T15x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>yt))/numel(xt)); 
text(-0.6, -0.8, ['Non-prefer stim  X>Y=',num2str(pert),'% n=',num2str(numel(yt))])
xlim(r_axis); ylim(r_axis); 
xticks([-1 0 1 2]); xticklabels({'-10', '0', '10', '100'});
yticks([-1 0 1 2]); yticklabels({'-10', '0', '10', '100'});
xlabel('Equal prob. 15 spkrs'); ylabel('100% prob. target spkr.');
title('Driven rate mean (spikes/s)')
%
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color',[0.5,0.5,0.5]); hold on
pre_supp=find((EU_File_me_sd_driven(:,2)>=EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3));
pre_faci=find((EU_File_me_sd_driven(:,2)<EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3));
pre_supp_percent_sess=round(100*numel(pre_supp)/(numel(pre_supp)+numel(pre_faci)));
[~,pre_supp_neu,~]=unique(AUC(pre_supp,:),'rows','stable');
[~,pre_faci_neu,~]=unique(AUC(pre_faci,:),'rows','stable');
pre_supp_percent_neu=round(100*numel(pre_supp_neu)/(numel(pre_supp_neu)+numel(pre_faci_neu)));
p_cut=EU_File_me_sd_driven(:,7)<0.05;
pre_supp_p=find((EU_File_me_sd_driven(:,2)>=EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_faci_p=find((EU_File_me_sd_driven(:,2)<EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_supp_percent_sess_p=round(100*numel(pre_supp_p)/(numel(pre_supp_p)+numel(pre_faci_p)));
[~,pre_supp_neu_p,~]=unique(AUC(pre_supp_p,:),'rows','stable');
[~,pre_faci_neu_p,~]=unique(AUC(pre_faci_p,:),'rows','stable');
pre_supp_percent_neu_p=round(100*numel(pre_supp_neu_p)/...
    (numel(pre_supp_neu_p)+numel(pre_faci_neu_p)));
text(-0.7, -0.4, ['Pre. supp sess.=',num2str(pre_supp_percent_sess),...
    '% ',num2str(numel(pre_supp)),'/',num2str((numel(pre_supp)+numel(pre_faci)))]);
text(-0.7, -0.55, ['Pre. supp sess. sig=',num2str(pre_supp_percent_sess_p),...
    '% ',num2str(numel(pre_supp_p)),'/',num2str((numel(pre_supp_p)+numel(pre_faci_p)))]);
text(-0.7, -0.7, ['Pre. supp neu.=',num2str(pre_supp_percent_neu),...
    '% ',num2str(numel(pre_supp_neu)),'/',num2str((numel(pre_supp_neu)+numel(pre_faci_neu)))]);
text(-0.7, -0.85, ['Pre. supp neu. sig =',num2str(pre_supp_percent_neu_p),...
    '% ',num2str(numel(pre_supp_neu_p)),'/',num2str((numel(pre_supp_neu_p)+numel(pre_faci_neu_p)))]);

npre_supp=find((EU_File_me_sd_driven(:,2)>EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13));
npre_faci=find((EU_File_me_sd_driven(:,2)<=EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13));
npre_faci_percent_sess=round(100*numel(npre_faci)/(numel(npre_supp)+numel(npre_faci)));
[~,npre_supp_neu,~]=unique(AUC(npre_supp,:),'rows','stable');
[~,npre_faci_neu,~]=unique(AUC(npre_faci,:),'rows','stable');
npre_faci_percent_neu=round(100*numel(npre_faci_neu)/(numel(npre_supp_neu)+numel(npre_faci_neu)));
p_cut=EU_File_me_sd_driven(:,7)<0.05;
npre_supp_p=find((EU_File_me_sd_driven(:,2)>EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_p=find((EU_File_me_sd_driven(:,2)<=EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_percent_sess_p=round(100*numel(npre_faci_p)/(numel(npre_supp_p)+numel(npre_faci_p)));
[~,npre_supp_neu_p,~]=unique(AUC(npre_supp_p,:),'rows','stable');
[~,npre_faci_neu_p,~]=unique(AUC(npre_faci_p,:),'rows','stable');
npre_faci_percent_neu_p=round(100*numel(npre_faci_neu_p)/...
    (numel(npre_supp_neu_p)+numel(npre_faci_neu_p)));
text(-1, 1.9, ['Np. faci sess.=',num2str(npre_faci_percent_sess),...
    '% ',num2str(numel(npre_faci)),'/',num2str((numel(npre_supp)+numel(npre_faci)))]);
text(-1, 1.75, ['Np. faci sess. sig=',num2str(npre_faci_percent_sess_p),...
    '% ',num2str(numel(npre_faci_p)),'/',num2str((numel(npre_supp_p)+numel(npre_faci_p)))]);
text(-1, 1.6, ['Np. faci neu.=',num2str(npre_faci_percent_neu),...
    '% ',num2str(numel(npre_faci_neu)),'/',num2str((numel(npre_supp_neu)+numel(npre_faci_neu)))]);
text(-1, 1.45, ['Np. faci neu. sig =',num2str(npre_faci_percent_neu_p),...
    '% ',num2str(numel(npre_faci_neu_p)),'/',num2str((numel(npre_supp_neu_p)+numel(npre_faci_neu_p)))]);
%
xt= EU_File_me_sd_driven(npre_supp,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(npre_supp,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(npre_faci,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(npre_faci,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(npre_supp_p,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(npre_supp_p,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(npre_faci_p,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(npre_faci_p,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);

xt= EU_File_me_sd_driven(pre_supp,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(pre_supp,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(pre_faci,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(pre_faci,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(pre_supp_p,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(pre_supp_p,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);
xt= EU_File_me_sd_driven(pre_faci_p,2);xt(xt>=0)=log10(1+xt(xt>=0));xt(xt<0)=-log10(1-xt(xt<0));
yt= EU_File_me_sd_driven(pre_faci_p,3);yt(yt>=0)=log10(1+yt(yt>=0));yt(yt<0)=-log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);

xlim(r_axis); ylim(r_axis); 
xticks([-1 0 1 2]); xticklabels({'-10', '0', '10', '100'});% for log scale
yticks([-1 0 1 2]); yticklabels({'-10', '0', '10', '100'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Driven rate mean (spikes/s)')
exportgraphics(gcf,'driven_rate.pdf','ContentType','vector', 'BackgroundColor','none')
%% proportion stacked bar of pre/nonpre for session and neuron
figure
tiledlayout(1,2,"TileSpacing","compact"); %1 line
nexttile;
pre_bars_1=[numel(pre_faci) numel(pre_supp)];
pre_bars_2=[numel(pre_faci_p) numel(pre_supp_p)];
pre_bars_3=[numel(pre_faci_neu) numel(pre_supp_neu)];
pre_bars_4=[numel(pre_faci_neu_p) numel(pre_supp_neu_p)];
bar(1:4, [pre_bars_1/sum(pre_bars_1);pre_bars_2/sum(pre_bars_2);...
    pre_bars_3/sum(pre_bars_3);pre_bars_4/sum(pre_bars_4)],'stacked')
nexttile;
npre_bars_1=[numel(npre_faci) numel(npre_supp)];
npre_bars_2=[numel(npre_faci_p) numel(npre_supp_p)];
npre_bars_3=[numel(npre_faci_neu) numel(npre_supp_neu)];
npre_bars_4=[numel(npre_faci_neu_p) numel(npre_supp_neu_p)];
bar(1:4, [npre_bars_1/sum(npre_bars_1);npre_bars_2/sum(npre_bars_2);...
    npre_bars_3/sum(npre_bars_3);npre_bars_4/sum(npre_bars_4)],'stacked')
%% Spontaneous rates---use <EU_File_me_sd_spontn>
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; rank=[1,15]; r_axis=[0, log10(30)]; 
nexttile;
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
p_cut=EU_File_me_sd_spontn(:,4)<0.05;
pre_supp=find((EU_File_me_sd_spontn(:,2)>EU_File_me_sd_spontn(:,3))&(TSpkr_Rank<=3));
pre_faci=find((EU_File_me_sd_spontn(:,2)<=EU_File_me_sd_spontn(:,3))&(TSpkr_Rank<=3));
pre_supp_percent_sess=round(100*numel(pre_supp)/(numel(pre_supp)+numel(pre_faci)));
[~,pre_supp_neu,~]=unique(AUC(pre_supp,:),'rows','stable');
[~,pre_faci_neu,~]=unique(AUC(pre_faci,:),'rows','stable');
pre_supp_percent_neu=round(100*numel(pre_supp_neu)/(numel(pre_supp_neu)+numel(pre_faci_neu)));

pre_supp_p=find((EU_File_me_sd_spontn(:,2)>EU_File_me_sd_spontn(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_faci_p=find((EU_File_me_sd_spontn(:,2)<=EU_File_me_sd_spontn(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_supp_percent_sess_p=round(100*numel(pre_supp_p)/(numel(pre_supp_p)+numel(pre_faci_p)));
[~,pre_supp_neu_p,~]=unique(AUC(pre_supp_p,:),'rows','stable');
[~,pre_faci_neu_p,~]=unique(AUC(pre_faci_p,:),'rows','stable');
pre_supp_percent_neu_p=round(100*numel(pre_supp_neu_p)/...
    (numel(pre_supp_neu_p)+numel(pre_faci_neu_p)));

text(0.3, 0.4, ['Pre. supp sess.=',num2str(pre_supp_percent_sess),...
    '% ',num2str(numel(pre_supp)),'/',num2str((numel(pre_supp)+numel(pre_faci)))]);
text(0.3, 0.3, ['Pre. supp sess. sig=',num2str(pre_supp_percent_sess_p),...
    '% ',num2str(numel(pre_supp_p)),'/',num2str((numel(pre_supp_p)+numel(pre_faci_p)))]);
text(0.3, 0.2, ['Pre. supp neu.=',num2str(pre_supp_percent_neu),...
    '% ',num2str(numel(pre_supp_neu)),'/',num2str((numel(pre_supp_neu)+numel(pre_faci_neu)))]);
text(0.3, 0.1, ['Pre. supp neu. sig =',num2str(pre_supp_percent_neu_p),...
    '% ',num2str(numel(pre_supp_neu_p)),'/',num2str((numel(pre_supp_neu_p)+numel(pre_faci_neu_p)))]);

npre_supp=find((EU_File_me_sd_spontn(:,2)>EU_File_me_sd_spontn(:,3))&(TSpkr_Rank>=13));
npre_faci=find((EU_File_me_sd_spontn(:,2)<EU_File_me_sd_spontn(:,3))&(TSpkr_Rank>=13));
npre_faci_percent_sess=round(100*numel(npre_faci)/(numel(npre_supp)+numel(npre_faci)));
[~,npre_supp_neu,~]=unique(AUC(npre_supp,:),'rows','stable');
[~,npre_faci_neu,~]=unique(AUC(npre_faci,:),'rows','stable');
npre_faci_percent_neu=round(100*numel(npre_faci_neu)/(numel(npre_supp_neu)+numel(npre_faci_neu)));

npre_supp_p=find((EU_File_me_sd_spontn(:,2)>EU_File_me_sd_spontn(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_p=find((EU_File_me_sd_spontn(:,2)<EU_File_me_sd_spontn(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci_percent_sess_p=round(100*numel(npre_faci_p)/(numel(npre_supp_p)+numel(npre_faci_p)));
[~,npre_supp_neu_p,~]=unique(AUC(npre_supp_p,:),'rows','stable');
[~,npre_faci_neu_p,~]=unique(AUC(npre_faci_p,:),'rows','stable');
npre_faci_percent_neu_p=round(100*numel(npre_faci_neu_p)/...
    (numel(npre_supp_neu_p)+numel(npre_faci_neu_p)));

text(0, 1.4, ['Np. faci sess.=',num2str(npre_faci_percent_sess),...
    '% ',num2str(numel(npre_faci)),'/',num2str((numel(npre_supp)+numel(npre_faci)))]);
text(0, 1.3, ['Np. faci sess. sig=',num2str(npre_faci_percent_sess_p),...
    '% ',num2str(numel(npre_faci_p)),'/',num2str((numel(npre_supp_p)+numel(npre_faci_p)))]);
text(0, 1.2, ['Np. faci neu.=',num2str(npre_faci_percent_neu),...
    '% ',num2str(numel(npre_faci_neu)),'/',num2str((numel(npre_supp_neu)+numel(npre_faci_neu)))]);
text(0, 1.1, ['Np. faci neu. sig =',num2str(npre_faci_percent_neu_p),...
    '% ',num2str(numel(npre_faci_neu_p)),'/',num2str((numel(npre_supp_neu_p)+numel(npre_faci_neu_p)))]);

T1x=EU_File_me_sd_spontn(TSpkr_Rank<=3,2); 
T1y=EU_File_me_sd_spontn(TSpkr_Rank<=3,3);
T15x=EU_File_me_sd_spontn(TSpkr_Rank>=13,2); 
T15y=EU_File_me_sd_spontn(TSpkr_Rank>=13,3);
xt=T1x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5);
xt=T15x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5);

T1x=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,2); 
T1y=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,3);
T15x=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,2); 
T15y=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,3);
xt=T1x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);
xt=T15x; xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y; yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5);

xlim(r_axis); ylim(r_axis); 
xticks([0 log10(3) log10(30)]); xticklabels({'0', '3', '30'});% for log scale
yticks([0 log10(3) log10(30)]); yticklabels({'0', '3', '30'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Spontaneous firing rate (spikes/s)')
exportgraphics(gcf,'spontaneous.pdf','ContentType','vector', 'BackgroundColor','none')