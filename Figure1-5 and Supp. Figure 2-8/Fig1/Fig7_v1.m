% Did not specify the X and Y label size, it's proportional to Axis size; 6.6pt Label=6pt Axis

clear; clc; close all
load('Fig7_LIF_data.mat')

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
Color2 = [185,141,62]/256; %brown
Color3 = [100,168,96]/256; %green
Color4 = [204,84,94]/256; %pink-red
%%
axe = nexttile([1 1]); %similar as <subplot, before 2006a>; properties==axis
x_range = 1 : 100;
A11=plot(100*In_6point7_prob(x_range), 'Color', rgb('LightBlue')); hold on
A12=plot(100*In_25_prob(x_range), 'Color', rgb('LightSteelBlue')); hold on
A13=plot(100*In_50_prob(x_range), 'Color', rgb('SteelBlue')); hold on
A14=plot(100*In_75_prob(x_range), 'Color', rgb('MediumBlue')); hold on
A15=plot(100*In_100_prob(x_range), 'Color', rgb('Navy')); hold on

A16=plot(100*Ex_6point7_prob(x_range), 'Color', rgb('NavajoWhite')); hold on
A17=plot(100*Ex_25_prob(x_range), 'Color', rgb('SandyBrown')); hold on
A18=plot(100*Ex_50_prob(x_range), 'Color', rgb('Chocolate')); hold on
A19=plot(100*Ex_75_prob(x_range), 'Color', rgb('SaddleBrown')); hold on
A10=plot(100*Ex_100_prob(x_range), 'Color', rgb('Maroon')); hold on

sz = 15 ; %marker size
xb = 105; xs = 5 ;
yb = 67; ys = 3;
plot(xb, yb, '.', 'MarkerSize', sz, 'Color', rgb('Navy')); hold on
plot(xb+xs*2, yb, '.', 'MarkerSize', sz, 'Color', rgb('Maroon')); hold on
text(xb+xs*3, yb, '100', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on

plot(xb, yb+ys, '.', 'MarkerSize', sz, 'Color', rgb('MediumBlue')); hold on
plot(xb+xs*2, yb+ys*1, '.', 'MarkerSize', sz, 'Color', rgb('SaddleBrown')); hold on
text(xb+xs*3, yb+ys*1, '75', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on

plot(xb, yb+ys*2, '.', 'MarkerSize', sz, 'Color', rgb('SteelBlue')); hold on
plot(xb+xs*2, yb+ys*2, '.', 'MarkerSize', sz, 'Color', rgb('Chocolate')); hold on
text(xb+xs*3, yb+ys*2, '50', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on

plot(xb, yb+ys*3, '.', 'MarkerSize', sz, 'Color', rgb('LightSteelBlue')); hold on
plot(xb+xs*2, yb+ys*3, '.', 'MarkerSize', sz, 'Color', rgb('SandyBrown')); hold on
text(xb+xs*3, yb+ys*3, '25', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on

plot(xb, yb+ys*4, '.', 'MarkerSize', sz, 'Color', rgb('LightBlue')); hold on
plot(xb+xs*2, yb+ys*4, '.', 'MarkerSize', sz, 'Color', rgb('NavajoWhite')); hold on
text(xb+xs*3, yb+ys*4, '6.7', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on

text(xb-1, yb+ys*5-1, 'In.', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial', 'Rotation', 90); hold on
text(xb+xs*2-1, yb+ys*5-1, 'Ex.', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial', 'Rotation', 90); hold on
At3 = text(xb+xs*3+3, yb+ys*5-1, 'Tgt. spkr. prob. (%)', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
At3.Rotation=90;

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='EI-LIF model'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.XLim=([0 120]);
axe.XTick = 0:20:100; 
plot(100.5:121, 65*ones(21,1), 'Color', 'w', 'LineWidth',2); %cover extra useless X-axis line
% ; %axe.XTickLabel = {'100', '75', '50', '25', '6.7'};
axe.YLim=([65 100]);
xlabel('Trial #', 'FontSize', 7); ylabel('Synaptic release prob. (%)', 'FontSize', 7)
%%
axe = nexttile; 
con_range = find(example_EI_raster.rep>20, 1 ) : find(example_EI_raster.rep>20, 1, 'last' ) ;
raster_X = example_EI_raster.rep(con_range)-20; %trial ID, minus initial 20 random trials
raster_Y = example_EI_raster.spikes(con_range)*1000; %change s to ms
B1 = plot(raster_X, raster_Y, 'Marker', '.', 'MarkerSize', 3, 'LineWidth', 0.5, 'LineStyle','none'); hold on
B1.Color = rgb('SteelBlue') ;

X_faci1=49:59; X_faci2=68:75; X_faci3=89:94;
X_faci1_start = find(raster_X==(X_faci1(1)-1), 1,'last') +1; %all spikes before this range
X_faci1_end = find(raster_X==X_faci1(end), 1,'last') ;
X_faci2_start = find(raster_X==(X_faci2(1)-1), 1,'last') +1; 
X_faci2_end = find(raster_X==X_faci2(end), 1,'last') ;
X_faci3_start = find(raster_X==(X_faci3(1)-1), 1,'last') +1;
X_faci3_end = find(raster_X==X_faci3(end), 1,'last') ;
faci_range =  [X_faci1_start:X_faci1_end, X_faci2_start:X_faci2_end, X_faci3_start:X_faci3_end];
B2 = plot(raster_X(faci_range), raster_Y(faci_range), 'Marker', '.', 'MarkerSize', 3, 'LineWidth', 0.5, 'LineStyle', 'none'); hold on
B2.Color = Color1 ;

text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Cont. present. spikes'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
% axe.XLim = ([21 120]); 
axe.YLim = ([0 500]);
xlabel('Trial #', 'FontSize', 7); ylabel('Time (ms)', 'FontSize', 7)
%%
axe = nexttile; 
rate_range = 21 : 120 ;
rate_disp = example_EI_firing_rate(rate_range);
C1 = plot(1:100, rate_disp, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
C1.Color = rgb('SteelBlue') ;
EI_ran = example_EI_firing_rate(1:20);
EI_thres = mean(EI_ran)+std(EI_ran);
C2 = line(1:100, EI_thres*ones(1, 100), 'LineWidth', 1, 'LineStyle','-'); hold on
C2.Color = rgb('SandyBrown') ;

plot(X_faci1, rate_disp(X_faci1), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(X_faci2, rate_disp(X_faci2), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(X_faci3, rate_disp(X_faci3), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on

text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe,{'all trials', 'faci. thres.', 'consec. faci. trials'}); lgd.Box='off'; lgd.FontSize=A.s; lgd.Location='northeast'; 
lgd.Position(1)=lgd.Position(1)*1.12; 
lgd.Position(2)=lgd.Position(2) + 0.05; 
lgd.Position(3)=lgd.Position(3)/5; 
lgd.Position(4)=lgd.Position(4)/1.5; 

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Cont. present. rates'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%% figure d/D
axe = nexttile([1 1]); %similar as <subplot, before 2006a>; properties==axis
EI_model_5prob_m = [EI_100_prob_faci_percent, EI_75_prob_faci_percent, EI_50_prob_faci_percent, EI_25_prob_faci_percent, EI_6point7_prob_faci_percent];
EI_prob_m = mean(EI_model_5prob_m)*100;
EI_prob_SD = std(EI_model_5prob_m)*100;
errorbar(0.5:4.5, EI_prob_m, EI_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color2, 'LineStyle','none'); hold on
EI_prob_m = nanmean(experiment_5_prob_faci);
EI_prob_SD = nanstd(experiment_5_prob_faci);
errorbar(0.75:4.75, EI_prob_m, EI_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color3, 'LineStyle','none'); hold on
EI_prob_m = [mean(experiment_100_prob_faci); mean(experiment_6point7_prob_faci)];
EI_prob_SD = [std(experiment_100_prob_faci); std(experiment_6point7_prob_faci)];
errorbar([0.25 4.25], EI_prob_m, EI_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color4, 'LineStyle','none'); hold on

text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); hold on
text(axe, 3, 67, 'mean ± s.d.', 'FontSize', A.s, 'FontName', A.t, 'FontWeight', 'normal');

lgd= legend(axe,{'model 200 sess.', 'expt. 12 sess.', 'expt. 129 sess.'}); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Location='northeast'; 
lgd.Position(1)=lgd.Position(1)*1.09;
% lgd.Position(2)=lgd.Position(2) + 0.03; 
lgd.Position(3)=lgd.Position(3)/5; 

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.XTick = [0.5 1.625 2.625 3.625 4.5] ; axe.XTickLabel = {'100', '75', '50', '25', '6.7'};
axe.XLim = ([0 5]); 
axe.Title.String='Model and expt. values'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Target speaker probability (%)', 'FontSize', 7); ylabel('Proportion of facilitation trials (%)', 'FontSize', 7)
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
faci_step = 30 ; %need 30 trials for stable LSF
faci_vol = 7 ; %7mV depolarization
MP_rest = -69 ; %69mV resting MP
faci_prob = [1, 0.75, 0.5, 0.25, 0.067];
% Color_MP = {rgb('Black'), rgb('Black'), rgb('Black'), rgb('Black'), rgb('Black')};
Color_MP = {[1 1 1]*0, [1 1 1]*0.2, [1 1 1]*0.4, [1 1 1]*0.6, [1 1 1]*0.8};
for i = 1 : 5
    MP_depolar = faci_vol*faci_prob(i);
    MP_end = MP_rest+MP_depolar;
    MP_slope = MP_rest : MP_depolar/29 : MP_end;
    MP_stable = MP_end*ones(1, 100-faci_step);
    MP_all = [MP_slope MP_stable];
    plot(MP_all, 'Color', Color_MP{i}); hold on
end

xb = 104 ;
text(xb, -69+7*1, '100', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
text(xb, -69+7*0.75, '75', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
text(xb, -69+7*0.5, '50', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
text(xb, -69+7*0.25, '25', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
text(xb, -69+7*0.067, '6.7', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
At3 = text(xb+20, -69+7*0.25, 'Tgt. spkr. prob. (%)', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial'); hold on
At3.Rotation=90;

text(axe, T.x, T.y, T.A{5}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.XLim=([0 120]);
axe.XTick = 0:20:100; 
plot(100.5:121, -69*ones(21,1), 'Color', 'w', 'LineWidth',2); %cover extra useless X-axis line
axe.Title.String='MP-LIF model'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Membrane potential (mV)', 'FontSize', 7)
%% figure f/F
axe = nexttile; 
con_range = find(example_MP_raster.rep>20, 1 ) : find(example_MP_raster.rep>20, 1, 'last' ) ;
raster_X = example_MP_raster.rep(con_range)-20; %so the trial will start from 1
raster_Y = example_MP_raster.spikes(con_range)*1000;
F1 = plot(raster_X, raster_Y, 'Marker', '.', 'MarkerSize', 3, 'LineWidth', 0.5, 'LineStyle','none'); hold on
F1.Color = rgb('SteelBlue') ;

X_faci1=32:36; X_faci2=55:65; X_faci3=93:99;

X_faci1_start = find(raster_X==(X_faci1(1)-1), 1,'last') +1; %all spikes before this range
X_faci1_end = find(raster_X==X_faci1(end), 1,'last') ;
X_faci2_start = find(raster_X==(X_faci2(1)-1), 1,'last') +1; 
X_faci2_end = find(raster_X==X_faci2(end), 1,'last') ;
X_faci3_start = find(raster_X==(X_faci3(1)-1), 1,'last') +1;
X_faci3_end = find(raster_X==X_faci3(end), 1,'last') ;
faci_range =  [X_faci1_start:X_faci1_end, X_faci2_start:X_faci2_end, X_faci3_start:X_faci3_end];
F2 = plot(raster_X(faci_range), raster_Y(faci_range), 'Marker', '.', 'MarkerSize', 3, 'LineWidth', 0.5, 'LineStyle', 'none'); hold on
F2.Color = Color1 ;

axe.YLim = ([0 500]);
text(axe, T.x, T.y, T.A{6}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Cont. present. spikes'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Time (ms)', 'FontSize', 7)
%% figure g/G
axe = nexttile; 
rate_range = 21 : 120 ;
rate_disp = example_MP_firing_rate(rate_range);
G1 = plot(1:100, rate_disp, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
G1.Color = rgb('SteelBlue') ;
MP_ran = example_MP_firing_rate(1:20);
MP_thres = mean(MP_ran)+std(MP_ran);
G2 = line(1:100, MP_thres*ones(1, 100), 'LineWidth', 1, 'LineStyle','-'); hold on
G2.Color = rgb('SandyBrown') ;

plot(X_faci1, rate_disp(X_faci1), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(X_faci2, rate_disp(X_faci2), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
% X_faci1=67:76;
% plot(X_faci1, rate_disp(X_faci1), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
% X_faci2=83:89;
% plot(X_faci2, rate_disp(X_faci2), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on
plot(X_faci3, rate_disp(X_faci3), 'Color', Color1, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5); hold on

text(axe, T.x, T.y, T.A{7}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
% lgd= legend(axe,{'', 'faci. thres.'}); lgd.Box='off'; lgd.FontSize=A.s; lgd.Location='northwest'; 
% % lgd.Position(1)=lgd.Position(1) +0.03; 
% % lgd.Position(2)=lgd.Position(2) -0.03; 
% lgd.Position(3)=lgd.Position(3)/5; 

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.Title.String='Cont. present. rates'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Trial #', 'FontSize', 7); ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%% figure h/H
axe = nexttile([1 1]); %similar as <subplot, before 2006a>; properties==axis
MP_model_5prob_m = [MP_100_prob_faci_percent, MP_75_prob_faci_percent, MP_50_prob_faci_percent, MP_25_prob_faci_percent, MP_6point7_prob_faci_percent];
MP_prob_m = mean(MP_model_5prob_m)*100;
MP_prob_SD = std(MP_model_5prob_m)*100;
errorbar(0.5:4.5, MP_prob_m, MP_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color2, 'LineStyle','none'); hold on
MP_prob_m = nanmean(experiment_5_prob_faci);
MP_prob_SD = nanstd(experiment_5_prob_faci);
errorbar(0.75:4.75, MP_prob_m, MP_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color3, 'LineStyle','none'); hold on
MP_prob_m = [mean(experiment_100_prob_faci); mean(experiment_6point7_prob_faci)];
MP_prob_SD = [std(experiment_100_prob_faci); std(experiment_6point7_prob_faci)];
errorbar([0.25 4.25], MP_prob_m, MP_prob_SD, 'Marker', '.', 'MarkerSize', 15, 'Color', Color4, 'LineStyle','none'); hold on

text(axe, T.x, T.y, T.A{8}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');

% lgd= legend(axe,{'model n=200', 'experi. n=12', 'experi. n=129'}); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Location='northeast'; 
% lgd.Position(1)=lgd.Position(1)*1.08; 
% % lgd.Position(2)=lgd.Position(2) + 0.03; 
% lgd.Position(3)=lgd.Position(3)/5; 

axe.Box='off'; axe.FontSize=5; axe.FontName=A.t; axe.TickDir='out'; %reduce the font size
axe.XTick = [0.5 1.625 2.625 3.625 4.5] ; axe.XTickLabel = {'100', '75', '50', '25', '6.7'};
axe.XLim = ([0 5]); 
axe.Title.String='Model and expt. values'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Target speaker probability (%)', 'FontSize', 7); ylabel('Proportion of facilitation trials (%)', 'FontSize', 7)
%%
exportgraphics(gcf, 'Fig7.pdf','ContentType','vector', 'BackgroundColor','none')