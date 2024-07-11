% compare the UFile with Tspkr in EFile
% compute the faci/adap trials based on 0.5/1/1.5/2 standard deviation 
% use > & < as threshold but not >= & <=
% 2022-12-25

clear;clc; rng(100)
% close all
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
% remove 8 UFiles that have <50 repeats
% N_void=find((N_UFile_rates<50)|(N_EFile_rates<5));
% EFile_spikes_all(N_void)=[]; UFile_spikes_all(N_void)=[]; TSpkr_Rank(N_void)=[];
% trials averaged Zscore of EFiles and UFiles for 8 speaker ranks
thres_test = [0.5, 1, 1.5, 2] ; 
Nthres=numel(thres_test); Nspkr=15;
trial_len_U=50; % lower limit for considering consec-trials in UFile
trial_len_E=5; % lower limit for computing mu&sigma in EFile
faci_thres_equal=nan(Nthres,N); adap_thres_equal=nan(Nthres,N); % EFile real
faci_thres_all=nan(Nthres,N); adap_thres_all=nan(Nthres,N);
faci_thres_all_fake=nan(Nthres,N); adap_thres_all_fake=nan(Nthres,N); % EFile match
faci_thres_long=nan(Nthres,N); adap_thres_long=nan(Nthres,N); %only consider long trials
    % not very useful, since lots of trials are still short duration
%for s = 1 : 1              % specified 1 SD
for s = 1 : Nthres          % test all 4 SDs
    for n = 1 : N 
    %for n = 1 : 1          % specified neuron
    U_rates=UFile_spikes_all{n};
    E_rates=EFile_spikes_all{n}; 
    if sum(abs(U_rates))~=0 && numel(U_rates)>=trial_len_U && sum(abs(E_rates))~=0 && numel(E_rates)>=trial_len_E
        [~,muE,sigmaE]=zscore(E_rates); 
        faci_thres=muE+thres_test(s)*sigmaE; 
        adap_thres=muE-thres_test(s)*sigmaE;

        faci_percent=numel(find(E_rates>faci_thres))/numel(E_rates);
        faci_percent=round(faci_percent/0.05)*0.05;
        adap_percent=numel(find(E_rates<adap_thres))/numel(E_rates);
        adap_percent=round(adap_percent/0.05)*0.05;
        faci_thres_equal(s,n)=int64(100*faci_percent); 
        adap_thres_equal(s,n)=int64(100*adap_percent);

        faci_percent=numel(find(U_rates>faci_thres))/numel(U_rates);
        faci_percent=round(faci_percent/0.05)*0.05;
        adap_percent=numel(find(U_rates<adap_thres))/numel(U_rates);
        adap_percent=round(adap_percent/0.05)*0.05;
        faci_thres_all(s,n)=int64(100*faci_percent); 
        adap_thres_all(s,n)=int64(100*adap_percent);

        U_rates_fake=normrnd(muE,sigmaE,[1,numel(U_rates)]);
        faci_percent=numel(find(U_rates_fake>faci_thres))/numel(U_rates);
        faci_percent=round(faci_percent/0.05)*0.05;
        adap_percent=numel(find(U_rates_fake<adap_thres))/numel(U_rates);
        adap_percent=round(adap_percent/0.05)*0.05;
        faci_thres_all_fake(s,n)=int64(100*faci_percent); 
        adap_thres_all_fake(s,n)=int64(100*adap_percent);

        t = U_rates > faci_thres;
        id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
        id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
        seg_length = (id_end - id_start)+1 ; %5-6-7-8-9 is 5 trials so the segment length is: 9-5+1=5
        seg_length(seg_length<5)=[];
        faci_percent=sum(seg_length)/numel(U_rates);
        % faci_percent=round(faci_percent/0.05)*0.05;
        faci_thres_long(s,n)=int64(100*faci_percent); 
    end % if condition
    end % internal for loop   
end    
C{1} = [153,112,193]/256; %violet
C{2} = [185,141,62]/256; %brown
C{3} = [100,168,96]/256; %green
C{4} = [204,84,94]/256; %pink-red
percent_round = 0 : 5 : 100; Npercent = numel(percent_round);
%% for facilitation that outside of Gaussian distribution
fig = figure; fig.Units = "centimeters";
fig.Color = "White"; %evenif using 'None', there is a still white-filled square
fig.InnerPosition = [10, 12, 12, 10] ; % single SD figure
fig.InnerPosition = [10, 6, 25, 15] ; % four   SD figure
fig.PaperSize = fig.Position(3:4); fig.PaperUnits = "centimeters" ;
faci_percent_in_session=nan(Nthres, Npercent); 
faci_percent_in_session_fake=nan(Nthres, Npercent);
faci_percent_out_of_gaussian=nan(Nthres,1);
faci_thres_all(:, faci_thres_long(2,:)==0)=[];        % show sessions with >=5 long trials
faci_thres_all_fake(:, faci_thres_long(2,:)==0)=[];   % show all sessions
% for s = 2 : 2         % display one 1 SD 
for s = 1 : Nthres      % display one 4 SDs
    for t = 1 : Npercent
        faci_percent_in_session(s, t)=numel(find(faci_thres_all(s,:)==percent_round(t)));
        faci_percent_in_session_fake(s, t)=numel(find(faci_thres_all_fake(s,:)==percent_round(t)));
    end
    %plot(1:Npercent, 100*faci_percent_in_session(s, :)/N,'LineWidth',0.3,'Color',C{s});hold on
    plot(1:Npercent, 1*faci_percent_in_session(s, :)/1, ...
        'LineWidth',0.3,'Color',C{s},'Marker','.','MarkerSize',20);hold on
    plot(1:Npercent, 1*faci_percent_in_session_fake(s, :)/1, ...
        'LineStyle','-.','LineWidth',1,'Color',C{s},'Marker','o');hold on
    faci_idx=find(faci_percent_in_session(s,:)>faci_percent_in_session_fake(s,:));
    [~,peak_id]=max(faci_percent_in_session_fake(s, :));
    faci_idx(faci_idx<peak_id)=[];%remove values that smaller than Gaussian distribution
    plot(faci_idx, 1*faci_percent_in_session(s, faci_idx)/1, ...
        'LineWidth',2,'Color',C{s},'Marker','.','MarkerSize',20);hold on
    faci_percent_out_of_gaussian(s)=sum(100*faci_percent_in_session(s, faci_idx)/N);
end    
% set(gca, 'YScale', 'log');
xticks(1:Npercent);xlabel('Proportion of facilitation trials (%)')
xticklabels({'0','5','10','15','20','25','30','35','40','45','50', ...
    '55','60','65','70','75','80','85','90','95','100'});
% xlim([1 11]) % 5% to 50%
xlim([1 Npercent]) % 0% to 100%
% ylabel('Proportion of sessions (%)');
ylabel('Session #');
% ylim([0 30])
title('Facilitation equal vs 100%')
% legend({'100%-prob.', 'equal-prob.', '100%-prob.>equal-prob.'})
legend({'','\mu+0.5\sigma equal',['100% prob. ',num2str(faci_percent_out_of_gaussian(1)),'%'], ...
    '','\mu+1.0\sigma equal',['100% prob. ',num2str(faci_percent_out_of_gaussian(2)),'%'], ...
    '','\mu+1.5\sigma equal',['100% prob. ',num2str(faci_percent_out_of_gaussian(3)),'%'], ...
    '','\mu+2.0\sigma equal',['100% prob. ',num2str(faci_percent_out_of_gaussian(4)),'%']}, ...
    'Box','off')
exportgraphics(gcf, 'Fig3_percent_faci_trials equal vs 100.pdf','ContentType','vector',...
    'BackgroundColor','none')
%% for adaptation that outside of Gaussian distribution
fig = figure; fig.Units = "centimeters";
fig.Color = "White"; %evenif using 'None', there is a still white-filled square
fig.InnerPosition = [10, 12, 20, 10] ; 
fig.PaperSize = fig.Position(3:4); fig.PaperUnits = "centimeters" ;
adap_percent_in_session=nan(Nthres, Npercent); 
adap_percent_in_session_fake=nan(Nthres, Npercent);
adap_percent_out_of_gaussian=nan(Nthres,1);
for s = 1 : Nthres
    for t = 1 : Npercent
        adap_percent_in_session(s, t)=numel(find(adap_thres_all(s,:)==percent_round(t)));
        adap_percent_in_session_fake(s, t)=numel(find(adap_thres_all_fake(s,:)==percent_round(t)));
    end
    %plot(1:Npercent, 100*adap_percent_in_session(s, :)/N,'LineWidth',0.3,'Color',C{s});hold on
    plot(1:Npercent, 100*adap_percent_in_session(s, :)/N,'LineWidth',0.3, ...
        'Color',C{s});hold on
    plot(1:Npercent, 100*adap_percent_in_session_fake(s, :)/N, ...
        'LineStyle','-.','LineWidth',1,'Color',C{s});hold on
    adap_idx=find(adap_percent_in_session(s,:)>adap_percent_in_session_fake(s,:));
    [~,peak_id]=max(adap_percent_in_session_fake(s, :));
    adap_idx(adap_idx<peak_id)=[];%remove values that smaller than Gaussian distribution
    plot(adap_idx, 100*adap_percent_in_session(s, adap_idx)/N,'LineWidth',2,'Color',C{s});hold on
    adap_percent_out_of_gaussian(s)=sum(100*adap_percent_in_session(s, adap_idx)/N);
end    
xticks(1:Npercent);xlabel('Proportion of adaptation trials (%)')
xticklabels({'0','5','10','15','20','25','30','35','40','45','50', ...
    '55','60','65','70','75','80','85','90','95','100'});
% xlim([1 11]) % 5% to 50%
xlim([1 Npercent]) % 0% to 100%
% ylabel('Proportion of sessions (%)');
ylabel('Session #');
ylim([0 65])
title('Adaptation equal vs 100%')
legend({'','\mu+0.5\sigma equal',['100% prob. ',num2str(adap_percent_out_of_gaussian(1)),'%'], ...
    '','\mu+1.0\sigma equal',['100% prob. ',num2str(adap_percent_out_of_gaussian(2)),'%'], ...
    '','\mu+1.5\sigma equal',['100% prob. ',num2str(adap_percent_out_of_gaussian(3)),'%'], ...
    '','\mu+2.0\sigma equal',['100% prob. ',num2str(adap_percent_out_of_gaussian(4)),'%']}, ...
    'Box','off')
exportgraphics(gcf, 'Fig2Sup_percent_adap_trials in 4 thres.pdf','ContentType','vector',...
    'BackgroundColor','none')