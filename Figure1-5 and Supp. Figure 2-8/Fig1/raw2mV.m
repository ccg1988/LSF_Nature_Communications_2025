function [mV] = raw2mV(raw)

% simple program to change the raw-signal in our syetem to mV

amp_gain = 10;
system_bitdepth = 16;
scale_factor = (((10/2^(system_bitdepth-1)))/amp_gain).*10^3; %mV
mV = raw*scale_factor;