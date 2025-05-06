% Did not specify the X and Y label size, it's proportional to Axis size; 6.6pt Label=6pt Axis

clear;clc; close all
load('Fig6_Intracellular.mat')

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
panel_inner_W = 0.915 ;
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
A.s = 5 ; %font size of axis

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
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis

SR=24414;%sampleing rate in Hz
t_time = 0.6 ; %time length (in Second)
s_window = [0.2, 0.35]; %in Second, time when sound is ON and OFF
TSpkr = 4 ; %Real Speaker# 1 2 3 5 6 12 13 14 15(posi=14) 16(posi=15) which miss #4 
N_spkr=15 ;
MP_raw=cat(1, example_wave_M1010_random{1, 1}, example_wave_M1011_random{1, 1}, example_wave_M1012_random{1, 1});
N_reps = 12 ; %3 files and each file has 4 repeats, so it's 12 repeats
MP_raw_3D=nan(N_reps, round(SR*t_time), N_spkr); 
MP_random_all=nan(N_reps, N_spkr);
for s = 1 : N_spkr
    MP_raw_3D(:, :, s) = cat(1, MP_raw{1, s}, MP_raw{2, s}, MP_raw{3, s}); 
    MP_random_all(:, s) = cat(1, median(MP_raw{1, s},2), median(MP_raw{2, s},2), median(MP_raw{3, s},2)); 
end   
s_window_point = round(SR*s_window(1)):round(SR*s_window(2));
s_trace = raw2mV(MP_raw_3D(:, s_window_point, TSpkr));
X_tick = 1 : N_reps;

A1 = plot(s_trace', 'LineWidth', 0.25, 'LineStyle', '-'); hold on
x_range1 = 1500 : (1500+round(SR*0.05)); y_range1 = -55*ones(length(x_range1),1);
plot(axe, x_range1, y_range1, 'Color', 'k', 'LineWidth', 1, 'LineStyle', '-'); hold on
text(axe, 1800, -56.5, '50ms', 'FontSize', A.s, 'FontName', A.t); hold on

text(axe, 1700, -30, '5mV', 'FontSize', A.s, 'FontName', A.t); hold on
% y_range2 = -68:-52;
y_range2 = -31.5:-28.5;
x_range2 = 2400*ones(length(y_range2),1);
plot(axe, x_range2, y_range2, 'Color', 'k', 'LineWidth', 1, 'LineStyle', '-'); hold on

text(axe, -800, -50, 'Vm', 'FontSize', A.s+3, 'FontName', A.t, 'FontAngle', 'italic'); hold on

text(axe, 900, -16.5, unit, 'FontSize', A.s+1, 'FontName', A.t); hold on

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe, num2str(X_tick')); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Location='northwest';
lgd.Position(1)=lgd.Position(1) - 0.04; %X-axis, negative==shift left
lgd.Position(2)=lgd.Position(2) + 0.05; %+==shift up
lgd.Position(3)=0.007;
lgd.Position(4)=0.17;
lgd.Title.String = 'Repeat #'; lgd.Title.FontSize = 6; lgd.Title.FontWeight='normal';
axe.XLim=([0 round(SR*0.15)]); 
axe.YLim=([-55 -15]);
axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Eq. prob. tgt. spkr. M.P.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.XAxis.Visible='off'; axe.YAxis.Visible='off'; % axe.YColor='w'; axe.XColor='w'; 
% axe.Visible='off'; %this will also turn off the title
% xlabel('Time (ms)', 'FontSize', 7); ylabel('Membrane potential (mV)', 'FontSize', 7)
%%
axe = nexttile;
rate_mean = example_rates_random(example_spkr_order_random);
rate_err= example_std_random(example_spkr_order_random);
B1 = errorbar(1:15, rate_mean, rate_err); hold on % to move the connective line, use 'o'
B1.Color = 'black'; % 80dB SPL, more adaptation
B1.Marker = '.' ;
B1.MarkerSize = 10 ;
t_ID = 13; %rank number
% B2 = errorbar(t_ID, rate_mean(t_ID), rate_err(t_ID), 'Color', rgb('Chocolate'), 'Marker', '.', 'MarkerSize', 15);hold on;
B2 = plot(t_ID, rate_mean(t_ID), 'Color', rgb('Chocolate'), 'Marker', '.', 'MarkerSize', 15);hold on;
faci_x = t_ID-0.6:0.1:t_ID+0.6;
faci_y = (rate_mean(t_ID)+rate_err(t_ID))*ones(length(faci_x), 1);
B3 = plot(faci_x, faci_y, 'Color', rgb('Chocolate'), 'LineWidth', 1.5, 'LineStyle','-');

lgd= legend(axe, {'mean ± s.d.','tgt. spkr.','faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Position(1)=lgd.Position(1) + 0.04; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.015; %+==shift up
lgd.Position(3)=0.02;
lgd.Position(4)=0.05;
text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 

axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = 1:15 ; axe.XTickLabel = num2str(example_spkr_order_random');
axe.YLim=([0 20]);
axe.Title.String='Eq. prob. spike'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Speaker #', 'FontSize', 7); ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%%
axe = nexttile;
MP_mean_raw = mean(raw2mV(MP_random_all));
MP_err_raw = std(raw2mV(MP_random_all));
MP_mean = MP_mean_raw(example_spkr_order_random);
MP_err= MP_err_raw(example_spkr_order_random);
C1 = errorbar(1:15, MP_mean, MP_err); hold on % to move the connective line, use 'o'
C1.Color = 'black'; % 80dB SPL, more adaptation
C1.Marker = '.' ;
C1.MarkerSize = 10 ;
t_ID = 13; %rank number of Speaker#5
% C2 = errorbar(t_ID, MP_mean(t_ID), MP_err(t_ID), 'Color', rgb('DodgerBlue'), 'Marker', '.', 'MarkerSize', 15);hold on;
C2 = plot(t_ID, MP_mean(t_ID), 'Color', rgb('DodgerBlue'), 'Marker', '.', 'MarkerSize', 15);hold on;
faci_x = t_ID-0.6:0.1:t_ID+0.6;
faci_y = (MP_mean(t_ID)+MP_err(t_ID))*ones(length(faci_x), 1);
C3 = plot(faci_x, faci_y, 'Color', rgb('DodgerBlue'), 'LineWidth', 1.5, 'LineStyle','-');
lgd= legend(axe, {'mean ± s.d.','tgt. spkr.','depola. thres.'}); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Position(1)=lgd.Position(1) + 0.05; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.015; %+==shift up
lgd.Position(3)=0.02;
lgd.Position(4)=0.05;
text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = 1:15 ; axe.XTickLabel = num2str(example_spkr_order_random');
axe.YLim=([-50.5 -46]);
axe.Title.String='Eq. prob. M.P.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Speaker #', 'FontSize', 7); ylabel('Membrane potential (mv)', 'FontSize', 7)
%%
axe = nexttile([1 2]); %similar as <subplot, before 2006a>; properties==axis
MP_continue_all = raw2mV(example_wave_M1013_continue{1, 1}{1, 1});
yyaxis right; 
D1 = plot(example_rates_continuous, 'Color', rgb('SandyBrown'), 'Marker', '.', 'MarkerSize', 5);hold on;
rate_thres = example_rates_random(TSpkr) + example_std_random(TSpkr);
D11 = plot(rate_thres*ones(1, 200), 'Color', rgb('Chocolate'), 'LineWidth', 1.5, 'LineStyle','--');hold on;
yyaxis left; 
D2 = plot(median(MP_continue_all, 2), 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 5);hold on;
MP_thres = MP_mean(t_ID) + MP_err(t_ID);
D21 = plot(MP_thres*ones(1, 200), 'Color', rgb('DodgerBlue'), 'LineWidth', 1.5, 'LineStyle','--');hold on;

text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe, {'', 'depola. thres.', '', 'faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Location='northwest';
lgd.Position(1)=lgd.Position(1) -0.00; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.00; %+==shift up
lgd.Position(3)=0.03; %width
lgd.Position(4)=0.05; %width
axe.XTick = 0:25:200 ; 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out'; 
axe.Title.String='Continuous presentation at target speaker'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #');
yyaxis left
ylabel('Membrane potential (mV)', 'FontSize', 7);
yyaxis right
ylabel('Firing rates (spikes/s)', 'FontSize', 7)
%%
% Brown and violet colors from <I want hue.com>
axe = nexttile();
MP_low_m = mean(population_low_rank_MP_fa_ad);
MP_low_SE = std(population_low_rank_MP_fa_ad)/sqrt(13);
E1 = errorbar(1:2, MP_low_m, MP_low_SE, 'Color', [156,149,77]/256, 'Marker', '.', 'MarkerSize', 10); hold on

MP_high_m = mean(population_high_rank_MP_fa_ad);
MP_high_SE = std(population_high_rank_MP_fa_ad)/sqrt(15);
E2 = errorbar(1:2, MP_high_m, MP_high_SE, 'Color', [176,103,163]/256, 'Marker', '.', 'MarkerSize', 10); hold on

lgd= legend(axe, {'low rank(>=10) 13 sess.', 'high rank(<=6) 15 sess.'}); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Location='northwest';
lgd.Position(1)=lgd.Position(1) -0.01; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.02; %+==shift up
lgd.Position(3)=0.03; %width

text(axe, T.x, T.y, T.A{5}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = [1, 2] ; axe.XTickLabel = {'Depola.', 'Hyperpola.'}; axe.XLim=([0.9 2.1]); axe.YLim=([0 80]);
axe.Title.String='M.P. change & loc.'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Proportion of trials (%)', 'FontSize', 7); %X=xlabel('X');
%%
axe = nexttile();
MP_low_m = mean(population_SD_faci);
MP_low_SE = std(population_SD_faci)/sqrt(length(population_SD_faci));
F1 = errorbar(1, MP_low_m, MP_low_SE, 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 10); hold on
text(axe, 0.65, 0.9, '290 trials', 'FontSize', A.s, 'FontName', A.t); hold on

MP_tran_m = mean(population_SD_transition);
MP_tran_SE = std(population_SD_transition)/sqrt(length(population_SD_transition));
F2 = errorbar(2, MP_tran_m, MP_tran_SE, 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 10); hold on
text(axe, 1.65, 1.55, '672 trials', 'FontSize', A.s, 'FontName', A.t); hold on

MP_high_m = mean(population_SD_adap);
MP_high_SE = std(population_SD_adap)/sqrt(length(population_SD_adap));
F3 = errorbar(3, MP_high_m, MP_high_SE, 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 10); hold on
text(axe, 2.65, 2.7, '88 trials', 'FontSize', A.s, 'FontName', A.t); hold on

lgd= legend(axe, 'mean ± s.e.'); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Location='northwest';
lgd.Position(1)=lgd.Position(1) -0.01; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.02; %+==shift up
lgd.Position(3)=0.03; %width

text(axe, T.x, T.y, T.A{6}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = [1, 2, 3] ; axe.XTickLabel = {'Depola.', 'Transition', 'Hyperpola.'}; 
axe.XLim=([0.5 3.5]); axe.YLim=([0 3.5]);
axe.Title.String='M.P. variation'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Membrane potential s.d.', 'FontSize', 7)
%%
axe = nexttile();
G1 = plot(population_MP_spike_start(:,1), population_MP_spike_start(:, 2), 'Marker', '.', 'MarkerSize', 12, 'LineStyle','none'); hold on
G1.Color = rgb('SteelBlue') ;

text(axe, -0.45, 17.5, 'n=7 sessions', 'FontSize', A.s, 'FontName', A.t); hold on
text(axe, T.x, T.y, T.A{7}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XTick = 0 ; axe.XLim=([-0.5 0.5]); axe.XTickLabel = 'Membrane potential'; %axe.YLim=([0 25]); 
axe.Title.String='M.P. & spike change'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Depola. after faci. (trial)', 'FontSize', 7)
%%
axe = nexttile([1 2]);
MP_change_m = nanmean(population_MP_change, 2)-69;
MP_change_SD = nanstd(population_MP_change, [],2)/sqrt(7);
H1 = errorbar(1:100, MP_change_m, MP_change_SD, 'Color', rgb('SteelBlue'), 'Marker', '.', 'MarkerSize', 10); hold on %
H2 = plot(axe, 30, MP_change_m(30), 'Color', rgb('Black'), 'Marker', '.', 'MarkerSize', 15); hold on

text(axe, 1.8, -69, 'Vm', 'FontSize', A.s+2, 'FontName', A.t, 'FontAngle', 'italic'); hold on
x_range1 = 5:30;
y_range1 = -69*ones(length(x_range1),1);
plot(axe, x_range1, y_range1, 'Color', 'k', 'LineWidth', 1/2, 'LineStyle', '--'); hold on
text(axe, 13, -68.5, '30 trials', 'FontSize', A.s, 'FontName', A.t); hold on
y_range2 = -69:-62;
x_range2 = 30*ones(length(y_range2),1);
plot(axe, x_range2, y_range2, 'Color', 'k', 'LineWidth', 1/2, 'LineStyle', '--'); hold on
text(axe, 31.2, -66, '7mV', 'FontSize', A.s, 'FontName', A.t); hold on
% xa = [.835 .835]; %hard to adjust and not very useful
% ya = [.12 .32];
% annotation('doublearrow',xa,ya, 'Color', 'r')

lgd= legend(axe, {'mean ± s.e.  n=7 sessions', 'stable M.P.', '', ''}); lgd.Box='off'; lgd.FontSize=A.s; 
lgd.Location='northwest';
lgd.Position(1)=lgd.Position(1) -0.01; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.02; %+==shift up
lgd.Position(3)=0.03; %width

text(axe, T.x, T.y, T.A{8}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
axe.XLim=([0 40]); axe.YLim=([-70 -60]);
axe.Title.String='M.P. dynamics after depolarization'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Membrane potential (mV)', 'FontSize', 7)
%%
exportgraphics(gcf, 'Fig6.pdf','ContentType','vector', 'BackgroundColor','none')