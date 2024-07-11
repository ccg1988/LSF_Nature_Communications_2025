function [driven_rates, rel_driven_rates] = EFile_rate_processing(x,ch_number,onset_time,offset_time)
% not need to compute spontanoues rate since it's already in EFile_ptach_data
% input x: original data structure x
% input onset/offset time: time window to calculate firing rate
% 2022-12-25

data=x.data;
pre_stim = x.pre_stimulus_record_time;  % in mS
stim_dur = x.stimulus_ch1(1,5); % in mS

tmin = pre_stim + onset_time;
tmax = pre_stim + stim_dur + offset_time;
    
stim = max(data(:,1));
for i = 1:stim
    reps(i) = max(data(data(:,1) == i,2));
end

% spkr_number_vector = [];

if strcmp(x.trial_complete,'true') ==  0
    % delete unfinished repetition's data
    data(data(:,2)>min(reps),:)=[];
end
data(data(:,3)~=ch_number |data(:,4)==-1,:)=[]; %get rid of -1 and other channels
data(:,4)=round(data(:,4)/1000); %convert to ms
spont_rates=nan(stim,min(reps)); rel_driven_rates=nan(stim,min(reps)); driven_rates=nan(stim,min(reps));
for i = 1:stim
%     spkr_number_vector(i) = x.stimulus_ch1(i,2);
    for j = 1:min(reps)
        spont_train = data(data(:,1)==i & data(:,2)==j & data(:,4) <= pre_stim,4);   %in mS  
        spike_train = data(data(:,1)==i & data(:,2)==j & data(:,4)>=tmin & data(:,4) <= tmax,4);   %in mS 
        spont_rates(i,j) = 1000*length(spont_train)/pre_stim; % spikes/ms
               
        driven_rates(i,j) = 1000*length(spike_train)/(tmax-tmin); % spike counts
        % use pre_stim*(tmax-tmin) to normalize spont_train which has different duration(but same repeats)
        rel_driven_spcounts = length(spike_train) - length(spont_train)/pre_stim*(tmax-tmin);
        rel_driven_rates(i,j) = 1000*rel_driven_spcounts/(tmax-tmin);
        clear spont_train spike_train;
    end
end
