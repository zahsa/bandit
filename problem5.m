%******************************************************
%----- Zahra Sadeghi
%----- University of Tehran
%----- Institute for Research in Fundamental Sciences (IPM)
%----- zahra.sadeghi@ut.ac.ir
%----- zahra.sadeghi@ipm.ac.ir
%******************************************************
%% eps-greedy
eps=0.5;
% prob_eps=zeros(1,1000);
% e=round(eps*1000); 
% prob_eps(1:e)=ones(1,e);
% tem=randperm(1000);
% prob_eps=prob_eps(tem);
for i=1:100
    %% INIT
    j=1;
    for k=1:5
%         Q(j,i,k)=100*rand(1,1);
        Q(j,i,k)=100*rand(1,1);
        selected(k)=0;
        Q_sum(k)=0;
    end
%     eps=0.5;
    %% MAIN LOOP
    for j=2:1000
%         sel_arm=select_eps_greedy2(prob_eps,Q(j-1,i,:));
        sel_arm=select_eps_greedy(eps,Q(j-1,i,:));
        selected(sel_arm)=selected(sel_arm)+1;
        rwrd=Bandit(810188447,sel_arm);
%         rwrd = reward(sel_arm);
%         reward=randn(1,5);
%         rwrd=reward(sel_arm);
        
        for k=1:5
            Q(j,i,k)=Q(j-1,i,k);
        end
          Q_sum(sel_arm)=rwrd+Q_sum(sel_arm);
          Q(j,i,sel_arm)=Q(j-1,i,sel_arm)+(1/selected(sel_arm))*(Q_sum(sel_arm));
%         Q(j,i,sel_arm)=Q(j-1,i,sel_arm)+(1/selected(sel_arm))*(rwrd-(Q(j-1,i,sel_arm)));
        Q_sel(j,i)=rwrd;%Q(j,i,sel_arm);
    end
end

win_size=1000;
        AvgR=zeros(1000,100);
            for tt=1:100
                AvgR(1:win_size,tt)=cumsum(Q_sel(1:win_size,tt));
                for m=1:win_size
                    AvgR(m,tt)=AvgR(m,tt)/m;
                end
%                 for s=1:1000-win_size
%                     AvgR(s+win_size,tt)=sum(Q_sel(s:s+win_size,tt))/win_size;
%                 end
            end
            
Q_sel=AvgR;

for j=1:1000
    AR_greedy(j)=mean(Q_sel(j,:));
end
%% PLOT
plot(AR_greedy,'r')
hold on

%% eps-greedy-adaptive
% figure
for i=1:100
    %% INIT
    j=1;
    for k=1:5
%         Q(j,i,k)=100*rand(1,1);
        Q(j,i,k)=100*rand(1,1);
        selected(k)=0;
        Q_sum(k)=0;
    end
    eps=0.5;
    %% MAIN LOOP
    for j=2:1000
        %% ADAPTIVE eps
%         prob_eps=zeros(1,1000);
%         e=round(eps*1000);
%         prob_eps(1:e)=ones(1,e);
%         tem=randperm(1000);
%         prob_eps=prob_eps(tem);
        %% SELECT A POLICY
%         sel_arm=select_eps_greedy2(prob_eps,Q(j-1,i,:));
        sel_arm=select_eps_greedy(eps,Q(j-1,i,:));
        selected(sel_arm)=selected(sel_arm)+1;
        rwrd=Bandit(810188447,sel_arm);
%         reward=randn(1,5);
%         rwrd=reward(sel_arm);
%         rwrd = reward(sel_arm);
        for k=1:5
            Q(j,i,k)=Q(j-1,i,k);
        end
        Q_sum(sel_arm)=rwrd+Q_sum(sel_arm);
        Q(j,i,sel_arm)=Q(j-1,i,sel_arm)+(1/selected(sel_arm))*(Q_sum(sel_arm)); 
%         Q(j,i,sel_arm)=Q(j-1,i,sel_arm)+(1/selected(sel_arm))*(rwrd-(Q(j-1,i,sel_arm)));
        Q_sel(j,i)=rwrd;%Q(j,i,sel_arm);
        %update eps
%         eps=eps/(1+1.01*j);
         eps=eps*exp(-0.001*j);
    end
end

win_size=1000;
        AvgR=zeros(1000,100);
            for tt=1:100
                AvgR(1:win_size,tt)=cumsum(Q_sel(1:win_size,tt));
                for m=1:win_size
                    AvgR(m,tt)=AvgR(m,tt)/m;
                end
%                 for s=1:1000-win_size
%                     AvgR(s+win_size,tt)=sum(Q_sel(s:s+win_size,tt))/win_size;
%                 end
            end
            Q_sel=AvgR;


%% COMPUTE AVERAGE
for j=1:1000
    AR_greedy(j)=mean(Q_sel(j,:));
end
%% PLOT
plot(AR_greedy,'m')
hold on
% % % 

%% rl-comparison
% figure
% 
for i=1:100
    %% INIT
    clear P
    j=1;
    for k=1:5
        P(j,i,k)=(1/5)*ones(1,1);%rand(1,1);
        selected(k)=0;
    end
    %     alpha=0.1;%1/j;
    %     beta=0.1;%1/j;
    ref_rwrd=0;

    %% MAIN LOOP
    for j=2:1000
        %% SELECT A POLICY
        %         sel_arm=select_rl_cmpr(P(j-1,i,:));

        for ii=1:5
            prob(ii)=exp(P(j-1,i,ii))/(sum(exp(P(j-1,i,:))));
            % prob(i)=(P(i))/sum((P));
        end
        cum_prob=cumsum(prob);
        rr=rand(1,1);
        for ii=1:5
            if rr<=cum_prob(ii)
                sel_arm=ii;
                break;
            end
        end


        selected(sel_arm)=selected(sel_arm)+1;
        alpha=0.1;%1/selected(sel_arm);
        beta=1/selected(sel_arm);%1/j;
        rwrd=Bandit(810188447,sel_arm);
        %        rwrd = reward(sel_arm);
        for k=1:5
            P(j,i,k)=P(j-1,i,k);
        end
        P(j,i,sel_arm)=P(j-1,i,sel_arm)+beta*(rwrd-ref_rwrd);
        ref_rwrd=ref_rwrd+alpha*(rwrd-ref_rwrd);
        P_sel(j,i)=rwrd;%ref_rwrd;

    end
end 
    
    win_size=1000;
        AvgR=zeros(1000,100);
        
       
            for tt=1:100
%                 size(P_sel)
                AvgR(1:win_size,tt)=cumsum(P_sel(1:win_size,tt));
                for m=1:win_size
                    AvgR(m,tt)=AvgR(m,tt)/m;
                end
            end
            P_sel=AvgR;
       
    
    %% COMPUTE AVERAGE
    for j=1:1000
        AR_cmp(j)=mean(P_sel(j,:));
    end
    %     save('data','P');

%% PLOT

plot(AR_cmp,'b')
hold on
xlabel('Iteration Number'), ylabel('Average Reward');
legend('Eps-Greedy','Adaptive Eps','Reinforcement Comparison')
% 
