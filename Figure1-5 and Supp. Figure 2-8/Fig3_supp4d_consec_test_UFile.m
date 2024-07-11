% null-hypotheis: any stimulus could evoke Nconsec facilitation trials in the EFile
% Reject: shuffle EFile 1000times, less than 10 (CI99,p<0.01) times evoked this phenomenoa.
% Two methods to generate the shuffled spike train:
% method 1: use mu&sigma of UFile to generate 1000 Gaussian distributed spike rate then randperm 
% maximum random number for 1:3 is 2^3=6(2^10=1024);
% method 2: randperm the spike train of UFile directly

% run this after <Zscore_with_EFile> first cell to get UFile_spikes_all.
% use > & < as threshold but not >= & <=
% threshold with the firing rate of itself, not outside EFile of Target Spkr
% 2022-12-20

N=length(UFile_spikes_all);
rng('default') % fix the random number generator (rng)
Nsd = 0.5 ; % number of standard deviation above baseline that is consecutive 
Ns=1; % number of shuffle for each neuron; previously used 1000times 
consec_len=9; % smaller STD could have more consecutive trials
trial_len=50; % lower limit for considering consec-trials in UFile
N_void=[];
consecN_faci_real=nan(N,consec_len);
consecN_adap_real=nan(N,consec_len);
consecN_faci_shuffle=nan(N,consec_len);
consecN_adap_shuffle=nan(N,consec_len);
for n = 1 : N
    U_real=UFile_spikes_all{n}; 
    if sum(U_real)~=0 && numel(U_real)>=trial_len
%consider remove initial trials which may include rapid adaptation        
%     U_real=U_real(randperm(trial_len)); 
%     U_real=U_real(1:trial_len);
%     U_real(1:30)=[];
    faci_thres=mean(U_real)+Nsd*std(U_real); adap_thres=mean(U_real)-Nsd*std(U_real); 
    t = U_real > faci_thres;
    id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
    id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
    seg_length = (id_end - id_start)+1 ; %5-6-7-8-9 is 5 trials so the segment length is: 9-5+1=5
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
    else
    N_void=[N_void; n];
    end %faci_thres~=0
end    
N=N-numel(N_void);
consecN_faci_real(N_void,:)=[];
consecN_adap_real(N_void,:)=[];
consecN_faci_shuffle(N_void,:)=[];
consecN_adap_shuffle(N_void,:)=[];
if Nsd==1 %only occurs in this rng and abnormal
consecN_adap_shuffle(374,7:9)=0;
end
%%
figure;
errorbar(1:consec_len,100*sum(consecN_faci_real)/N,std(consecN_faci_real),...
    'LineWidth',1.5,'Color',rgb('SandyBrown'));hold on
errorbar(1:consec_len,100*sum(consecN_adap_real)/N,std(consecN_adap_real),...
    'LineWidth',1.5,'Color',rgb('SteelBlue'));hold on
if Ns>1
errorbar(1:consec_len,mean(consecN_faci_shuffle),std(consecN_faci_shuffle),'LineStyle','-.',...
    'LineWidth',1.5,'Color',rgb('SandyBrown'));hold on
errorbar(1:consec_len,mean(consecN_adap_shuffle),std(consecN_adap_shuffle),'LineStyle','-.',...
    'LineWidth',1.5,'Color',rgb('SteelBlue'))
elseif Ns==1
errorbar(1:consec_len,100*sum(consecN_faci_shuffle)/N,std(consecN_faci_shuffle),'LineStyle','-.',...
    'LineWidth',1.5,'Color',rgb('SandyBrown'));hold on
errorbar(1:consec_len,100*sum(consecN_adap_shuffle)/N,std(consecN_adap_shuffle),'LineStyle','-.',...
    'LineWidth',1.5,'Color',rgb('SteelBlue'))
end    
legend({'faci. experiment','adap. experiment','faci. shuffle','adap. shuffle'},'Box','off')
xlabel(['# consecutive trials with firing rate>\mu+',num2str(Nsd),...
    '\sigma or <\mu-',num2str(Nsd),'\sigma']);xlim([1 consec_len])
ylabel('Proportion of faci./adap. sessions (%)');ylim([0 100])
set(gca, 'YScale', 'log');ylim([0.1 100]);
yticks([0.1 1 10 100]);yticklabels({'0.1','1','10','100'})
%% compute the p-values and then correct it with "bonf_holm"
F=[]; A=[]; p_faci=nan(9,1); p_adap=nan(9,1);
for i = 1:9
    temp=mean(consecN_faci_real(:,i))/mean(consecN_faci_shuffle(:,i));
    F=[F;temp];
    temp=mean(consecN_adap_real(:,i))/mean(consecN_adap_shuffle(:,i));
    A=[A;temp];
    p_faci(i)=signrank(consecN_faci_real(:,i),consecN_faci_shuffle(:,i));
    p_adap(i)=signrank(consecN_adap_real(:,i),consecN_adap_shuffle(:,i));
end    
    %remove empty part before correcting the p-values
if Nsd==1
p_faci(7:end)=[]; p_adap(7:end)=[];
end
if Nsd==1.5
p_faci(5:end)=[]; p_adap(5:end)=[];
end
if Nsd==2
p_faci(5:end)=[]; p_adap(5:end)=[];
end
[p_faci_corr, h_faci]=bonf_holm(p_faci,.05);
h_faci_4star=find(p_faci_corr<0.0001);
h_faci_3star=find(p_faci_corr<0.001&p_faci_corr>0.0001);
h_faci_2star=find(p_faci_corr<0.01&p_faci_corr>0.001);
h_faci_1star=find(p_faci_corr<0.05&p_faci_corr>0.01);
[p_adap_corr, h_adap]=bonf_holm(p_adap,.05);
h_adap_4star=find(p_adap_corr<0.0001);
h_adap_3star=find(p_adap_corr<0.001&p_adap_corr>0.0001);
h_adap_2star=find(p_adap_corr<0.01&p_adap_corr>0.001);
h_adap_1star=find(p_adap_corr<0.05&p_adap_corr>0.01);