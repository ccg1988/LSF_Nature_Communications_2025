
clear;clc
close all

F_size = 3 ; %3 (174mm, full-width) or 2 (114mm) or 1 (85mm) column 
W_n = 2 ; % # rows
H_n = 4 ; % # columns

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
    panel_inner_B = 0.105  ; 
    panel_inner_H = 0.82 ;    
    panel_titel_y = H/W_n - 1.2 ;
    F_posi = [10, 5, W, H] ;
elseif W_n == 1
    H = 5 ; 
    panel_inner_B = 0.15  ; 
    panel_inner_H = 0.75 ;
    panel_titel_y = H/W_n - 0.95 ;
    F_posi = [10, 10, W, H] ;
end 
panel_inner_L = 0.05 ;
panel_inner_W = 0.94 ;
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
A.s = 7 ; %font size of axis

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

Color1 = rgb('SandyBrown');
Color2 = rgb('SteelBlue') ;
Color3 = rgb('Black'); %pink-red

Lw=0.5; % Line Width
Ms1=10; % Marker Size for BCD
Ms2=15; % Marker Size for EFG

load('Fig5_continuity_data.mat')
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
spot_x = 3.5:0.5:7 ; 
Y = 26.5;
t_X = 0.0-0.75 ; 
t_Y= 3 ; tt = 0.54;
text(axe, t_X, t_Y, '100', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); hold on
spot1_y = Y*ones(length(spot_x), 1);
plot(spot_x, spot1_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on

text(axe, t_X, t_Y-tt*1, '75', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); hold on
spot2_y = spot1_y-0.5*2; spot2_y([3, 7])=nan;
plot(spot_x, spot2_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on; yy=Y-0.5*2;
plot(spot_x(3), yy, '^', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(7), yy, 'p', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on

text(axe, t_X, t_Y-tt*2, '50', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); hold on
spot3_y = spot2_y-0.5*2; spot3_y([1, 4])=nan; % random------50%
plot(spot_x, spot3_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on; yy=Y-1*2;
plot(spot_x(3), yy, '^', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(7), yy, 'p', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(1), yy, '<', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(4), yy, 'h', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
% 
text(axe, t_X, t_Y-tt*3, '50/p', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); hold on
spot4_y = spot2_y-1*2; spot4_y([1, 5])=nan; % periodic------50%
plot(spot_x, spot4_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on; yy=Y-1.5*2;
plot(spot_x(3), yy, '^', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(7), yy, 'p', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(1), yy, '<', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(5), yy, 'h', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on

text(axe, t_X, t_Y-tt*4, '25', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); hold on
spot5_y = spot3_y-1*2; spot5_y([5, 6])=nan; % 25%
plot(spot_x, spot5_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on; yy=Y-2*2;
plot(spot_x(3), yy, '^', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(7), yy, 'p', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(1), yy, '<', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(4), yy, 'h', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(5), yy, 'd', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(6), yy, 'v', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
% 
text(axe, t_X, t_Y-tt*5, '6.7', 'FontSize', 8, 'FontName', T.t, 'Units', 'centimeters'); 
spot6_y = spot5_y-0.5*2; spot6_y(8)=nan; % 6.7%
plot(spot_x, spot6_y, 's', 'Color', Color1, 'MarkerSize', 6, 'MarkerFaceColor', Color1); hold on; yy=Y-2.5*2;
plot(spot_x(3), yy, '^', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(7), yy, 'p', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(1), yy, '<', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(4), yy, 'h', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(5), yy, 'd', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(6), yy, 'v', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on
plot(spot_x(8), yy, '>', 'Color', Color2, 'MarkerSize', 6, 'MarkerFaceColor', Color2); hold on

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); hold on
axe.Title.String='Target spkr. prob. (%)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.XAxis.Visible='off'; axe.YAxis.Visible='off'; 
axe.YLim = [21 27]; %must turn on
%%
axe = nexttile; %firing rates among 6 groups
temp=[population_inter_firing_rate(:, 2); nan; nan];
firing_rate = [population_prob_firing_rate(:, 1:3) temp population_prob_firing_rate(:, 4:5)];
T_mean = nanmean(firing_rate, 1); 
T_sd = nanstd(firing_rate, 1);%/sqrt(size(firing_rate, 1));
E1 = errorbar(0.5:5.5, T_mean, T_sd, 'Marker', '.', 'MarkerSize', Ms2, 'Color', Color1); hold on

text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters'); hold on
axe.Box='off'; axe.FontSize=A.s; axe.YLim=([0 15]);
axe.TickDir='out'; axe.XTick = 0.5:5.5 ; axe.XTickLabel = {'100', '75', '50', '50/p', '25', '6.7'};

x1=0.38; x2=x1+0.03; y=0.82; %position relative to the figure, not support for axis
annotation('line', [x1 x2],[y y], 'LineWidth', 1)
annotation('line', [x1 x1],[y y-0.02], 'LineWidth', 1)
annotation('line', [x2 x2],[y y-0.02], 'LineWidth', 1)
plot(3, 11.0, 'Marker', '*', 'MarkerSize', 5, 'Color', 'k') %relative position to the axis/panel

text(axe, T.x+2.7, T.y-1.1, 'n=12 sess.', 'FontSize', 7, 'FontWeight', 'normal', 'Color', 'black', 'Units', 'centimeters');
axe.Title.String='Tgt. spkr. firing rate'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Target speaker probability (%)', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7);
%%
axe = nexttile;
temp=[population_inter_total_duration(:, 2); nan; nan];
total_duration = [population_prob_total_duration(:, 1:3) temp population_prob_total_duration(:, 4:5)];
T_mean = nanmean(total_duration, 1);
T_sd = nanstd(total_duration, 1); %/sqrt(size(total_duration, 1));
F1 = errorbar(0.5:5.5, T_mean, T_sd, 'Marker', '.', 'MarkerSize', Ms2, 'Color', Color1); hold on

text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s;
axe.TickDir='out'; axe.XTick = 0.5:5.5 ; axe.XTickLabel = {'100', '75', '50', '50/p', '25', '6.7'};
axe.Title.String='Tgt. spkr. faci. trails'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Target speaker probability (%)', 'FontSize', 7); ylabel('Proportion of faci. trials (%)', 'FontSize', 7);
%%
axe = nexttile;
temp=[population_inter_long_duration(:, 2); nan; nan];
long_duration=[population_prob_long_duration(:, 1:3) temp population_prob_long_duration(:, 4)];
T_mean = nanmean(long_duration, 1);
T_sd = nanstd(long_duration, 1); %/sqrt(size(long_duration, 1));
G1 = errorbar(0.5:4.5, T_mean, T_sd, 'Marker', '.', 'MarkerSize', Ms2, 'Color', Color1); hold on

text(axe, T.x, T.y, T.A{5}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s; axe.XTickLabelRotation=45; axe.YLim=([0 50]); %axe.YTick = 0:15:45 ;
axe.TickDir='out'; axe.XTick = 0.5:4.5 ; axe.XTickLabel = {'100', '75', '50', '50/p', '25'};
xlabel('Target speaker probability (%)', 'FontSize', 7); ylabel('Proportion of faci. phases (%)', 'FontSize', 7);
axe.Title.String='Tgt. spkr. faci. phases (>=5)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
lgd= legend(axe,'mean ± s.d.'); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Position(1)=lgd.Position(1) + 0.02; 
% lgd.Position(2)=lgd.Position(2) + 0.04; 
%% 
axe = nexttile; %only display 93 out of 100 trials to match 25% data
x_length = length (example_P100_spkr_rates);
T_index = 1 :  x_length ;
T1 = plot(T_index, example_P100_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
T1.Color = rgb('SandyBrown') ;

line(1 :  x_length, example_thres*ones(1, x_length), 'Color', 'k', 'LineWidth', Lw, 'LineStyle', '--'); hold on

text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 0 : 20 : x_length; axe.XLim=([1 93]); axe.YLim=([-12 90]);
axe.Title.String=strcat(unit, ' 100% prob.'); axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7);

%% 
axe = nexttile; %only display 93 out of 210 trials to match 25% data
x_length = length (example_P75_spkr_number);
O_index = 1 :  x_length ;
O_index(example_P75_spkr_number==example_P75_TSpkr)=nan;
O1 = plot(O_index, example_P75_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
O1.Color = rgb('SteelBlue') ;
T_index = 1 :  x_length ;
T_index(example_P75_spkr_number~=example_P75_TSpkr)=nan;
T1 = plot(T_index, example_P75_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
T1.Color = rgb('SandyBrown') ;

line(1 :  x_length, example_thres*ones(1, x_length), 'Color', 'k', 'LineWidth', Lw, 'LineStyle', '--'); hold on

% text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 0 : 20 : x_length; axe.XLim=([1 93]); axe.YLim=([-12 90]);
axe.Title.String='75% prob.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7);
%%
axe = nexttile; %only display 93 out of 140 trials to match 25% data
x_length = length (example_P50_spkr_number);
O_index = 1 :  x_length ;
O_index(example_P50_spkr_number==example_P50_TSpkr)=nan;
O2 = plot(O_index, example_P50_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
O2.Color = rgb('SteelBlue') ;
T_index = 1 :  x_length ;
T_index(example_P50_spkr_number~=example_P50_TSpkr)=nan;
T2 = plot(T_index, example_P50_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
T2.Color = rgb('SandyBrown') ;

line(1 :  x_length, example_thres*ones(1, x_length), 'Color', 'k', 'LineWidth', Lw, 'LineStyle', '--'); hold on

% text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 0 : 20 : x_length; axe.XLim=([1 93]); axe.YLim=([-12 90]);
axe.Title.String='50% prob.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7);
%%
axe = nexttile; 
x_length = length (example_P25_spkr_number);
O_index = 1 :  x_length ;
O_index(example_P25_spkr_number==example_P25_TSpkr)=nan;
O3 = plot(O_index, example_P25_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
O3.Color = rgb('SteelBlue') ;
T_index = 1 :  x_length ;
T_index(example_P25_spkr_number~=example_P25_TSpkr)=nan;
T3 = plot(T_index, example_P25_spkr_rates, 'Marker', '.', 'MarkerSize', Ms1, 'LineWidth', Lw); hold on
T3.Color = rgb('SandyBrown') ;

line(1 :  x_length, example_thres*ones(1, x_length), 'Color', 'k', 'LineWidth', Lw, 'LineStyle', '--'); hold on

lgd= legend(axe,{'other spkrs.', 'tgt. spkr.', 'faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Location='northeast'; 
lgd.Position(1)=lgd.Position(1)+0.02 ; 
lgd.Position(2)=lgd.Position(2)+0.045 ; 

% text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 0 : 20 : x_length; axe.XLim=([1 x_length]); axe.YLim=([-12 90]);
axe.Title.String='25% prob.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rates (spikes/s)', 'FontSize', 7);
%%
exportgraphics(gcf, 'Fig5.pdf','ContentType','vector', 'BackgroundColor','none')