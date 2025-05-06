% Did not specify the X and Y label size, it's proportional to Axis size; 6.6pt Label=6pt Axis

clear; clc; close all
load('Fig3_statistics_data.mat')

F_size = 3 ; %3 (174mm, full-width) or 2 (114mm) or 1 (85mm) column 
W_n = 2 ; % # rows
H_n = 3 ; % # columns

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
    panel_inner_B = 0.08  ; 
    panel_inner_H = 0.85 ;    
    panel_titel_y = H/W_n - 1.1 ;
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
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
A1 = histogram(population_faci_duration, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
A1.BinEdges = hist_edge ;
A1.BinWidth = 5 ;
A1.EdgeColor = rgb('SandyBrown') ;
A1.LineWidth = 1 ;
A1.FaceColor = "none" ;
hold on;
A2 = histogram(population_faci_duration_random, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
A2.BinEdges = hist_edge ;
A2.BinWidth = 5 ;
A2.EdgeColor = rgb('SteelBlue') ;
A2.LineWidth = 1 ;
A2.FaceColor = "none" ;

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe,{'cont. 129 sess.', 'eq. prob. 129 sess.' }); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Position(1)=lgd.Position(1) + 0.02;
% lgd.Position(2)=lgd.Position(2) + 0.04;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = hist_edge ;
axe.Title.String='51 units (faci. phase >=5 consec. trials)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Proportion of facilitation trials (%)'); ylabel('Percent')
%%
axe = nexttile;
B1 = histogram(population_faci_duration_front, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
B1.BinEdges = hist_edge ;
B1.BinWidth = 5 ;
B1.LineWidth = 1 ;
B1.EdgeColor = rgb('SandyBrown') ;
B1.FaceColor = "none" ;
hold on;
B2 = histogram(population_faci_duration_back, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
B2.BinEdges = hist_edge ;
B2.BinWidth = 5 ;
B2.EdgeColor = rgb('SteelBlue') ;
B2.LineWidth = 1 ;
B2.FaceColor = "none" ;

text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); % 'Color', 'black', 
lgd= legend(axe,{'front 64 sess.', 'back 65 sess.'}); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Position(2)=lgd.Position(2) + 0.04;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = hist_edge ;
axe.Title.String='Visibility of test speaker'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Proportion of facilitation trials (%)'); ylabel('Percent')
%%
% figure
axe = nexttile;
C1 = histogram(population_faci_duration_vocal, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
C1.BinEdges = hist_edge ;
C1.BinWidth = 5 ;
C1.EdgeColor = rgb('SandyBrown') ;
C1.EdgeAlpha = 1 ;
C1.LineWidth = 1 ;
C1.FaceColor = "none" ;
hold on;
C2 = histogram(population_faci_duration_noise, 'DisplayStyle','stairs', 'Normalization', 'probability'); 
C2.BinEdges = hist_edge ;
C2.BinWidth = 5 ;
C2.EdgeColor = rgb('SteelBlue') ;
C2.EdgeAlpha = 1 ;
C2.LineWidth = 1 ;
C2.FaceColor = "none" ;

text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters'); 
lgd= legend(axe,{'frozen AM-WB noise 37 \newlinesess. & vocal. 9 sess.', 'frozen WB noise 83 sess.'}); 
lgd.Box='off'; lgd.FontSize=A.s-1; 
% shift right, shift up, width, height
lgd.Position(1)=lgd.Position(1)*1.03;
lgd.Position(2)=lgd.Position(2)*1.03;
% lgd.Position(4)=lgd.Position(4)*0.5;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = hist_edge ;
axe.Title.String='Stimulus types'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Proportion of facilitation trials (%)'); ylabel('Percent')
%%
% figure
load('Fig4_location_and_intensity_data.mat')
axe = nexttile;
id = example_random_spkr_order;
rate_m = example_random_rate_mean(id);
rate_sd = example_random_rate_std(id);
D = errorbar(1:15, rate_m, rate_sd); hold on
D.Color = rgb('Black') ;
D.Marker = '.' ;
D.MarkerSize = 12 ;
t_ID = 1; %1st/largest value
fa_ap_x = t_ID-0.7:0.1:t_ID+0.7;
faci_y = (rate_m(t_ID)+rate_sd(t_ID))*ones(length(fa_ap_x), 1);
D2 = plot(fa_ap_x, faci_y, 'Color', rgb('SandyBrown'), 'LineWidth', 1.5, 'LineStyle','-'); hold on
adap_y = (rate_m(t_ID)-rate_sd(t_ID))*ones(length(fa_ap_x), 1);
D3 = plot(fa_ap_x, adap_y, 'Color', rgb('SteelBlue'), 'LineWidth', 1.5, 'LineStyle','-'); hold on
text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters'); 
lgd= legend(axe,{'mean ± s.d.', 'faci. thres.', 'adap. thres.'}); lgd.Box='off'; lgd.FontSize=A.s;

axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 1:15 ;  
axe.XTickLabel=num2str(example_random_spkr_order');
text(axe, 0-2, 0-26, 'Spkr. #', 'FontSize', A.s); %in the top-left corner

spkr_order=1:15; dis = num2str(spkr_order');
for i = 1 : 15
    TT = text(axe, i-0.2, 0-37, dis(i, :), 'FontSize', A.s); set(TT,'Rotation', 45);
end
text(axe, 0-2, 0-35, 'Spkr. r.', 'FontSize', A.s); %in the top-left corner
% text(axe, 0-2, 0-35, 'rank', 'FontSize', A.s); %in the top-left corner

axe.Title.String='Unit M43S-348 (eq. prob.)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Firing rate (spikes/s)'); 
%%
axe = nexttile;
E1 = plot(example_faci_duration(example_adap_faci_rank)); hold on
E1.Color = rgb('SandyBrown') ;
E1.Marker = '.' ;
E1.MarkerSize = 12 ;
E2 = plot(example_adap_duration(example_adap_faci_rank));
E2.Color = rgb('SteelBlue') ;
E2.Marker = '.' ;
E2.MarkerSize = 12 ;

text(axe, T.x, T.y, T.A{5}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
lgd= legend(axe,{'faci. 15 sess.', 'adap. 15 sess.'}); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Position(2)=lgd.Position(2) + 0.05;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; %axe.View = [90 -90] ;

axe.TickDir='out'; axe.XTick = 1:15 ;  
axe.XTickLabel=num2str(example_random_spkr_order');
text(axe, 0-2, 0-4, 'Spkr. #', 'FontSize', A.s); %in the top-left corner

spkr_order=1:15; dis = num2str(spkr_order');
for i = 1 : 15
    TT = text(axe, i-0.2, 0-12, dis(i, :), 'FontSize', A.s); set(TT,'Rotation', 45);
end
text(axe, 0-2, 0-10, 'Spkr. r.', 'FontSize', A.s); %in the top-left corner
axe.Title.String='Unit M43S-348 (cont. 200 trials)'; 
% axe.Title.String='Unit M43S-348 (cont.)(15 sess.)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Proportion of faci./adap. trials (%)'); 
%%
axe = nexttile;
faci_mean = nan(1, 15); faci_err = nan(1, 15);
adap_mean = nan(1, 15); adap_err = nan(1, 15);
for i = 1 : 15
    ff = population_faci_duration{i} ;
    faci_mean(i) = mean(ff);
    faci_err(i) = std(ff)/sqrt(length(ff));
    aa = population_adap_duration{i} ;
    adap_mean(i) = mean(aa);
    adap_err(i) = std(aa)/sqrt(length(aa));
end    
F1 = errorbar(1:15, faci_mean, faci_err); hold on %zeros(15, 1)
F1.Color = rgb('SandyBrown') ;
F1.Marker = '.' ;
F1.MarkerSize = 12 ;
F2 = errorbar(1:15, adap_mean, adap_err); hold on
F2.Color = rgb('SteelBlue') ;
F2.Marker = '.' ;
F2.MarkerSize = 12 ;
% plot(1,1, 'color', [1 1 1]) %to show legend of 'n=725'

text(axe, T.x, T.y, T.A{6}, 'FontSize', T.s, 'FontWeight', T.W, 'Color', 'black', 'Units', 'centimeters');
lgd= legend(axe,{'faci. 725 sess.', 'adap. 725 sess.'}); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Position(2)=lgd.Position(2) + 0.05;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; %axe.View = [90 -90] ;
axe.TickDir='out'; axe.XTick = 1:15 ; axe.YLim=([5 30]);
axe.Title.String='104 units (all faci. phases)'; 
% axe.Title.String='104 units (cont.)(725 sess.)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Proportion of faci./adap. trials (%)'); xlabel('Speaker rank')

% title(t,'Size vs. Distance')
% xlabel(t,'Distance (mm)')
% ylabel(t,'Size (mm)')

exportgraphics(gcf, 'Fig3.pdf','ContentType','vector', 'BackgroundColor','none')