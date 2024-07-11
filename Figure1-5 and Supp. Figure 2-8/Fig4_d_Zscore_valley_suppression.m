% for M43q change negative unit to positive; all positive in others 
% file#186--190, unit==+766, Ch==3; file#191--207, unit==-766, Ch==2; 
% Z-score the U/E Files of individual session
% Z-score the UFile using only the mean&sigma from EFile
% Z-score the artifically generated UFile that have same mu&sigma as Efile
% modified @ 2022-12-29

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
TSpkr_Rank=nan(N,1);
C1 = [185,141,62]/256; %brown
C2 = [100,168,96]/256; %green
w=0;
for n = 1 : N
    U=Basic_AU_Data{1, n};  
    TSpkr_Rank(n)=U.TSpkr_Rank;
    EFile_all=U.EFile_Numbers;
    %not needed for changing to rate using <1000*X/U.Patch_Data.Analysis_Window_Length>
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
end    

%% trials averaged Zscore of EFiles and UFiles for 8 speaker ranks
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.02 Y_size*0.35 X_size*0.3 Y_size*0.24]);%1 line
rng('default') % fix the random number generator (rng)
range = 100 ; %line plot range
smr = 3 ;%line smooth range
spkr_rank=find(TSpkr_Rank<=3);
N_units=numel(spkr_rank);
zsU=nan(N_units, range);

for n = 1 : N_units
    E_rates=EFile_spikes_all{spkr_rank(n)}; 
    [zsE,muE,sigmaE]=zscore(E_rates);
    U_rates=UFile_spikes_all{spkr_rank(n)}; 
    if numel(U_rates)>range
        U_rates=U_rates(1:range);
    end
    if sigmaE~=0&&numel(U_rates)>=range&&max(U_rates)>0
        zsU(n, :)=(U_rates-muE)/sigmaE;
    end    
end

zsU(isnan(zsU(:,1)),:)=[];%remove NaN units due to sigmaE==0
N_units=size(zsU,1);
zsU_m_temp=smooth(mean(zsU(:,1:range)),smr);
zsU_m_temp(1)=mean(mean(zsU(:,1:smr)));
% shadedErrorBar(1:range, zsU_m_temp,std(zsU(:,1:range))/sqrt(size(zsU,1)),...
%     'lineProps',{'Color',C2,'LineWidth',2,'LineStyle','-'});hold on
% plot(1:range, mean(zsU_m_temp)*ones(1,range),'LineStyle','-.','Color',C2)
% text(range-20,0.8,[num2str(N_units),'sessions'] )
% xlim([1 range]);

zsU = zsU(:, 1:range);
[num_vars, num_bins] = size(zsU);
smoothed_data = zeros(size(zsU));
valley_times = zeros(num_vars, 1);
for i = 1 : num_vars % 
    trace = smooth(zsU(i, :), smr); % 3&4 the same
    trace = trace/abs(min(trace));
    smoothed_data(i, :) = trace;
%     if max(smooth(zsU(i, :), smr))<=0
%         smoothed_data(i, :)=nan;
%     end    
%     if min(trace)<=-40
%         smoothed_data(i, :)=nan;
%     end    
    [~, valley_times(i)] = min(smoothed_data(i, :)); 
end
removed_id=isnan(smoothed_data(:,1));
smoothed_data(removed_id, :)=[];
valley_times(removed_id)=[];
[sorted_peak_times, sort_indices] = sort(valley_times); % Sort variables based on the time of the first peak
sorted_zsU = smoothed_data(sort_indices, :); % Reorder the matrix according to the sorted indices
imagesc(sorted_zsU)
caxis([-1, 1.]);