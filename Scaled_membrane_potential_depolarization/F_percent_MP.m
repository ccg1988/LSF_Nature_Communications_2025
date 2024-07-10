function [f_percent, f_long_percent, firing_rate] = F_percent_MP(num_random, num_repeat, depo_value, IE_ratio, spike_num_Poi, noise_magnitude, Espike_scale, rate_range) 

% similar to "F_percent_IE"
% called by: F_percent_MP_master.m
% call: LIFmodel_MP.m
% by CCG @ 2021-12-05

nreps = num_random+num_repeat ;
Erest_base = -0.069 ; %more negative, more spikes_____FIXED
Erest_depo = Erest_base + depo_value ;

num_Erest_step = 30 ; % number of trials to deporalize_____FIXED
Erest_step = (Erest_depo-Erest_base)/(num_Erest_step-1) ;
Erest_slope = (Erest_base : Erest_step: Erest_depo) ; 

Erest = nan(nreps, 1) ;
Erest(1:num_random) = Erest_base*ones(num_random, 1) ;
Erest((num_random+1):(num_random+num_Erest_step)) = Erest_slope ;
Erest((num_random+num_Erest_step+1):end) = Erest_depo*ones((nreps-num_random-num_Erest_step), 1) ;

Espike = Erest_base*ones(nreps, 1) ;
Espike_depo = Erest_base + depo_value*Espike_scale ;
Espike_step = (Espike_depo-Erest_base)/(num_Erest_step-1) ;
Espike_slope = (Erest_base : Espike_step: Espike_depo) ; 
Espike((num_random+1):(num_random+num_Erest_step)) = Espike_slope; %2nd part---transition
Espike((num_random+num_Erest_step+1):end) = (Erest_base + depo_value*Espike_scale)*ones((nreps-num_random-num_Erest_step), 1) ; %3rd part---de-polarization

spike_thres = Espike + 0.020 ;  %20 mV above Erest as spike threshold; more negative, more spikes

MP_noise_magnitude = 2/1000 ;
Erest= Erest + MP_noise_magnitude*randn(nreps, 1);

E_strength = ones(nreps, 1) ; 
I_strength = ones(nreps, 1) * IE_ratio ;

synapse_num_Ex = 10 ;    % N excitatory synaptic inputs (Wehr and Zador)
synapse_num_In = 10 ;    % N inhibitory synaptic inputs
kernel_time_constant=.005;  %time constant of 5 ms (Wehr and Zador)
step=.0001; % [S]
stimulus_duration=0.5;  %half second
PREstimulus_duration=0.2;  
POSTstimulus_duration=0.3; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%acoustic pulse train stimulus%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_distribution_raw=NaN(1, nreps);
spont_distribution=NaN(1, nreps);
t=step:step:(kernel_time_constant*10);
kernel=t.*exp(-t/kernel_time_constant); %1D vector  a=1/kernel_time_constant
kernel=1e-9*kernel/max(kernel); %amplitude of 1 nS (shape of single spike)
input=zeros(size(step:step:(POSTstimulus_duration+stimulus_duration)));
stimulus_input_length=length(0:step:(stimulus_duration));
for r = 1 : nreps
    E_input = input;
    I_input = input;
    spike_num = poissrnd(spike_num_Poi);
    spike_gap = floor(stimulus_input_length/spike_num) ;
    for i = 1 :  spike_num
        time_window_end = (i-1)*spike_gap + length(kernel);
        time_window_start = 1 + time_window_end-length(kernel);
        time_window = time_window_start : time_window_end ;
        E_input (time_window) =  E_input (time_window)+kernel*synapse_num_Ex; %assign curve at specific point range
        I_input (time_window) = I_input (time_window)+kernel*synapse_num_In;
    end
    Ge=E_input * E_strength(r); %number of kernels * kernel amplitude(A; nS)
    Gi=I_input * I_strength(r);
    pre_chunk=zeros(size(step : step : PREstimulus_duration)); %1D vector
    Ge=[pre_chunk Ge]; %add pre stim time
    Gi=[pre_chunk Gi];
    [spikes, ~] = LIFmodel_MP(Ge, Gi, noise_magnitude, Erest(r), spike_thres(r)); %Excitatory and Inhibitory conductance (nS)!!! 
    spikes=spikes-PREstimulus_duration; %remove the spike points within pre_stim window
    spike_distribution_raw(r)=length( spikes(spikes>0 & spikes<=stimulus_duration))/stimulus_duration; %not consider 0.1s b/c no delay
    spont_distribution(r)=length( spikes(spikes>-PREstimulus_duration & spikes<0) )/PREstimulus_duration; %spon rate during pre-sound
end
spike_distribution = spike_distribution_raw - spont_distribution ;

f_thres = mean(spike_distribution(1:num_random))+std(spike_distribution(1:num_random));
f_percent=length(find(spike_distribution(rate_range)>f_thres))/(num_repeat-num_Erest_step);

t = spike_distribution(rate_range)>f_thres;
id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
seg_length = (id_end - id_start) + 1; %careful
id_seg = seg_length >= 5 ;
f_long_percent = sum(seg_length(id_seg))/(num_repeat-num_Erest_step);

firing_rate = mean(spike_distribution(rate_range));