function [p_All_Ex, p_All_In] = adaptation_IE (AD_Ex, AD_In, tau_p_Ex, tau_p_In)

% compute the release probability of Ex and In synapses
% by CCG @ 2021-12-04

step=.001; % [S] 
stimulus_duration = 150 ;  % [S]===300 stimuli/trials
stimulus_length = length(step:step:(stimulus_duration));
freq = 2 ; %number of stimuli per second (ISI=500ms)
ISI = round(1/(freq*step)); %number of points between each stimulus, smaller==large adaptation

P0_Ex = 1;           %initial probability always==1
P0_In = 1;             %initial probability always==1

p = 0;
P_rel_Ex = nan(stimulus_length, 1); 
P_rel_In = nan(stimulus_length, 1); 
P_rel_Ex(1) = P0_Ex;
P_rel_In(1) = P0_In;
for i = 1 : ISI : stimulus_length
    p = p+1; %Click/stimulus number (starts with 1)
    t0 = i ; %Initial probability at each (new) stimulus onsets; don't need jitter here
    for t = t0 : (t0+ISI-1) %trace/curve of each individual trace
        decay_Ex = exp(-(t+1-t0)*step/tau_p_Ex) ;
        decay_In = exp(-(t+1-t0)*step/tau_p_In) ;
        P_rel_Ex(t+1) = P0_Ex + (AD_Ex*P_rel_Ex(t0)-P0_Ex)*decay_Ex; %function in Dayan&Abbott 2001 textbook (Page 185)
        P_rel_In(t+1) = P0_In + (AD_In*P_rel_In(t0)-P0_In)*decay_In;      
    end
end
p_All_In = P_rel_In(1: ISI: stimulus_length);
p_All_Ex = P_rel_Ex(1: ISI: stimulus_length);