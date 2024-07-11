% null-hypotheis: any stimulus could evoke Nconsec facilitation trials in the EFile
% Reject: shuffle EFile 1000times, less than 10 (CI99,p<0.01) times evoked this phenomenoa.
% Two methods to generate the shuffled spike train:
% method 1: use mu&sigma of UFile to generate 1000 Gaussian distributed spike rate then randperm 
% maximum random number for 1:3 is 2^3=6(2^10=1024);
% method 2: randperm the spike train of UFile directly

% run this after <Zscore_with_EFile> first cell to get UFile_spikes_all.
% use > & < as threshold but not >= & <=
% threshold with the firing rate from outside EFile of Target Spkr, not UFile of itself
% 2022-12-28
fig = figure; fig.Units = "centimeters";
fig.Color = "White"; %evenif using 'None', there is a still white-filled square
fig.InnerPosition = [10, 12, 12, 10] ; 
fig.PaperSize = fig.Position(3:4); fig.PaperUnits = "centimeters" ;

N=length(UFile_spikes_all);
rng('default') % fix the random number generator (rng)
C{1} = [153,112,193]/256; %violet
C{2} = [185,141,62]/256; %brown
C{3} = [100,168,96]/256; %green
C{4} = [204,84,94]/256; %pink-red
Ns=1; % number of shuffle for each neuron; previously used 1000times 
consec_len = 15 ; % smaller STD could have more consecutive trials
trial_len_U=50; % lower limit for considering consec-trials in UFile
trial_len_E=5; % lower limit for computing mu&sigma in EFile
N_void=[];
SD_all=[0.5;1;1.5;2];
seg_length_4SD=cell(4,1);
seg_length_shuffle_4SD=cell(4,1);
seg_long_length_num=nan(4,N); % counts of long duration segment in each session
consecN_faci_real_4SD=nan(4, consec_len);
for ss = 1 : 4 % 1:4 for 4 SDs, 2:2 for interested 1SD
Nsd = SD_all(ss) ; % number of standard deviation above baseline that is consecutive 
consecN_faci_real=nan(N,consec_len);
consecN_adap_real=nan(N,consec_len);
consecN_faci_shuffle=nan(N,consec_len);
consecN_adap_shuffle=nan(N,consec_len);
seg_length_cat=[];
seg_length_shuffle_cat=[];
for n = 1 : N
    U_real=UFile_spikes_all{n};
    E_real=EFile_spikes_all{n};
    if sum(abs(U_real))~=0 && numel(U_real)>=trial_len_U && sum(abs(E_real))~=0 && numel(E_real)>=trial_len_E
    %if sum(U_real)~=0 && numel(U_real)>=trial_len_U && sum(E_real)~=0 && numel(E_real)>=trial_len_E
    faci_thres=mean(E_real)+Nsd*std(E_real); adap_thres=mean(E_real)-Nsd*std(E_real); 
    t = U_real > faci_thres;
    id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
    id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
    seg_length = (id_end - id_start)+1 ; %5-6-7-8-9 is 5 trials so the segment length is: 9-5+1=5
    seg_long_length_num(ss,n)=numel(find(seg_length>=5));
    seg_length_cat=[seg_length_cat;seg_length'];
    for c = 1 : consec_len
        consecN_faci_real(n,c)=numel(find(seg_length>=c))>=1;%only 0 or 1
    end   
    t = U_real < adap_thres;
    id_start = strfind([0 t], [0 1]) ; 
    id_end = strfind([t 0], [1 0]) ;  
    seg_length = (id_end - id_start)+1 ; 
    for c = 1 : consec_len
        consecN_adap_real(n,c)=numel(find(seg_length>=c))>=1;
    end  

    U=U_real(randperm(numel(U_real)));
%     U=normrnd(mean(U_real),std(U_real), 1, numel(U_real));           
    faci_temp=zeros(Ns, consec_len);%update after each neuron
    for r = 1 : Ns        
        t = U(randperm(numel(U))) > faci_thres;
        id_start = strfind([0 t], [0 1]) ;
        id_end = strfind([t 0], [1 0]) ;
        seg_length = (id_end - id_start)+1 ;
        seg_length_shuffle_cat=[seg_length_shuffle_cat;seg_length'];
        for c = 1 : consec_len         
            faci_temp(r,c)=numel(find(seg_length>=c))>=1;
        end   
    end
    if Ns>1
    consecN_faci_shuffle(n,:)=100*sum(faci_temp)/Ns;%how many times
    elseif Ns==1
    consecN_faci_shuffle(n,:)=faci_temp;    
    end
    
    adap_temp=zeros(Ns, consec_len);%update after each neuron
    for r = 1 : Ns        
        t = U(randperm(numel(U))) < adap_thres;
        id_start = strfind([0 t], [0 1]) ;
        id_end = strfind([t 0], [1 0]) ;
        seg_length = (id_end - id_start)+1 ;
        for c = 1 : consec_len         
            adap_temp(r,c)=numel(find(seg_length>=c))>=1;
        end       
    end

    if Ns>1
    consecN_adap_shuffle(n,:)=100*sum(adap_temp)/Ns;%how many times
    elseif Ns==1
    consecN_adap_shuffle(n,:)=adap_temp;    
    end

    else % threshold for selecting sessions
    N_void=[N_void; n];
    end % threshold for selecting sessions
end % Medium loop for all neurons
N_update=N-numel(N_void);
consecN_faci_real(N_void,:)=[];
consecN_adap_real(N_void,:)=[];
consecN_faci_shuffle(N_void,:)=[];
consecN_adap_shuffle(N_void,:)=[];
consecN_faci_real_4SD(ss,:)=sum(consecN_faci_real);
seg_length_4SD{ss} = seg_length_cat;
seg_length_shuffle_4SD{ss} = seg_length_shuffle_cat;
errorbar(1:consec_len,100*sum(consecN_faci_real)/size(consecN_faci_real,1), ...
    100*std(consecN_faci_real)./sqrt(sum(consecN_faci_real)), ...
    'LineWidth',0.5,'Color',C{ss});hold on
errorbar(1:consec_len,100*sum(consecN_faci_shuffle)/size(consecN_faci_shuffle,1), ...
    100*std(consecN_faci_shuffle)./sqrt(sum(consecN_faci_shuffle)), ...
    'LineStyle','-.','LineWidth',0.5,'Color',C{ss});hold on
end % Big loop for multiple SDs
legend({'\mu+0.5\sigma','shuffle','\mu+1.0\sigma','shuffle', ...
    '\mu+1.5\sigma','shuffle','\mu+2.0\sigma','shuffle'},'Box','off')
xlabel('# consecutive trials with driven rate>\mu+X\sigma');
xlim([1 consec_len]); xticks(1:1:consec_len);
ylabel('Proportion of sessions (%)');ylim([0 100])
set(gca, 'YScale', 'log');ylim([0.3 100]);
yticks([0.3 1 10 100]);yticklabels({'0.3','1','10','100'})
% exportgraphics(gcf, 'Fig3_consecutive_faci_trials in 4 thres.pdf','ContentType','vector',...
%     'BackgroundColor','none')
%%
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.02 Y_size*0.05 X_size*0.95 Y_size*0.8]);%1 line
tiledlayout(2,4,"TileSpacing","compact"); %1 line
for ss = 1 : 4
nexttile;
bar(consecN_faci_real_4SD(ss, 2:end));xlim([0.5 15]);ylim([0 600])
nexttile;
histogram(seg_length_4SD{ss, 1},'BinWidth',1,'BinEdges' ,1:1:15 );
set(gca, 'YScale', 'log');
xlim([0.5 16])
end
% exportgraphics(gcf, 'Fig3_sessions have #consecutive_faci_trials in 4 thres.pdf','ContentType','vector',...
%     'BackgroundColor','none')
%% this will show the number of long facilitation segment for 129sessions 
A=seg_long_length_num(2,:);
A=A(A>0);
figure;histogram(A)