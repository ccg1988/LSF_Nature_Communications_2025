% run after "Zscore_with_EFile.m"
% check the Z-score from individual sessions
% @ 2022-12-29

n = 30 ; % 369(Rank9, facilitation) 48(Rank1, adaptation) 177(Rank1,no effect)
C1 = [185,141,62]/256; %brown
C2 = [100,168,96]/256; %green
sz=4;
E_rates=EFile_spikes_all{n}; %driven rates
[zsE,muE,sigmaE]=zscore(E_rates);
U_rates=UFile_spikes_all{n};
U_rates_fake=normrnd(muE,sigmaE,[1,numel(U_rates)]);
zsU=(U_rates-muE)/sigmaE;
zsUmatch_x=sort(randperm(numel(U_rates),numel(E_rates)));%random trials for matching
zsUmatch=zsU(zsUmatch_x);
zsUfake=(U_rates_fake-muE)/sigmaE;
figure;plot(1:numel(zsE),zsE,'LineStyle','none',...
    'LineWidth',0.5,'Color',rgb('silver'),'Marker','o',...
    'MarkerSize',sz,'MarkerFaceColor',C1,'MarkerEdgeColor',C1);hold on
    %comment this plot if removing the matched equal-prob mode
plot(numel(zsE)+1:numel(zsE)+numel(zsUfake),zsUfake,...
    'LineWidth',0.5,'Color',rgb('silver'),'Marker','o',...
    'MarkerSize',sz,'MarkerFaceColor',C1,'MarkerEdgeColor',C1);hold on

plot(numel(zsE)+1:numel(zsE)+numel(zsU), zsU,'LineWidth',0.5,'Color',rgb('silver'),'Marker','o',...
    'MarkerSize',sz,'MarkerFaceColor',C2,'MarkerEdgeColor',C2);
legend({'equal prob. target spkr.','equal prob. target spkr. matched','100% prob. target spkr.'})
% plot(numel(zsE)+zsUmatch_x, zsUmatch,'LineStyle','none','Marker','o',...
%     'MarkerSize',3,'MarkerEdgeColor','none','MarkerFaceColor',rgb('DarkGreen'))
ylabel('Driven rate Z-score');xlabel('Trial #');xlim([1 numel(zsE)+numel(zsU)]);
%%
N=numel(E_rates)+numel(U_rates);
Nsd=[0.5, 1, 1.5, 2];
% figure('OuterPosition',[100 100 10 10]);
figure
plot(1:numel(E_rates),E_rates,'LineStyle','none',...
    'LineWidth',0.5,'Color',rgb('silver'),'Marker','o',...
    'MarkerSize',sz,'MarkerFaceColor',C1,'MarkerEdgeColor',C1);hold on
plot(numel(E_rates)+1:numel(E_rates)+numel(U_rates), U_rates,'LineWidth',0.5,'Color',rgb('silver'),'Marker','o',...
    'MarkerSize',sz,'MarkerFaceColor',C2,'MarkerEdgeColor',C2);
text(50, mean(E_rates)-0.5,'\mu')
plot(1:N, mean(E_rates)*ones(1,N),'LineStyle','-.','Color','k')
for s = 1 : numel(Nsd)
    thresF=mean(E_rates)+Nsd(s)*std(E_rates);
    per=num2str(100*(numel(find(U_rates>thresF))/numel(U_rates)));
    text(50, thresF-0.5,['\mu+',num2str(Nsd(s)),'\sigma'])
    text(252, thresF,[per,'%'])
    plot(1:N, thresF*ones(1,N),'LineStyle','-.','LineWidth',Nsd(s),'Color',rgb('SandyBrown'))
    
    thresA=mean(E_rates)-Nsd(s)*std(E_rates);
    per=num2str(100*(numel(find(U_rates<thresA))/numel(U_rates)));
    text(50, thresA-0.5,['\mu-',num2str(Nsd(s)),'\sigma'])
    text(252, thresA,[per,'%'])
    plot(1:N, thresA*ones(1,N),'LineStyle','-.','LineWidth',Nsd(s),'Color',rgb('SteelBlue'))
end    
% legend({'equal prob. target spkr.','100% prob. target spkr.'})

ylabel('Driven rate (spikes/s)');xlabel('Trial #');xlim([1 N]);