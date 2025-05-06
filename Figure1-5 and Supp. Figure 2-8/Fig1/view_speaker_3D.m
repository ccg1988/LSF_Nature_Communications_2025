function view_speaker_3D(spkr_table, spkr_size, view_angle)

Color2 = [185,141,62]/256; %brown
Color3 = [100,168,96]/256; %green
Color4 = [204,84,94]/256; %pink-red

[x,y,z] = sphere; %returns the x(21*21)/y/z coordinates of a sphere without drawing it
% s=surf(x, y, z); %this will show Up (11-21) & Down (1-10)
S=surf(x(11:21,:),y(11:21,:),z(11:21,:), 'EdgeColor', rgb('Black'), 'FaceColor', 'black'); 
S.FaceLighting = 'none'; %no effect so far
S.FaceAlpha=0.1;
S.LineWidth = 0.5 ; S.LineStyle = '-'; 
S.EdgeLighting='none'; %no effect so far
% S.AmbientStrength=1; %no effect so far
axe = gca ; axe.GridColor='w'; axe.FontSize=5; axe.FontName='Arial';
axe.DataAspectRatio = [1 1 1]; %equal the xyz, but it's inconsisent with Mollevide projection figure and SRF
% axis off; 
hold on;

i = [6 10 11 14];
scatter3(spkr_table(i,5), spkr_table(i,6), spkr_table(i,7), spkr_size, Color2, 'filled'); hold on
i = [4 5 7 8 13];
scatter3(spkr_table(i,5), spkr_table(i,6), spkr_table(i,7), spkr_size, Color3, 'filled'); hold on
i = [9 2 3 12 15 16];
scatter3(spkr_table(i,5), spkr_table(i,6), spkr_table(i,7), spkr_size, Color4, 'filled'); hold on

view(view_angle);
if view_angle(2)==90
    axe.XAxisLocation='top';
%     pbaspect([0.9 0.9 1]); %not works when X==Y    
end    
axe.XTick=[-1 0 1];axe.XTickLabel={'90\circ', '  0\circ', '-90\circ'};  
axe.YTick=[-1 0 1];axe.YTickLabel={'-180\circ', '-90\circ', '0\circ'};
axe.ZTick=[0 1];axe.ZTickLabel={'0\circ', '90\circ'};