% modified from LIFmodel_basic (Bendor, PLOS Computational Biology, 2015)
% call function "adaptation_IE.m" to generate "p_All_Ex" and "p_All_In"
% call function "LIFmodel_IE.m" to generate "spikes" and "MP"
% for 5shuffles*10stepsEx*10stepsIn=500, it took almost 4 days
% by CCG @ 2024-06-26

clear; clc

shuffle_N = 5 ;
f_percent_all = nan(shuffle_N, 1);
f_long_percent_all = nan(shuffle_N, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%acoustic pulse train stimulus%%%%%%%%%%%%%%%%%%%%%%%%%%
stimulus_duration=0.5;  %half second
PREstimulus_duration=0.2;  
POSTstimulus_duration=0.3; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%model parameters%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_num_Poi = 20 ; % Number of Possion spikes
noise_magnitude = 2.5e-8 ; %default noise level in conductance--decide firing rate (>Ge and Gi)
IE_ratio = 1 ;
num_random = 20 ;
num_repeat = 300 ;
nreps = num_random + num_repeat ;
step=.0001; % [S]
Erest = -0.069 ; % more negative, more spikes_____FIXE
IE_delay = 0.005 ; % + means Ex lead In, longer delay==more spikes

synapse_num_Ex = 10 ;    % N excitatory synaptic inputs (Wehr and Zador)
synapse_num_In = 10 ;    % N inhibitory synaptic inputs
kernel_time_constant=.005;  %time constant of 5 ms (Wehr and Zador)
tau_p_Ex = 20 ; % [S]
tau_p_In = 20 ; % smaller value==quicker recovery to initial value at t0

AD_Ex_all = 0.901:0.01:1;
AD_In_all = 0.901:0.01:1;
shuffle_N_AD = numel(AD_Ex_all);
AD_Ex_2D = nan(shuffle_N_AD, shuffle_N_AD);
AD_In_2D = nan(shuffle_N_AD, shuffle_N_AD);
f_percent_all_2D = nan(shuffle_N_AD, shuffle_N_AD);
f_long_percent_all_2D = nan(shuffle_N_AD, shuffle_N_AD);

for ex = 1 : shuffle_N_AD
    for in = 1 : shuffle_N_AD
        AD_Ex = AD_Ex_all(ex) ; 
        AD_In = AD_In_all(in) ; 
        AD_Ex_2D(ex, in) = AD_Ex;
        AD_In_2D(ex, in) = AD_In;
        [p_All_Ex, p_All_In] = adaptation_IE (AD_Ex, AD_In, tau_p_Ex, tau_p_In);
        E_strength = [ones(num_random, 1); p_All_Ex] ; 
        I_strength = [ones(num_random, 1); p_All_In] * IE_ratio ; %more trials in the <equal-presentation-mode> will make the results more reliable
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%acoustic pulse train stimulus%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for shu = 1 : shuffle_N
            spike_distribution=NaN(1, nreps);
            spont_distribution=NaN(1, 1*nreps);
            raster.stim=[];  raster.rep=[];  raster.spikes=[];
            
            t=step:step:(kernel_time_constant*10);
            kernel=t.*exp(-t/kernel_time_constant); %1D vector  a=1/kernel_time_constant
            kernel=1e-9*kernel/max(kernel); %amplitude of 1 nS (shape of single spike)
            
            input=zeros(size(step:step:(POSTstimulus_duration+stimulus_duration)));
            stimulus_input_length=length(step:step:(stimulus_duration));
            
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
                
                delay=round(abs(IE_delay)/(1000*step));  % delay in steps, single value
                delay_chunk=zeros(1,delay); %1D vector
                Ge=E_input * E_strength(r); %number of kernels * kernel amplitude(A; nS)
                Gi=[delay_chunk I_input(1:(length(I_input)-delay))] * I_strength(r);
             
                pre_chunk=zeros(size(step : step : PREstimulus_duration)); %1D vector
                Ge=[pre_chunk Ge]; %add pre stim time
                Gi=[pre_chunk Gi];  
               
                [spikes, MP_all] = LIFmodel_IE (Ge, Gi, noise_magnitude, Erest); %Excitatory and Inhibitory conductance (nS)!!!
                spikes=spikes-PREstimulus_duration; %negative value means the AP is during Prestimulus period
                spike_distribution(r)=length( spikes(spikes>0 & spikes<=stimulus_duration))/stimulus_duration; %spike rate (w/o spon) during sound
                spont_distribution(r)=length( spikes(spikes>-PREstimulus_duration & spikes<0) )/PREstimulus_duration; %spon rate during pre-sound
                
                raster.stim=[raster.stim ones(size(spikes))];
                raster.rep=[raster.rep r*ones(size(spikes))];
                raster.spikes=[raster.spikes spikes];
            end
            spike_distribution_driven = spike_distribution - spont_distribution ;
            f_thres = mean(spike_distribution(1:num_random))+std(spike_distribution(1:num_random));
            f_thres_trace = f_thres*ones(length(spike_distribution), 1);
            f_percent_all(shu)=length(find(spike_distribution((num_random+1):end)>f_thres))/num_repeat;
            
            t = spike_distribution((num_random+1):end)>f_thres;
            id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
            id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
            seg_length = (id_end - id_start)+1 ;% [1 2 3] has 3 elements (3-1)+1
            id_seg = seg_length >= 5 ;
            f_long_percent_all(shu) = sum(seg_length(id_seg))/num_repeat;
        end
        f_percent_all_2D(ex, in)=mean(f_percent_all)*100;
        f_long_percent_all_2D(ex, in)=mean(f_long_percent_all)*100;
        disp(['AD_Ex=', num2str(AD_Ex), ' AD_In=', num2str(AD_In), '  ', ...
            num2str(f_percent_all_2D(ex, in)), '%'])
    end % In-AD
end % Ex-AD
%%
figure;
value_min = 30;
value_max = 50;

imagesc(f_percent_all_2D); axis equal
hold on
contour(f_percent_all_2D, [value_min value_max], 'ShowText', 'on', ...
    'LineWidth',3,'LineColor','w');
colorbar;

title('Proportion of facilitation trials');
xlabel('In synaptic strength after each stimulus'); 
xticks(0:2:10)
xticklabels({'0.90','0.92','0.94','0.96','0.98','1'});
ylabel('Ex synaptic strength after each stimulus'); 
yticks(0:2:10)
yticklabels({'0.90','0.92','0.94','0.96','0.98','1'});
