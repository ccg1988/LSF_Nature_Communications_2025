% Did not specify the X and Y label size, it's proportional to Axis size; 6.6pt Label=6pt Axis

clear; clc; close all
load('Fig4_location_and_intensity_data.mat')

F_size = 1 ; %3 (174mm, full-width) or 2 (114mm) or 1 (85mm) column 
W_n = 3 ; % # rows
H_n = 1 ; % # columns

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
    panel_titel_y = H/W_n - 0.9 ;
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
panel_inner_L = 0.095 ;
panel_inner_W = 0.87 ;
panel_titel_x = 0-0.75 ;
% to Left, to Bottom, Width, Height (1st+3rd<=1)
panel_inner = [panel_inner_L panel_inner_B panel_inner_W panel_inner_H] ; 

%%
T.x = panel_titel_x ; %moving left from inset plot region
T.y = panel_titel_y ; %moving up from left-lower corner for each panel
T.s = 10 ; %panel Font size
T.W = 'bold'; %Font weight, bold or normal
T.t = 'Arial';
% T.A = {' ', ' ', ' ', 'd', 'e', 'f', 'g', 'h'}; 
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

Z = zeros(15, 0);
% https://medialab.github.io/iwanthue/, color-blind friendly
Color1 = [153,112,193]/256; %violet
Color2 = [185,141,62]/256; %brown
Color3 = [100,168,96]/256; %green
Color4 = [204,84,94]/256; %pink-red
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
[~, spkr_seq] = sort(example_driven_rates_alldB,'descend');

T_mean = mean(example_driven_rates_80dB, 2);
T_se = std(example_driven_rates_80dB, [], 2)/sqrt(size(example_driven_rates_80dB, 2));
% A1 = errorbar(1:15, T_mean, zeros(15, 0), T_se); hold on % to move the connective line, use 'o'
A1 = plot(1:15, T_mean(spkr_seq)); hold on
A1.Color = Color1; % rgb('Silver') ;
A1.Marker = '.' ;
A1.MarkerSize = 12 ;
T_mean = mean(example_driven_rates_60dB, 2);
T_se = std(example_driven_rates_60dB, [], 2)/sqrt(size(example_driven_rates_60dB, 2));
% A2 = plot(1:15, T_mean, Z, T_se); hold on
A2 = plot(1:15, T_mean(spkr_seq)); hold on
A2.Color = Color2 ; %rgb('DimGray') ;
A2.Marker = '.' ;
A2.MarkerSize = 12 ;
T_mean = mean(example_driven_rates_40dB, 2);
T_se = std(example_driven_rates_40dB, [], 2)/sqrt(size(example_driven_rates_40dB, 2));
% A3 = errorbar(1:15, T_mean, Z, T_se); hold on
A3 = plot(1:15, T_mean(spkr_seq)); hold on
A3.Color = Color3; %rgb('Gray') ;
A3.Marker = '.' ;
A3.MarkerSize = 12 ;
T_mean = mean(example_driven_rates_20dB, 2);
T_se = std(example_driven_rates_20dB, [], 2)/sqrt(size(example_driven_rates_20dB, 2));
% A4 = errorbar(1:15, T_mean, Z, T_se); hold on
A4 = plot(1:15, T_mean(spkr_seq)); hold on
A4.Color = Color4; % rgb('Black') ;
A4.Marker = '.' ;
A4.MarkerSize = 12 ;

A5 = plot(1:15, example_driven_rates_alldB(spkr_seq), 'LineWidth', 1); hold on
A5.Color = rgb('gray') ;
A5.Marker = '.' ;
A5.MarkerSize = 16 ;

text(axe, T.x, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe,{'80 dB', '60 dB', '40 dB', '20 dB', 'average'}); lgd.Box='off'; lgd.FontSize=A.s;
lgd.Location='northeast'; 
lgd.Position
lgd.Position(1)=lgd.Position(1)*1.1; %shift right for 'northeast' 

% lgd.Position(4)=lgd.Position(4)*0.99; 
lgd.Position(2)=lgd.Position(2) + 0.015; 
lgd.Position
lgd.Title.String = 'Sound level';
lgd.Title.FontSize = 6; lgd.Title.FontWeight='normal';
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;

% plot 8 7 12...15
axe.TickDir='out'; axe.XTick = 1:15 ;  
% axe.XTickLabel=num2str(spkr_seq); % 5 will be ' 5', there will be an empty and will not be fully aligned
axe.XTickLabel={'8','7','12','3','13','6','11','10','1','5','4','15','9','14','2'};
text(axe, 0-1.5, 0-14.2, 'Spkr. #', 'FontSize', A.s); %in the top-left corner

% plot 1 2 3...15
spkr_order=1:15; dis = num2str(spkr_order');
for i = 1 : 15
    TT = text(axe, i-0.25, 0-18.7, dis(i, :), 'FontSize', A.s); 
end
text(axe, 0-1.5, 0-18.7, 'Spkr. rank', 'FontSize', A.s); %in the top-left corner

axe.Title.String='Unit M43S-348 (equal probability)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
ylabel('Firing rate (spikes/s)', 'FontSize', 7)
%%
axe = nexttile; 
faci_dur_2D_mean = nan(4, 15);
faci_dur_2D_se = nan(4, 15);
NN = nan(4, 15);
for i = 1 : 4
    for j = 1 : 15
        temp = population_faci_duraion_two_rank{i, j};
        NN(i, j) = length(temp);
        if ~isempty(temp)
            faci_dur_2D_mean(i, j)=mean(temp);
            faci_dur_2D_se(i, j)=std(temp)/sqrt(length(temp));
        end    
    end
end    
B1 = errorbar(1:15, faci_dur_2D_mean(1,:), faci_dur_2D_se(1, :), Z, '-o'); hold on % to move the connective line, use 'o'
% B1 = plot(1:15, faci_dur_2D_mean(1,:)); %this will remove the error-bar
B1.Color = Color1; 
B1.Marker = '.' ;
B1.MarkerSize = 15 ;

B2 = errorbar(1:15, faci_dur_2D_mean(2,:), faci_dur_2D_se(2, :), Z, '-o'); hold on
B2.Color = Color2 ; 
B2.Marker = '.' ;
B2.MarkerSize = 15 ;

B3 = errorbar(1:15, faci_dur_2D_mean(3,:), faci_dur_2D_se(3, :), Z, '-o'); hold on
B3.Color = Color3; 
B3.Marker = '.' ;
B3.MarkerSize = 15 ;

B4 = errorbar(1:15, faci_dur_2D_mean(4,:), faci_dur_2D_se(4, :), Z, '-o'); hold on
B4.Color = Color4; 
B4.Marker = '.' ;
B4.MarkerSize = 15 ;
x1= 0.45; %this value is random, just set up the initial point
y1= 0.54; %this value is random, just set up the initial point
y_step_prop = nanmean(faci_dur_2D_mean(4,:)) - nanmean(faci_dur_2D_mean(1,:)); %20-80dB
y_norm = 0.63-0.38 ; %0.63@50%, 0.38@0%
y2_dB=y1+y_step_prop/50*y_norm; % 50 is the range of y-axis
% here use the normalized units with coordinates relative to the figure 
% 10 is default value for Arrow size
annotation('arrow', [x1 x1], [y1 y2_dB], 'HeadStyle', 'vback2', 'LineWidth', 1.5, 'HeadLength', 5, 'HeadWidth', 5);

y_step_prop = nanmean(faci_dur_2D_mean(:,15)) - nanmean(faci_dur_2D_mean(:,1)); % #15 to #1
x_norm = 0.96-0.15 ; %0.15@#1, 0.96@#15
x2=x1+0.4; %Arrow X-axis increase this step in the figure
y2=y1+y_step_prop/50*y_norm*(0.4/x_norm); %arrow length in X and Y are correlated
annotation('arrow', [x1 x2]+0.05, [y1 y2], 'HeadStyle', 'vback2', 'LineWidth', 1.5)
annotation('line', [x1 x2]+0.05, [y1 y1], 'LineWidth', 0.5, 'LineStyle','--')
annotation('line', [x2 x2]+0.05, [y1 y2], 'LineWidth', 0.5, 'LineStyle','--')
% show the text of <faciliation>
% annotation('textbox',[x1+0.07 y1-0.03 .1 .1], 'String','facilitation', 'FontSize', 10, 'EdgeColor', 'none')
% annotation('textbox',[x1+0.07 y1-0.025 .1 .1], 'String', '.', 'FontSize', 50)
% text(x1, y1, '.', 'FontSize', 50, 'FontName', T.t, 'FontWeight', T.W);
spot1_x = 5.6; spot1_y = 27.75; %plot is based on current axis
plot(spot1_x, spot1_y, '.', 'Color', Color1, 'MarkerSize', 15)
plot(spot1_x, spot1_y+2.5, '.', 'Color', Color2, 'MarkerSize', 15)
plot(spot1_x, spot1_y+5, '.', 'Color', Color3, 'MarkerSize', 15)
plot(spot1_x, spot1_y+7.5, '.', 'Color', Color4, 'MarkerSize', 15)

text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
lgd= legend(axe,{'1st 119 sess.', '2nd 116 sess.', '3rd 94 sess.', '4th 61 sess.'}); lgd.Box='off'; lgd.FontSize=A.s;lgd.Location='northwest';
text(axe, 0.5, 29, 'mean - s.e.', 'Color', 'k', 'FontSize', A.s, 'FontName', 'Arial');
lgd.Position(1)=lgd.Position(1) - 0.02; 
% lgd.Position(2)=lgd.Position(2) + 0.025; 
lgd.Title.String = 'Sound level rank';
lgd.Title.FontSize = 6; lgd.Title.FontWeight='normal';
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 1:15 ; axe.YLim = [0 50]; %use 50 since arrow is measured under 50% when errorbar is upright
axe.Title.String='Facilitation: 63 units 390 sessions (continuous)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Speaker rank', 'FontSize', 7); ylabel('Proportion of facilitation trials (%)', 'FontSize', 7)
%%
axe = nexttile; 
adap_dur_2D_mean = nan(4, 15);
adap_dur_2D_se = nan(4, 15);
for i = 1 : 4
    for j = 1 : 15
        temp = population_adap_duraion_two_rank{i, j};
        if ~isempty(temp)
            adap_dur_2D_mean(i, j)=mean(temp);
            adap_dur_2D_se(i, j)=std(temp)/sqrt(length(temp));
        end    
    end
end    
C1 = errorbar(1:15, adap_dur_2D_mean(1,:), adap_dur_2D_se(1, :), Z, '-o'); hold on % to move the connective line, use 'o'
C1.Color = Color1; % 80dB SPL, more adaptation
C1.Marker = '.' ;
C1.MarkerSize = 15 ;

C2 = errorbar(1:15, adap_dur_2D_mean(2,:), adap_dur_2D_se(2, :), Z, '-o'); hold on
C2.Color = Color2 ; 
C2.Marker = '.' ;
C2.MarkerSize = 15 ;

C3 = errorbar(1:15, adap_dur_2D_mean(3,:), adap_dur_2D_se(3, :), Z, '-o'); hold on
C3.Color = Color3; 
C3.Marker = '.' ;
C3.MarkerSize = 15 ;

C4 = errorbar(1:15, adap_dur_2D_mean(4,:), adap_dur_2D_se(4, :), Z, '-o'); hold on
C4.Color = Color4; %20dB SPL, more redish color
C4.Marker = '.' ;
C4.MarkerSize = 15 ;

x1= 0.45; %this value is random, just set up the initial point; larger==righter
y1= 0.27; %this value determines the starting height of two arrow; larger==higher
y_step_prop = nanmean(adap_dur_2D_mean(1,:)) - nanmean(adap_dur_2D_mean(4,:)); %80-20dB
y_norm = 0.3065-0.0545 ; %0.3065@35%, 0.0545@0%
y2_dB=y1-y_step_prop/35*y_norm; %larger==upper; 35 is the range of y-axis
annotation('arrow', [x1 x1], [y1 y2_dB], 'HeadStyle', 'vback2', 'LineWidth', 1.5) 

y_step_prop = nanmean(adap_dur_2D_mean(:,15)) - nanmean(adap_dur_2D_mean(:,1)); %#15-#1
x_norm = 0.96-0.15 ; %0.15@#1, 0.96@#15
x2=x1+0.4; %X-axis only increase this step
y2=y1+y_step_prop/35*y_norm*(0.4/x_norm);  %35 is the range of y-axis
annotation('arrow', [x1 x2]+0.05, [y1 y2], 'HeadStyle', 'vback2', 'LineWidth', 1.5)
annotation('line', [x1 x2]+0.05, [y1 y1], 'LineWidth', 0.5, 'LineStyle','--')
annotation('line', [x2 x2]+0.05, [y1 y2], 'LineWidth', 0.5, 'LineStyle','--')
% annotation('textbox',[x1+0.07 y1-0.105 .1 .1], 'String', 'adaptation', 'FontSize', 10, 'EdgeColor', 'none')
spot1_x = 5.6; spot1_y = 25.5;
plot(spot1_x, spot1_y, '.', 'Color', Color4, 'MarkerSize', 15)
plot(spot1_x, spot1_y+1.75, '.', 'Color', Color3, 'MarkerSize', 15)
plot(spot1_x, spot1_y+3.5, '.', 'Color', Color2, 'MarkerSize', 15)
plot(spot1_x, spot1_y+5.25, '.', 'Color', Color1, 'MarkerSize', 15)

text(axe, T.x, T.y, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
% lgd= legend(axe,{'20dB SPL', '40dB SPL', '60dB SPL', '80dB SPL'}); lgd.Box='off'; lgd.FontSize=A.s;
% lgd.Position(2)=lgd.Position(2) + 0.04; lgd.Location='northwest';
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t;
axe.TickDir='out'; axe.XTick = 1:15 ;
axe.Title.String='Adaptation: 63 units 390 sessions (continuous)'; 
axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
xlabel('Speaker rank', 'FontSize', 7); ylabel('Proportion of adaptation trials (%)', 'FontSize', 7)
%%
exportgraphics(gcf, 'Fig4.pdf','ContentType','vector', 'BackgroundColor','none')