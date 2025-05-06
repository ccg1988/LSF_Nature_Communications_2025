% Compared to v1, the long facilitation phase is shown with red colors

clear; clc; close all
load('Fig2_LSF_demo.mat')

F_size = 3 ; %3 (174mm, full-width) or 2 (114mm) or 1 (85mm) column 
W_n = 2 ; % # rows
H_n = 5 ; % # columns

if F_size == 3
    W = 17.4 ; %centimeter
elseif F_size == 2
    W = 11.4 ;
elseif F_size == 1
    W = 8.5 ; 
end    
if W_n == 3
    H = 15 ; %centimeter
    panel_inner_B = 0.055  ; 
    panel_inner_H = 0.9 ;
    panel_titel_y = H/W_n - 1 ;
    F_posi = [10, 2, W, H] ;
elseif W_n == 2
    H = 10 ;
    panel_inner_B = 0.07  ; 
    panel_inner_H = 0.85 ;    
    panel_titel_y = H/W_n - 1.0 ; %more negative==lower
    F_posi = [10, 5, W, H] ;
elseif W_n == 1
    H = 5 ; 
    panel_inner_B = 0.15  ; 
    panel_inner_H = 0.75 ;
    panel_titel_y = H/W_n - 0.95 ;
    F_posi = [10, 10, W, H] ;
end 
panel_inner_L = 0.045 ;
panel_inner_W = 0.945 ;
panel_titel_x = 0-0.75 ;
% to Left, to Bottom, Width, Height (1st+3rd<=1)
panel_inner = [panel_inner_L panel_inner_B panel_inner_W panel_inner_H] ; 

%%
T.x = panel_titel_x ; %moving left from inset plot region
T.y = panel_titel_y ; %moving up from left-lower corner for each panel
T.s = 10 ; %panel Font size
T.W = 'bold'; %Font weight, bold or normal
T.t = 'Arial';
% T.A = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}; 
T.A = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};

A.t = 'Arial';
A.s = 6 ; %font size of axis

fig = figure; 
fig.Units = "centimeters";
fig.Color = "White"; %evenif using 'None', there is a still white-filled square
fig.InnerPosition = F_posi ; %X-Units to right, Y-Units above bottom; figure wide & tall
fig.PaperSize = fig.Position(3:4) ;
fig.PaperUnits = "centimeters" ;

t = tiledlayout(W_n, H_n);
t.Padding = "loose" ;
t.TileSpacing = "loose" ;
t.InnerPosition = panel_inner ; %shifting the inside panels position

hist_edge = 5 : 10 : 95 ;
Color1 = [204,84,94]/256 ;
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
rate_mean = Example1_random_rates_mean(Example1_random_spkr_order);
rate_err = Example1_random_rates_std(Example1_random_spkr_order);
A1 = errorbar(1:15, rate_mean, rate_err); hold on % to move the connective line, use 'o'
A1.Color = 'black'; % 80dB SPL, more adaptation
A1.Marker = '.' ;
A1.MarkerSize = 10 ;
t_ID = 9; %9th value
% A2 = plot(t_ID, rate_mean(t_ID), 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 15); hold on
A2 = errorbar(t_ID, rate_mean(t_ID), rate_err(t_ID), 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 15);hold on;
faci_x = t_ID-0.8:0.1:t_ID+0.8;
faci_y = (rate_mean(t_ID)+rate_err(t_ID))*ones(length(faci_x), 1);
% A3 = plot(t_ID, rate_mean(t_ID)+rate_err(t_ID), 'Color', rgb('SandyBrown'), 'Marker', '*', 'MarkerSize', 15);
A3 = plot(faci_x, faci_y, 'Color', rgb('SandyBrown'), 'LineWidth', 1.5, 'LineStyle','-');

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe, {'mean ± s.d.','tgt. spkr.','faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Position(1)=lgd.Position(1) + 0.020; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.02; %+==shift up
lgd.Position(3)=0.04;
lgd.Position(4)=0.06;
axe.XTick = 1:15 ; axe.XTickLabel = num2str(Example1_random_spkr_order');
axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Eq. prob. present.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-383'; axe.Subtitle.FontSize=6;
xlabel('Speaker #', 'FontSize', 7); ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%%
axe = nexttile([1 2]);
raster_X = Example1_continuous_on_data(2, :);
raster_Y = Example1_continuous_on_data(1, :)-200;

X_faci1=80:96; %reps or step value range; plot for both Fig2 & Fig3
X_faci2=142:177;
X_faci3=201:242;
N_reps = length(Example1_continuous_firing_rates);
x_step = 1/(N_reps+1);
x_idx = (1+x_step): x_step : (2-x_step) ; %more reps/stimuli==more steps between 1~2
spike_idx = zeros(1, N_reps);
for i = 1 : N_reps
    % find how many spikes fall into each step
    spike_idx(i) = length(find(abs(raster_X-x_idx(i))<0.00001)); %difference not always==0
end    
if sum(spike_idx)~=length(raster_X)
    error('Error. Some spikes are missing')
end    
X_faci1_start = sum( spike_idx( 1 : (X_faci1(1)-1) ) )+1; %all spikes before this range
X_faci1_end = sum( spike_idx( 1 : X_faci1(end) ) );
X_faci2_start = sum( spike_idx( 1 : (X_faci2(1)-1) ) )+1; 
X_faci2_end = sum( spike_idx( 1 : X_faci2(end) ) );
X_faci3_start = sum( spike_idx( 1 : (X_faci3(1)-1) ) )+1; 
X_faci3_end = sum( spike_idx( 1 : X_faci3(end) ) );

B1 = plot(raster_X, raster_Y, 'Marker', '.', 'MarkerSize', 7, 'LineWidth', 0.5, 'LineStyle','none'); hold on
B1.Color = rgb('SteelBlue') ;
faci_range =  [X_faci1_start:X_faci1_end, X_faci2_start:X_faci2_end, X_faci3_start:X_faci3_end];
B2 = plot(raster_X(faci_range), raster_Y(faci_range), 'Marker', '.', 'MarkerSize', 7, 'LineWidth', 0.5, 'LineStyle', 'none'); hold on
B2.Color = Color1 ;

text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = 1 : 1/6 : 2 ; axe.XTickLabel = {'0', '50', '100', '150', '200', '250', '300'};
axe.YLim=([0 200]);
% axe.XLim=([1 1.5]);
axe.Title.String='Continuous present. (WB-noise) spike raster'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-383 speaker #14'; axe.Subtitle.FontSize=6;
xlabel('Trial #', 'FontSize', 7); ylabel('Time (ms)', 'FontSize', 7)
%%
axe = nexttile([1 2]);
C2 = line(1:N_reps, Example1_continuous_threshold_rates*ones(1,300), 'LineWidth', 1, 'LineStyle','-'); hold on
C2.Color = rgb('SandyBrown') ;
C1 = plot(1:300, Example1_continuous_firing_rates, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
% C1 = plot(1:N_reps, Example1_continuous_firing_rates, 'Marker', '.', 'MarkerSize', 5, 'LineStyle', 'none'); hold on
C1.Color = rgb('SteelBlue') ;

text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';

faci_range_x =  [X_faci1, nan, X_faci2, nan, X_faci3];
faci_range_y =  [Example1_continuous_firing_rates(X_faci1), nan,...
    Example1_continuous_firing_rates(X_faci2), nan, Example1_continuous_firing_rates(X_faci3)];
plot(faci_range_x, faci_range_y, 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(faci_range_x, faci_range_y, 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineStyle', 'none'); hold on

lgd= legend(axe,{'faci. thres.', 'all trials', 'consec. faci. trials'}); lgd.Box='off'; lgd.FontSize=A.s+1;
lgd.Location='northwest'; 
lgd.Position(1)=lgd.Position(1) - 0.01; %must occur after 'northwest'...
lgd.Position(2)=lgd.Position(2) + 0.05;
lgd.Position(3)=0.035;
lgd.Position(4)=0.06;

% text(axe, 2, 25, 'tgt. spkr.(#14)', 'FontSize', A.s+1, 'FontName', A.t); %already labled in the title
axe.Title.String='Continuous present. (WB-noise) firing rate'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-383 speaker #14'; axe.Subtitle.FontSize=6;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7)
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
rate_mean = Example2_random_rates_mean(Example2_random_spkr_order);
rate_err = Example2_random_rates_std(Example2_random_spkr_order);
D1 = errorbar(1:15, rate_mean, rate_err); hold on % to move the connective line, use 'o'
D1.Color = 'black'; % 80dB SPL, more adaptation
D1.Marker = '.' ;
D1.MarkerSize = 10 ;
t_ID = 14; %14th value
% D2 = plot(t_ID, rate_mean(t_ID), 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 15);hold on;
D2 = errorbar(t_ID, rate_mean(t_ID), rate_err(t_ID), 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 15);hold on;
faci_x = t_ID-0.8:0.1:t_ID+0.8;
faci_y = (rate_mean(t_ID)+rate_err(t_ID))*ones(length(faci_x), 1);
D3 = plot(faci_x, faci_y, 'Color', rgb('SandyBrown'), 'LineWidth', 1.5, 'LineStyle','-');hold on;

text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe, {'mean ± s.d.', 'tgt. spkr.', 'faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Position(1)=lgd.Position(1) + 0.05; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.02; %+==shift up
lgd.Position(3)=0.05;
lgd.Position(4)=0.065;
axe.XTick = 1:15 ; axe.XTickLabel = num2str(Example2_random_spkr_order'); axe.YLim=([-5 20]);
axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; 
axe.Title.String='Eq. prob. present.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-12'; axe.Subtitle.FontSize=6;
xlabel('Speaker #', 'FontSize', 7); ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%%
axe = nexttile([1 2]);
raster_X = Example2_continuous_on_data(2, :);
raster_Y = Example2_continuous_on_data(1, :)-500;

X_faci1=31:50;
N_reps = length(Example2_continuous_firing_rates);
x_step = 1/(N_reps+1);
x_idx = (1+x_step): x_step : (2-x_step) ; %more reps/stimuli==more steps between 1~2
spike_idx = zeros(1, N_reps);
for i = 1 : N_reps
    % find how many spikes fall into each step
    spike_idx(i) = length(find(abs(raster_X-x_idx(i))<0.00001)); %difference not always==0
end    
if sum(spike_idx)~=length(raster_X)
    error('Error. Some spikes are missing')
end    
X_faci1_start = sum( spike_idx( 1 : (X_faci1(1)-1) ) )+1; %all spikes before this range
X_faci1_end = sum( spike_idx( 1 : X_faci1(end) ) );

E1 = plot(raster_X, raster_Y, 'Marker', '.', 'MarkerSize', 7, 'LineWidth', 0.5, 'LineStyle', 'none'); hold on
E1.Color = rgb('SteelBlue') ;
faci_range =  X_faci1_start:X_faci1_end ;
E2 = plot(raster_X(faci_range), raster_Y(faci_range), 'Marker', '.', 'MarkerSize', 7, 'LineWidth', 0.5, 'LineStyle', 'none'); hold on
E2.Color = Color1 ;

text(axe, T.x, T.y, T.A{5}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = 1 : 1/5 : 2 ; axe.XTickLabel = {'0', '10', '20', '30', '40', '50'};
axe.YTick = 0 : 300 : 900 ;
axe.YLim=([0 900]);
axe.Title.String='Continuous present. (vocalization) spike raster'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-12 speaker #8'; axe.Subtitle.FontSize=6;
xlabel('Trial #', 'FontSize', 7); ylabel('Time (ms)', 'FontSize', 7)
%%
axe = nexttile([1 2]);
F2 = line(1:N_reps, Example2_continuous_threshold_rates*ones(1,N_reps), 'LineWidth', 1, 'LineStyle','-'); hold on
F2.Color = rgb('SandyBrown') ;
F1 = plot(1:N_reps, Example2_continuous_firing_rates, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
% F1 = plot(1:N_reps, Example2_continuous_firing_rates, 'Marker', '.', 'MarkerSize', 5, 'LineStyle', 'none'); hold on
F1.Color = rgb('SteelBlue') ;

plot(X_faci1, Example2_continuous_firing_rates(X_faci1), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(X_faci1, Example2_continuous_firing_rates(X_faci1), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineStyle', 'none'); hold on

text(axe, T.x, T.y, T.A{6}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
lgd= legend(axe,{'faci. thres.', 'all trials', 'consec. faci. trials'}); lgd.Box='off'; lgd.FontSize=A.s+1;
lgd.Location='northwest'; 
lgd.Position(1)=lgd.Position(1) - 0.01; %must occur after 'northwest'...
lgd.Position(2)=lgd.Position(2) + 0.05;
lgd.Position(3)=0.04;
lgd.Position(4)=0.07;
axe.Title.String='Continuous present. (vocalization) firing rate'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Subtitle.String='Unit M43S-12 speaker #8'; axe.Subtitle.FontSize=6;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7)
%%
exportgraphics(gcf, 'Fig2.pdf','ContentType','vector', 'BackgroundColor','none')