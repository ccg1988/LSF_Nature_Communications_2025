% Show the firing rate distribution of 5 types: 
% equal-all, equal-prefer, equal-nonprefer, 100% prefer, 100% non-prefer
% @ 2022-12-29

clear;clc;close all
load('Firing_Driven_all_units.mat');% EFile_all & EFile_target & UFile+unit+ch+rank
id1 = 36 ; id2 = 30 ;
E_all=Firing_all_units{id1,1};
E_T1=Firing_all_units{id1,2};U1=Firing_all_units{id1,3};
E_T2=Firing_all_units{id2,2};U2=Firing_all_units{id2,3};
rng('default'); U2=U2(randperm(100));% match the file length
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
tiledlayout(1,2,"TileSpacing","compact"); %1 line
nexttile; % X=-50:5:100; %only support nbins, but not bin step-size
%A1=histfit(E_all,30,'kernel');hold on;A1(1).FaceColor=rgb('Silver');A1(1).FaceAlpha=0.7;A1(2).LineStyle='-.';
A2=histfit(E_T2,15,'kernel'); A2(1).FaceColor=rgb('SteelBlue');
    A2(1).FaceAlpha=0.7;A2(2).LineStyle='-.';hold on;
A3=histfit(E_T1,10,'kernel'); A3(1).FaceColor=rgb('SandyBrown');A3(1).FaceAlpha=0.7;A3(2).LineStyle='-.';
xlabel('Firing rate (spikes/s)'); ylabel('Trial #'); xlim([0 125]);
title({['equal all mean=',num2str(mean(E_all)),' SD=',num2str(std(E_all)),' N=',num2str(numel(E_all))] ...
    ['rank',num2str(Firing_all_units{id2,6}),' mean=',num2str(mean(E_T2)),' SD=',num2str(std(E_T2)),' N=',num2str(numel(E_T2))] ...
    ['rank',num2str(Firing_all_units{id1,6}),' mean=',num2str(mean(E_T1)),' SD=',num2str(std(E_T1)),' N=',num2str(numel(E_T1))]})
nexttile
%B1=histfit(E_all,30,'kernel'); hold on;B1(1).FaceColor=rgb('Silver');B1(1).FaceAlpha=0.7;B1(2).LineStyle='-.';
B2=histfit(U2,15,'kernel');B2(1).FaceAlpha=0.7;B2(1).FaceColor=rgb('SteelBlue');hold on;
B3=histfit(U1,9,'kernel');B3(1).FaceAlpha=0.7;B3(1).FaceColor=rgb('SandyBrown');
title({['rank',num2str(Firing_all_units{id2,6}),' mean=',num2str(mean(U2)),' SD=',num2str(std(U2)),' N=',num2str(numel(U2))] ...
    ['rank',num2str(Firing_all_units{id1,6}),' mean=',num2str(mean(U1)),' SD=',num2str(std(U1)),' N=',num2str(numel(U1))]})
xlim([0 125]);
%%
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.32 Y_size*0.35 X_size*0.4 Y_size*0.3]);%1 line
A3=histfit(E_T1,10,'kernel'); A3(1).FaceColor=rgb('SteelBlue');
    A3(1).FaceAlpha=0.7;A3(2).LineStyle='-.';hold on
B3=histfit(U1,10,'kernel');B3(1).FaceAlpha=0.7;B3(1).FaceColor=rgb('SandyBrown');    