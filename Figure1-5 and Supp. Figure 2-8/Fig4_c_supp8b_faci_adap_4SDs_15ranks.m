% compare the UFile with Tspkr in EFile
% compute the faci/adap trials based on 0.5/1/1.5/2 standard deviation 
% use > & < as threshold but not >= & <=
% 2022-12-25

clear;clc; rng(100)
close all
load('Basic_AU_Data.mat')
load('All_files_info.mat') % Animal File Reps Unit Channel 1 2 3 4
N=length(Basic_AU_Data);
N_UFile_rates=nan(N,1);%number of repeats for Tspkr in repeated present mode
N_EFile_rates=nan(N,1);%number of repeats for Tspkr in equal-prob mode
EFile_r_all=cell(N,1);%number of repeats for Tspkr in <EACH> equal-prob mode
EFile_spikes_all=cell(N,1); 
UFile_spikes_all=cell(N,1); 
TSpkr_Rank=nan(N,1); faci_1sd_sheng=nan(N,1); adap_1sd_sheng=nan(N,1);
w=0;
for n = 1 : N
    U=Basic_AU_Data{1, n};  
    TSpkr_Rank(n)=U.TSpkr_Rank;
    EFile_all=U.EFile_Numbers;
    EFile_spikes_all{n}=U.Patch_Data.EFile_Rel_Driven_Spcounts_TSpkr;
    UFile_spikes_all{n}=U.Patch_Data.UFile_Rel_Driven_Spcounts;
    N_EFile_rates(n)=numel(EFile_spikes_all{n});
    N_UFile_rates(n)=numel(UFile_spikes_all{n});
    switch U.Monkey_ID
        case 'M50p'
            ani=1;
        case 'M43s'
            ani=2;
        case 'M43q'
            ani=3;    
    end   
    N_files=numel(EFile_all); EFile_r=nan(N_files,1);    
    for f = 1 : N_files
    EFile_r(f)=Info((Info(:,1)==ani&Info(:,2)==EFile_all(f)),3);
    end
    EFile_r_all{n}=EFile_r;
    faci_1sd_sheng(n)=U.U_Faci_Data.Faci_Duration;
    adap_1sd_sheng(n)=U.Adap_Data.Adap_Duration;
end    
%% remove 8 UFiles that have <50 repeats
% N_void=find((N_UFile_rates<50)|(N_EFile_rates<5));
% EFile_spikes_all(N_void)=[]; UFile_spikes_all(N_void)=[]; TSpkr_Rank(N_void)=[];
%% trials averaged Zscore of EFiles and UFiles for 8 speaker ranks
thres_test=[0.5, 1, 1.5, 2]; Nthres=numel(thres_test); Nspkr=15;
faci_thres_all=nan(Nthres,N); adap_thres_all=nan(Nthres,N);
for s = 1 : Nthres
    for n = 1 : N
        U_rates=UFile_spikes_all{n};
        E_rates=EFile_spikes_all{n}; 
        [~,muE,sigmaE]=zscore(E_rates); 
        faci_thres=muE+thres_test(s)*sigmaE; adap_thres=muE-thres_test(s)*sigmaE;
        faci_percent=numel(find(U_rates>faci_thres))/numel(U_rates);
        adap_percent=numel(find(U_rates<adap_thres))/numel(U_rates);
        faci_thres_all(s,n)=100*faci_percent; adap_thres_all(s,n)=100*adap_percent;
    end    
end    

section_num_2D=nan(Nthres,Nspkr); section_num_all=nan(1,Nspkr);
faci_dur_2D_me=nan(Nthres,Nspkr); %faci_dur_all_me=nan(1,Nspkr);
faci_dur_2D_sd=nan(Nthres,Nspkr); %faci_dur_all_sd=nan(1,Nspkr);
adap_dur_2D_me=nan(Nthres,Nspkr); %adap_dur_all_me=nan(1,Nspkr);
adap_dur_2D_sd=nan(Nthres,Nspkr); %adap_dur_all_sd=nan(1,Nspkr);

for sd=1:Nthres
    for sk=1:Nspkr
        idx=find(TSpkr_Rank==sk);
        section_num_2D(sd,sk)=numel(idx);
        
        if numel(idx)>=4
        faci_dur_2D_me(sd,sk)=mean(faci_thres_all(sd,idx));
        faci_dur_2D_sd(sd,sk)=std(faci_thres_all(sd,idx))/sqrt(section_num_2D(sd,sk));
        adap_dur_2D_me(sd,sk)=mean(adap_thres_all(sd,idx));
        adap_dur_2D_sd(sd,sk)=std(adap_thres_all(sd,idx))/sqrt(section_num_2D(sd,sk));
        end
    end
end    
%%
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.02 Y_size*0.35 X_size*0.5 Y_size*0.3]);%1 line
tiledlayout(1,4,"TileSpacing","compact"); %1 line
sz=4;
for sd=1:Nthres
    nexttile
    errorbar(1:Nspkr,faci_dur_2D_me(sd,:),faci_dur_2D_sd(sd,:),'Color',rgb('SandyBrown'));
    hold on
    plot(1:Nspkr,faci_dur_2D_me(sd,:),'LineStyle','none','Marker','o',...
    'MarkerSize',sz,'MarkerEdgeColor','none','MarkerFaceColor',rgb('SandyBrown'))
    errorbar(1:Nspkr,adap_dur_2D_me(sd,:),adap_dur_2D_sd(sd,:),'Color',rgb('SteelBlue'));
    xlim([0 16]);xticks([1,8,15]);xticklabels({'1','8','15'}); ylim([0 50])
    plot(1:Nspkr,adap_dur_2D_me(sd,:),'LineStyle','none','Marker','o',...
    'MarkerSize',sz,'MarkerEdgeColor','none','MarkerFaceColor',rgb('SteelBlue'))
%     if sd==1
    xlabel('Speaker rank');%ylabel('Proportion of faci./adap. trials (%)')
    title(['thres.=\mu+',num2str(thres_test(sd)),...
    '\sigma or <\mu-',num2str(thres_test(sd)),'\sigma'])
%     end    
end