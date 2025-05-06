% Did not specify the X and Y label size, it's proportional to Axis size; 6.6pt Label=6pt Axis

clear; clc; close all
load('spkr_table.mat')
load('Fig1_Speaker_SRF.mat')

F_size = 1 ; %3 (174mm, full-width) or 2 (114mm) or 1 (85mm) column 
W_n = 4 ; % # rows
H_n = 2 ; % # columns

W = 8.5 ;
H = 15 ; %centimeter
panel_inner_B = 0.05  ;
panel_inner_H = 0.9 ;
panel_titel_y = H/W_n - 0.4 ; %control the a/A locations
F_posi = [10, 2, W, H] ;

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
% T.A = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}; 
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

% https://medialab.github.io/iwanthue/, color-blind friendly
Color1 = [153,112,193]/256; %violet
Color2 = [185,141,62]/256; %brown
Color3 = [100,168,96]/256; %green
Color4 = [204,84,94]/256; %pink-red
spkr_size = 35;
%%
axe = nexttile; %similar as <subplot, before 2006a>; properties==axis
view_angle=[95, 30]; view_speaker_3D(spkr_table, spkr_size, view_angle)
lgd= legend(axe, {'', 'back','midline','front'}); lgd.Box='off'; lgd.FontSize=5;
lgd.Location='northeast';
lgd.Position(1)=lgd.Position(1) + 0.25; %X-axis, positive==shift right
lgd.Position(2)=lgd.Position(2) + 0.05; %+==shift up
lgd.Position(3)=0.04;
lgd.Position(4)=0.045;
lgd.Title.String = 'Speakers'; lgd.Title.FontSize = 6; lgd.Title.FontWeight='normal';
text(axe, T.x-0, T.y, T.A{1}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Title.String='Lateral view (3D)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Title.Position(1)=axe.Title.Position(1)-0.24; %1 is Y, 2 is X; positive is moving down
% xlabel('X', 'FontSize', 7); ylabel('Y', 'FontSize', 7); zlabel('Z', 'FontSize', 7)

axe = nexttile; 
view_angle=[90, 90]; view_speaker_3D(spkr_table, spkr_size, view_angle)
% text(axe, T.x, T.y, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Title.String='Top view (3D)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Title.Position(1)=axe.Title.Position(1)-0.1; %negative is moving up
%%
axe = nexttile([1 2]); 
spon = 0 ;
plot_on = 0 ;
[ ~, ~] = analyze_srf_half( Example_firing_rate, spon, plot_on); hold on; hold on
x_ticks = [-2.7 -3.1 -3 -1.5 -0.1 1.35 2.7];
y_ticks = [0.85 0 -0.16 -0.16 -0.16 -0.16 -0.16];
text_label = {'45\circ', '0\circ', '-180\circ', '-90\circ', '0\circ', '90\circ', '180\circ'};
for i = 1 : length(x_ticks)
    text(axe, x_ticks(i), y_ticks(i), text_label{i}, 'FontSize', A.s, 'FontName', A.t); hold on
end

x_ticks = [-0.3 -2.4 -2.9   -2.25 -1.5  -0.75 -0.05 0.7 1.35 2.1    -1.2 -0.7 -0.08 0.5 1.1];
y_ticks = [1.5 1.0 0.2      0.2 0.2 0.2 0.2 0.2 0.2 0.2     1.0 1.0 1.0 1.0 1.0];
spkr_label = {'12', '13', '5',    '10', '6', '8', '1', '2', '4', '9',     '7', '14', '11', '15', '3'};
for i = 1 : length(x_ticks)
    text(axe, x_ticks(i), y_ticks(i), spkr_label{i}, 'FontSize', A.s, 'FontName', A.t, 'FontWeight', 'bold'); hold on
end

xt = text(axe, -0.35, -0.4, 'Azimuth', 'FontSize', A.s+1, 'FontName', A.t, 'FontWeight', 'normal'); hold on
yt = text(axe, -3.3, 0.4, 'Elevation', 'FontSize', A.s+1, 'FontName', A.t, 'FontWeight', 'normal', 'Rotation', 90); hold on


text(axe, T.x, T.y-1, T.A{2}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Title.String='Front view (2D Mollweide projection)'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Title.Position(2)=axe.Title.Position(2)+0.1; %positive is moving up
%%
axe = nexttile([1 2]); 
spon = 0 ;
plot_on = 1 ;
[ tuning_area, tuning_vector_magnitude] = analyze_srf_half( Example_firing_rate, spon, plot_on); hold on
%Show scale-bar of spike/second
C_bar=colorbar('Ylim', [min(Example_firing_rate) max(Example_firing_rate)], 'location', 'west');
C_bar.Position(1)=C_bar.Position(1)-0.25; %raw is +0.15
C_bar.Position(2)=C_bar.Position(2)-0.15;
C_bar.Position(3)=C_bar.Position(3)-0.02; %raw is 0.045
C_bar.Position(4)=C_bar.Position(4)-0.02; %raw is 0.124
C_bar.FontName='Arial'; C_bar.FontSize=6;
tt=text(-3.25, 1, 'spikes/s',  'HorizontalAlignment','Left', 'VerticalAlignment','Top');
tt.FontSize=6; tt.FontName='Arial';

text(axe, T.x, T.y-1, T.A{3}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
axe.Title.String='Spatial receptive field  Unit M43S-383'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Title.Position(2)=axe.Title.Position(2)+0.1;
%%
axe = nexttile([1 2]); 
raster_X = Example_on_data(2, :);
raster_Y = Example_on_data(1, :)-200;
D1 = plot(raster_X, raster_Y, 'Marker', '.', 'MarkerSize', 5, 'LineWidth', 0.5, 'LineStyle','none'); hold on
D1.Color = rgb('SteelBlue') ;
axe.Box='off'; axe.FontSize=A.s; axe.FontName=A.t; axe.TickDir='out';
N = ones(1, 200); y_range = 1:200;
for i = 1 :16
    plot(i*N, y_range, 'Color', rgb('Silver'), 'LineWidth', 1, 'LineStyle','-'); hold on
end
x_range = 1 : 15;
axe.XTick = x_range+0.5 ; axe.XTickLabel = {num2str(x_range')};
axe.XLim=([0.5 16.5]); axe.YLim=([0 200]);
axe.Title.String='Equal-probability presentation  Unit M43S-383'; axe.Title.FontName=A.t; axe.Title.FontWeight='normal'; axe.Title.FontSize=8;
axe.Title.Position(2)=axe.Title.Position(2)+2;
text(axe, T.x, T.y, T.A{4}, 'FontSize', T.s, 'FontName', T.t, 'FontWeight', T.W, 'Units', 'centimeters');
xlabel('Speaker #', 'FontSize', 7); ylabel('Time (ms)', 'FontSize', 7)
%%
exportgraphics(gcf, 'Fig1.pdf','ContentType','vector', 'BackgroundColor','none')