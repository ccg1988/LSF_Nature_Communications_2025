% extract firing rate from All speakers in ALL EFiles 
% only 18 units that both have Rank1 and Rank15, so we group 1/2/3 as high
% rank group and 13/14/15 as low rank group
% will generate 3 figures:
% Firing rate mean, driven rate mean, spontaneous rate
% 2023-02-26

clear;clc;close all
load('Basic_AU_Data.mat')
N=length(Basic_AU_Data);
onset_time=10;
offset_time=50;
TSpkr_Rank=nan(N,1);
EU_File_me_sd_driven=nan(N, 7); % 7 for p-value
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
%     if mean(EFile_firing_T)==0
%         disp(n)
%     end    
    EFile_spont_T=U.Patch_Data.EFile_Spont_Rates_TSpkr;

    UFile_driven_rates=1000*U.Patch_Data.UFile_Rel_Driven_Spcounts/U.Patch_Data.Analysis_Window_Length;
    UFile_firing_rates=1000*U.Patch_Data.UFile_Driven_Spcounts/U.Patch_Data.Analysis_Window_Length;
    UFile_spont_rate=U.Patch_Data.UFile_Spont_Rates;

    p_val_driven=ranksum(U.Patch_Data.EFile_Rel_Driven_Spcounts_TSpkr,...
        U.Patch_Data.UFile_Rel_Driven_Spcounts);
    p_val_firing=ranksum(U.Patch_Data.EFile_Driven_Spcounts_TSpkr,...
        U.Patch_Data.UFile_Driven_Spcounts);
    p_val_spon=ranksum(EFile_spont_T, UFile_spont_rate);
%     p_val_driven=ranksum(EFile_driven_T,UFile_driven_rates);
%     p_val_firing=ranksum(EFile_firing_T,UFile_firing_rates);

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
c1=find(ismember(T1x,T15x));c15=find(ismember(T15x,T1x));
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));%
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5); 
% pert=round(100*numel(find(yt>xt))/numel(yt)); 
% text(0.1, 1.8, ['Prefer stim.  Y>X=',num2str(pert),'% n=',num2str(numel(yt))])
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0)); %
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5); 
% pert=round(100*numel(find(xt>yt))/numel(xt)); 
% text(0.5, 0.2, ['Non-prefer stim  X>Y=',num2str(pert),'% n=',num2str(numel(yt))])
% 34 neurons that have tested with prefer and nonprefered session
Neu_all=size(intersect(AUC(TSpkr_Rank<=3,:),AUC(TSpkr_Rank>=13,:),'rows'),1);
text(0.1, 1.8, ['Neurons=',num2str(Neu_all)])

%
% N_sig_resize(intersect(AUC(pre_supp_p,:),AUC(pre_faci_p,:),'rows'),1);
% npre_supp=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));
% npre_faci=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));

p_cut=EU_File_me_sd_firing(:,7)<0.05; % equal~=100%
T1x=EU_File_me_sd_firing(TSpkr_Rank<=3&p_cut,1); %equal-prob 15 spkrs
T1y=EU_File_me_sd_firing(TSpkr_Rank<=3&p_cut,3); %100%/UFile
c1_p=find(ismember(T1x,T15x));
xt=T1x(c1_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));%
yt=T1y(c1_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on

T15x=EU_File_me_sd_firing(TSpkr_Rank>=13&p_cut,1); 
T15y=EU_File_me_sd_firing(TSpkr_Rank>=13&p_cut,3);
c15_p=find(ismember(T15x,T1x));
xt=T15x(c15_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0)); %
yt=T15y(c15_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on

xlim(r_axis); ylim(r_axis);
xticks([0 1 2]); xticklabels({'0', '10', '100'});% for log scale
yticks([0 1 2]); yticklabels({'0', '10', '100'});
xlabel('Equal prob. 15 spkrs'); ylabel('100% prob. target spkr.');
title('Firing rate mean (spikes/s)')
%


% % neurons that
% pre_supp_p=find((EU_File_me_sd_firing(:,2)>=EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
% pre_faci_p=find((EU_File_me_sd_firing(:,2)<EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
% N_sig_resize(intersect(AUC(pre_supp_p,:),AUC(pre_faci_p,:),'rows'),1);
% npre_supp_p=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
% npre_faci_p=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
% intersect(AUC(pre_supp_p,:),AUC(pre_faci_p,:),'rows')
%
% ----------------------------------------next panel-------------------%
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
T1x=EU_File_me_sd_firing(TSpkr_Rank<=3,2); 
T1y=EU_File_me_sd_firing(TSpkr_Rank<=3,3);
T15x=EU_File_me_sd_firing(TSpkr_Rank>=13,2); 
T15y=EU_File_me_sd_firing(TSpkr_Rank>=13,3);
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>=yt))/numel(xt)); 
text(0.2, 0.4, ['Pre. supp. sess.=',num2str(pert),'% ',...
    num2str(numel(find(xt>yt))),'/',num2str(numel(xt))])
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(0, 1.9, ['Np. faci. sess.=',num2str(pert),'% ',...
    num2str(numel(find(yt>=xt))),'/',num2str(numel(xt))])

% X neurons that supp or faci to prefer stim------------
% 34 neurons test with pre&nonpre, overlap=(27+14)-34=41-34=7 neurons
pre_supp=find((EU_File_me_sd_firing(:,2)>=EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3));
pre_faci=find((EU_File_me_sd_firing(:,2)<EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3));
Neu_pre_supp=size(intersect(AUC(pre_supp,:),AUC(TSpkr_Rank>=13,:),'rows'),1); %27 neurons
Neu_pre_faci=size(intersect(AUC(pre_faci,:),AUC(TSpkr_Rank>=13,:),'rows'),1); %14 neurons
% Neu_pre_supp_percent=round(100*Neu_pre_supp/(Neu_pre_supp+Neu_pre_faci));
% text(0.2, 0.2, ['Pre. supp. neu. =',num2str(Neu_pre_supp_percent),...
%     '% ',num2str(Neu_pre_supp),'/',num2str(Neu_pre_supp+Neu_pre_faci)]);
Neu_pre_supp_percent=round(100*Neu_pre_supp/Neu_all);
text(0.2, 0.2, ['Pre. supp. neu. =',num2str(Neu_pre_supp_percent),...
    '% ',num2str(Neu_pre_supp),'/',num2str(Neu_all)]);
% X neurons that supp or faci to nonprefer stim------------
% among 34 neurons, overlap=(15+32)-34=47-34=13 neurons
npre_supp=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));
npre_faci=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13));
Neu_npre_supp=size(intersect(AUC(npre_supp,:),AUC(TSpkr_Rank<=3,:),'rows'),1); %15 neurons
Neu_npre_faci=size(intersect(AUC(npre_faci,:),AUC(TSpkr_Rank<=3,:),'rows'),1); %32 neurons
% Neu_npre_faci_percent=round(100*Neu_npre_faci/(Neu_npre_supp+Neu_npre_faci));
% text(0, 1.7, ['Np. faci. neu. =',num2str(Neu_npre_faci_percent),...
%     '% ',num2str(Neu_npre_faci),'/',num2str(Neu_npre_supp+Neu_npre_faci)]);
Neu_npre_faci_percent=round(100*Neu_npre_faci/Neu_all);
text(0, 1.7, ['Np. faci. neu. =',num2str(Neu_npre_faci_percent),...
    '% ',num2str(Neu_npre_faci),'/',num2str(Neu_all)]);
%
%***********************************************************************************
%------------------significant part------------------------------------------------%
% 14 neurons that tuned to both prefer and nonprefered stimuli
Neu_sig_both=size(intersect(AUC(TSpkr_Rank<=3&p_cut,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);
% Neu_sig_pre=size(unique(AUC(TSpkr_Rank<=3&p_cut,:),'rows'),1);
% Neu_sig_nonpre=size(unique(AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);
% Neu_two_test=intersect(AUC(TSpkr_Rank<=3,:),AUC(TSpkr_Rank>=13,:),'rows');
% Neu_sig_all=unique(AUC(p_cut,:),'rows');
% Neu_sig_either=size(intersect(Neu_two_test,Neu_sig),1); % significant faci or supp
% Neu_sig=unique(AUC((TSpkr_Rank<=3)&(TSpkr_Rank>=13)&p_cut,:),'rows');

%11neurons supp to pre and tuned to npre; 4neurons faci to pre and tuned to npre;
pre_supp=find((EU_File_me_sd_firing(:,2)>=EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_faci=find((EU_File_me_sd_firing(:,2)<EU_File_me_sd_firing(:,3))&(TSpkr_Rank<=3)&p_cut);
Neu_pre_supp_p=size(intersect(AUC(pre_supp,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);%11 neuron
Neu_pre_faci_p=size(intersect(AUC(pre_faci,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);%4 neuron
% Neu_pre_supp_percent_p=round(100*Neu_pre_supp_p/(Neu_pre_supp_p+Neu_pre_faci_p));
% text(0.2, 0.1, ['Pre. supp. neu. sig =',num2str(Neu_pre_supp_percent_p),...
%     '% ',num2str(Neu_pre_supp_p),'/',num2str(Neu_pre_supp_p+Neu_pre_faci_p)]);
Neu_pre_supp_percent_p=round(100*Neu_pre_supp_p/Neu_sig_both);
text(0.2, 0.1, ['Pre. supp. neu. sig =',num2str(Neu_pre_supp_percent_p),...
    '% ',num2str(Neu_pre_supp_p),'/',num2str(Neu_sig_both)]);
Neu_pre_faci_percent_p=round(100*Neu_pre_faci_p/Neu_sig_both);
text(0.2, 0, ['Pre. faci. neu. sig =',num2str(Neu_pre_faci_percent_p),...
    '% ',num2str(Neu_pre_faci_p),'/',num2str(Neu_sig_both)]);

%14neurons faci to npre and tuned to pre; 2neurons supp to npre and tuned to pre;
%becaue there are 3 nonpre, so it can faci to some but supp to others
npre_supp=find((EU_File_me_sd_firing(:,2)>EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci=find((EU_File_me_sd_firing(:,2)<=EU_File_me_sd_firing(:,3))&(TSpkr_Rank>=13)&p_cut);
Neu_npre_supp_p=size(intersect(AUC(npre_supp,:),AUC(TSpkr_Rank<=3&p_cut,:),'rows'),1);%2 neuron
Neu_npre_faci_p=size(intersect(AUC(npre_faci,:),AUC(TSpkr_Rank<=3&p_cut,:),'rows'),1);%14 neuron
% Neu_npre_faci_percent_p=round(100*Neu_npre_faci_p/(Neu_npre_supp_p+Neu_npre_faci_p));
% text(0, 1.6, ['Np. faci. neu. sig =',num2str(Neu_npre_faci_percent_p),...
%     '% ',num2str(Neu_npre_faci_p),'/',num2str(Neu_npre_supp_p+Neu_npre_faci_p)]);
Neu_npre_faci_percent_p=round(100*Neu_npre_faci_p/Neu_sig_both);
text(0, 1.6, ['Np. faci. neu. sig =',num2str(Neu_npre_faci_percent_p),...
    '% ',num2str(Neu_npre_faci_p),'/',num2str(Neu_sig_both)]);
Neu_npre_supp_percent_p=round(100*Neu_npre_supp_p/Neu_sig_both);
text(0, 1.5, ['Np. supp. neu. sig =',num2str(Neu_npre_supp_percent_p),...
    '% ',num2str(Neu_npre_supp_p),'/',num2str(Neu_sig_both)]);

T1x=EU_File_me_sd_firing(TSpkr_Rank<=3&p_cut,2); 
T1y=EU_File_me_sd_firing(TSpkr_Rank<=3&p_cut,3);
xt=T1x(c1_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>=yt))/numel(xt)); 
text(0.2, 0.3, ['Pre. supp. sess. sig=',num2str(pert),'% ',...
    num2str(numel(find(xt>yt))),'/',num2str(numel(xt))])

T15x=EU_File_me_sd_firing(TSpkr_Rank>=13&p_cut,2); 
T15y=EU_File_me_sd_firing(TSpkr_Rank>=13&p_cut,3);
xt=T15x(c15_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(0, 1.8, ['Np. faci. sess. sig=',num2str(pert),'% ',...
    num2str(numel(find(yt>=xt))),'/',num2str(numel(xt))])
xlim(r_axis); ylim(r_axis); 
xticks([0 1 2]); xticklabels({'0', '10', '100'});% for log scale
yticks([0 1 2]); yticklabels({'0', '10', '100'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Firing rate mean (spikes/s)')
%% proportion stacked bar of pre/nonpre for session and neuron
figure
tiledlayout(1,2,"TileSpacing","compact"); %1 line
nexttile;
pre_bars_1=[57 16];
pre_bars_2=[38 5];
pre_bars_3=[27 7];
pre_bars_4=[11 3];
bar(1:4, [pre_bars_1/73;pre_bars_2/43;...
    pre_bars_3/34;pre_bars_4/14],'stacked')
nexttile;
npre_bars_1=[77 24];
npre_bars_2=[24 5];
npre_bars_3=[32 2];
npre_bars_4=[14 0];
bar(1:4, [npre_bars_1/101;npre_bars_2/29;...
    npre_bars_3/34;npre_bars_4/14],'stacked')
%% Driven rates 
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; r_axis=[-1, 2];
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color',[0.5,0.5,0.5]); hold on

T1x=EU_File_me_sd_driven(TSpkr_Rank<=3,1); %equal-prob 15 spkrs
T1y=EU_File_me_sd_driven(TSpkr_Rank<=3,3); %100%/UFile
T15x=EU_File_me_sd_driven(TSpkr_Rank>=13,1); 
T15y=EU_File_me_sd_driven(TSpkr_Rank>=13,3);
c1=find(ismember(T1x,T15x));c15=find(ismember(T15x,T1x));
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));%
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5); 
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0)); %
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5); 
Neu_all=size(intersect(AUC(TSpkr_Rank<=3,:),AUC(TSpkr_Rank>=13,:),'rows'),1);
text(0.1, 1.8, ['Neurons=',num2str(Neu_all)])

p_cut=EU_File_me_sd_driven(:,7)<0.05; % equal~=100%
T1x=EU_File_me_sd_driven(TSpkr_Rank<=3&p_cut,1); %equal-prob 15 spkrs
T1y=EU_File_me_sd_driven(TSpkr_Rank<=3&p_cut,3); %100%/UFile
c1_p=find(ismember(T1x,T15x));
xt=T1x(c1_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));%
yt=T1y(c1_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on

T15x=EU_File_me_sd_driven(TSpkr_Rank>=13&p_cut,1); 
T15y=EU_File_me_sd_driven(TSpkr_Rank>=13&p_cut,3);
c15_p=find(ismember(T15x,T1x));
xt=T15x(c15_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0)); %
yt=T15y(c15_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on

xlim(r_axis); ylim(r_axis);
xticks([-1 0 1 2]); xticklabels({'-10', '0', '10', '100'});% for log scale
yticks([-1 0 1 2]); yticklabels({'-10', '0', '10', '100'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Driven rate mean (spikes/s)')

% ----------------------------------------next panel-------------------%
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
T1x=EU_File_me_sd_driven(TSpkr_Rank<=3,2); 
T1y=EU_File_me_sd_driven(TSpkr_Rank<=3,3);
T15x=EU_File_me_sd_driven(TSpkr_Rank>=13,2); 
T15y=EU_File_me_sd_driven(TSpkr_Rank>=13,3);
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SteelBlue'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>=yt))/numel(xt)); 
text(-0.8, 0, ['Pre. supp. sess.=',num2str(pert),'% ',...
    num2str(numel(find(xt>yt))),'/',num2str(numel(xt))])
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('SandyBrown'),'filled','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(-1, 1.9, ['Np. faci. sess.=',num2str(pert),'% ',...
    num2str(numel(find(yt>=xt))),'/',num2str(numel(xt))])

% X neurons that supp or faci to prefer stim------------
% 34 neurons test with pre&nonpre, overlap=(27+14)-34=41-34=7 neurons
pre_supp=find((EU_File_me_sd_driven(:,2)>=EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3));
pre_faci=find((EU_File_me_sd_driven(:,2)<EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3));
Neu_pre_supp=size(intersect(AUC(pre_supp,:),AUC(TSpkr_Rank>=13,:),'rows'),1); %27 neurons
Neu_pre_faci=size(intersect(AUC(pre_faci,:),AUC(TSpkr_Rank>=13,:),'rows'),1); %14 neurons
Neu_pre_supp_percent=round(100*Neu_pre_supp/Neu_all);
text(-0.8, -0.4, ['Pre. supp. neu. =',num2str(Neu_pre_supp_percent),...
    '% ',num2str(Neu_pre_supp),'/',num2str(Neu_all)]);
% X neurons that supp or faci to nonprefer stim------------
% among 34 neurons, overlap=(15+32)-34=47-34=13 neurons
npre_supp=find((EU_File_me_sd_driven(:,2)>EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13));
npre_faci=find((EU_File_me_sd_driven(:,2)<=EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13));
Neu_npre_supp=size(intersect(AUC(npre_supp,:),AUC(TSpkr_Rank<=3,:),'rows'),1); %15 neurons
Neu_npre_faci=size(intersect(AUC(npre_faci,:),AUC(TSpkr_Rank<=3,:),'rows'),1); %32 neurons
Neu_npre_faci_percent=round(100*Neu_npre_faci/Neu_all);
text(-1, 1.5, ['Np. faci. neu. =',num2str(Neu_npre_faci_percent),...
    '% ',num2str(Neu_npre_faci),'/',num2str(Neu_all)]);
%
%***********************************************************************************
%------------------significant part------------------------------------------------%
% 14 neurons that tuned to both prefer and nonprefered stimuli
Neu_sig_both=size(intersect(AUC(TSpkr_Rank<=3&p_cut,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);

%11neurons supp to pre and tuned to npre; 4neurons faci to pre and tuned to npre;
pre_supp=find((EU_File_me_sd_driven(:,2)>=EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3)&p_cut);
pre_faci=find((EU_File_me_sd_driven(:,2)<EU_File_me_sd_driven(:,3))&(TSpkr_Rank<=3)&p_cut);
Neu_pre_supp_p=size(intersect(AUC(pre_supp,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);%11 neuron
Neu_pre_faci_p=size(intersect(AUC(pre_faci,:),AUC(TSpkr_Rank>=13&p_cut,:),'rows'),1);%4 neuron
Neu_pre_supp_percent_p=round(100*Neu_pre_supp_p/Neu_sig_both);
text(-0.8, -0.6, ['Pre. supp. neu. sig =',num2str(Neu_pre_supp_percent_p),...
    '% ',num2str(Neu_pre_supp_p),'/',num2str(Neu_sig_both)]);
Neu_pre_faci_percent_p=round(100*Neu_pre_faci_p/Neu_sig_both);
text(-0.8, -0.8, ['Pre. faci. neu. sig =',num2str(Neu_pre_faci_percent_p),...
    '% ',num2str(Neu_pre_faci_p),'/',num2str(Neu_sig_both)]);

%14neurons faci to npre and tuned to pre; 2neurons supp to npre and tuned to pre;
%becaue there are 3 nonpre, so it can faci to some but supp to others
npre_supp=find((EU_File_me_sd_driven(:,2)>EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13)&p_cut);
npre_faci=find((EU_File_me_sd_driven(:,2)<=EU_File_me_sd_driven(:,3))&(TSpkr_Rank>=13)&p_cut);
Neu_npre_supp_p=size(intersect(AUC(npre_supp,:),AUC(TSpkr_Rank<=3&p_cut,:),'rows'),1);%2 neuron
Neu_npre_faci_p=size(intersect(AUC(npre_faci,:),AUC(TSpkr_Rank<=3&p_cut,:),'rows'),1);%14 neuron
Neu_npre_faci_percent_p=round(100*Neu_npre_faci_p/Neu_sig_both);
text(-1, 1.3, ['Np. faci. neu. sig =',num2str(Neu_npre_faci_percent_p),...
    '% ',num2str(Neu_npre_faci_p),'/',num2str(Neu_sig_both)]);
Neu_npre_supp_percent_p=round(100*Neu_npre_supp_p/Neu_sig_both);
text(-1, 1.1, ['Np. supp. neu. sig =',num2str(Neu_npre_supp_percent_p),...
    '% ',num2str(Neu_npre_supp_p),'/',num2str(Neu_sig_both)]);

T1x=EU_File_me_sd_driven(TSpkr_Rank<=3&p_cut,2); 
T1y=EU_File_me_sd_driven(TSpkr_Rank<=3&p_cut,3);
xt=T1x(c1_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>=yt))/numel(xt)); 
text(-0.8, -0.2, ['Pre. supp. sess. sig=',num2str(pert),'% ',...
    num2str(numel(find(xt>yt))),'/',num2str(numel(xt))])

T15x=EU_File_me_sd_driven(TSpkr_Rank>=13&p_cut,2); 
T15y=EU_File_me_sd_driven(TSpkr_Rank>=13&p_cut,3);
xt=T15x(c15_p); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15_p); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz/2,rgb('black'),'Marker','.','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(yt>xt))/numel(yt)); 
text(-1, 1.7, ['Np. faci. sess. sig=',num2str(pert),'% ',...
    num2str(numel(find(yt>=xt))),'/',num2str(numel(xt))])
xlim(r_axis); ylim(r_axis); 
xticks([-1 0 1 2]); xticklabels({'-10', '0', '10', '100'});% for log scale
yticks([-1 0 1 2]); yticklabels({'-10', '0', '10', '100'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Driven rate mean (spikes/s)')
%% Driven rate stacked bar of pre/nonpre for session and neuron
figure
tiledlayout(1,2,"TileSpacing","compact"); %1 line
nexttile;
pre_bars_1=[63 10];
pre_bars_2=[32 5];
pre_bars_3=[29 5];
pre_bars_4=[5 2];
bar(1:4, [pre_bars_1/73;pre_bars_2/37;...
    pre_bars_3/34;pre_bars_4/7],'stacked')
nexttile;
npre_bars_1=[73 28];
npre_bars_2=[15 1];
npre_bars_3=[31 3];
npre_bars_4=[7 0];
bar(1:4, [npre_bars_1/101;npre_bars_2/16;...
    npre_bars_3/34;npre_bars_4/7],'stacked')
%% Spontaneous rates---use <EU_File_me_sd_spontn>
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
sz=30; rank=[1,15]; r_axis=[0, log10(30)]; 
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color',[0.5,0.5,0.5]); hold on
p_cut=EU_File_me_sd_spontn(:,4)<0.05;
T1x=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,1); 
T1y=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,3);
T15x=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,1); 
T15y=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,3);
c1=find(ismember(T1x,T15x));c15=find(ismember(T15x,T1x));
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('Black'),'Marker','*','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 1.3, ['Prefer  X>Y',num2str(pert),'%'])
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('Black'),'Marker','*','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 1.2, ['Non-prefer  X>Y',num2str(pert),'%'])
xlim(r_axis); ylim(r_axis);
xticks([0 log10(3) log10(30)]); xticklabels({'0', '3', '30'});% for log scale
yticks([0 log10(3) log10(30)]); yticklabels({'0', '3', '30'});
xlabel('Equal-prob. 15 spkrs'); ylabel('100% prob. target spkr.');
title('Spontaneous firing rate (spikes/s)')
nexttile;
plot(r_axis, r_axis, 'LineStyle','-.','Color','k'); hold on
T1x=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,2); 
T1y=EU_File_me_sd_spontn(TSpkr_Rank<=3&p_cut,3);
T15x=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,2); 
T15y=EU_File_me_sd_spontn(TSpkr_Rank>=13&p_cut,3);
xt=T1x(c1); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T1y(c1); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('Black'),'Marker','*','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 1.3, ['Prefer  X>Y',num2str(pert),'%'])
xt=T15x(c15); xt(xt>=0) = log10(1+xt(xt>=0)); xt(xt<0) = -log10(1-xt(xt<0));
yt=T15y(c15); yt(yt>=0) = log10(1+yt(yt>=0)); yt(yt<0) = -log10(1-yt(yt<0));
scatter(xt,yt,sz,rgb('Black'),'Marker','*','MarkerFaceAlpha',.5); hold on
pert=round(100*numel(find(xt>yt))/numel(xt)); text(0, 1.2, ['Non-prefer  X>Y',num2str(pert),'%'])
xlim(r_axis); ylim(r_axis); 
xticks([0 log10(3) log10(30)]); xticklabels({'0', '3', '30'});% for log scale
yticks([0 log10(3) log10(30)]); yticklabels({'0', '3', '30'});
xlabel('Equal prob. target spkr.'); ylabel('100% prob. target spkr.');
title('Spontaneous firing rate (spikes/s)')