function homework1(problem)
clear all
figure
%problem=5;
n_armed=5;

if problem==1
    drawHist();
elseif problem==2
    eps=[0.1 0.2 0.5];
    final=3;
elseif problem==3
    eps=[0.5 0.5 0.5 0.5 0.5 0.5];
    final=6;
elseif problem==4
    final=5;
    %         ref_rwrd=[0 0 0 0 100];
end
if problem~=1 && problem~=5
    for t=1:final
        for i=1:100
            %% INIT
            j=1;
            for k=1:n_armed
                Q(j,i,k)=100;%100*rand(1,1);
                P(j,i,k)=(1/5)*ones(1,1);%rand(1,1);0;%rand(1,1);
                selected(k)=0;
                Q_sum(k)=0;
            end
            if problem==3
                eps=[0.5 0.5 0.5 0.5 0.5 0.5];
            elseif problem==4
                if t==1 || t==3
                    alpha=0.1;
                    %                 else
                    %                     alpha=1/j;
                end
                if t==1 || t==2 || t==5
                    beta=0.1;
                    %                 else
                    %                     beta=1/j;
                end
%                 if t==6
%                     beta=0.01;
                    %                 else
                    %                     beta=1/j;
%                 end
                if t==1 || t==2 || t==3 || t==4
                    ref_rwrd=0;
                else
                    ref_rwrd=100;
                end
                
            end
            %% MAIN LOOP
            for j=2:1000
                %% SELECT A POLICY
                if problem==2 || problem==3
                    sel_arm=select_eps_greedy(eps(t),Q(j-1,i,:));
                    selected(sel_arm)=selected(sel_arm)+1;
                elseif problem==4
                    %                     sel_arm=select_rl_cmpr(P(j-1,i,:));


                    for ii=1:5
                        prob(ii)=exp(P(j-1,i,ii))/(sum(exp(P(j-1,i,:))));
                        % prob(i)=(P(i))/sum((P));
                    end
                    cum_prob=cumsum(prob);
                    rr=rand(1,1);
                    for ii=1:n_armed
                        if rr<=cum_prob(ii)
                            sel_arm=ii;
                            break;
                        end
                    end







                    selected(sel_arm)=selected(sel_arm)+1;
                    if t==2 || t==4 || t==5
                        alpha=1/selected(sel_arm);
                    end
                    if t==3 || t==4
                        beta=1/selected(sel_arm);
                    end
                end

                rwrd=Bandit(810188447,sel_arm);
%                 reward=randn(1,5);
%                 rwrd=reward(sel_arm);
%                 rwrd = reward(sel_arm);

                for k=1:n_armed
                    Q(j,i,k)=Q(j-1,i,k);
                    P(j,i,k)=P(j-1,i,k);
                end

                if problem==2 || problem==3
                    Q_sum(sel_arm)=rwrd+Q_sum(sel_arm);
                    Q(j,i,sel_arm)=Q(j-1,i,sel_arm)+(1/selected(sel_arm))*(Q_sum(sel_arm));
                    Q_sel(j,i)=rwrd;%Q(j,i,sel_arm);
                elseif problem==4
                    P(j,i,sel_arm)=P(j-1,i,sel_arm)+beta*(rwrd-ref_rwrd);
                    ref_rwrd=ref_rwrd+alpha*(rwrd-ref_rwrd);
                    P_sel(j,i)=rwrd;%ref_rwrd;
% %                     P(j,i,sel_arm)=P(j-1,i,sel_arm)+(1/selected(sel_arm))*(rwrd-(P(j-1,i,sel_arm)));
% %                     P_sel(j,i)=rwrd;%P(j,i,sel_arm);
                end
                if problem==3
                    %% ADAPTIVE eps
                    switch t
                        case 1
                            eps(t)=eps(t)/(1+0.1*j);
                        case 2
                            eps(t)=eps(t)/(1+0.01*j);
                        case 3
                            eps(t)=eps(t)/1.1;
                        case 4
                            eps(t)=eps(t)/1.01;
                        case 5
                            eps(t)=eps(t)*exp(-0.01*j);
                        case 6
                            eps(t)=eps(t)*exp(-0.001*j);
% %                         case 7
% %                             eps(t)=eps(t)*exp(-0.01*j);
% %                             eps(t)=eps(t)/1.00001;
% %                         case 8    
% %                             eps(t)=eps(t)*exp(-0.001*j);
                    end
                    %% varaiable alpha and beta
                    %                 elseif problem==4
                    %                     if t==2 || t==4 || t==5
                    %                         alpha=1/j;
                    %                     end
                    %                     if t==3 || t==4
                    %                         beta=1/j;
                    %                     end
                end
            end
        end
        
        
        
        
        win_size=1000;
        AvgR=zeros(1000,100);
        if problem==2 || problem==3
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
        elseif problem==4
            for tt=1:100
                AvgR(1:win_size,tt)=cumsum(P_sel(1:win_size,tt));
                for m=1:win_size
                    AvgR(m,tt)=AvgR(m,tt)/m;
                end
            end
            P_sel=AvgR;
        end
        
        
        
        
        
        %% COMPUTE AVERAGE
        for j=1:1000
            if problem==2 || problem==3
                AR_greedy(j)=mean(Q_sel(j,:));
            elseif problem==4
                AR_cmp(j)=mean(P_sel(j,:));
            end
        end

        %% PLOT
        if problem==2 || problem==3
            if t==1
                plot(AR_greedy,'r')
                hold on
            elseif t==2
                plot(AR_greedy,'g')
                hold on
            elseif t==3
                plot(AR_greedy,'b')
                hold on
            elseif t==4
                plot(AR_greedy,'c')
                hold on
            elseif t==5
                plot(AR_greedy,'y')
                hold on
            elseif t==6
                plot(AR_greedy,'m') 
                hold on
%             elseif t==7
%                 plot(AR_greedy,'k')
%             elseif t==8
%                 plot(AR_greedy,'w')    
            end
            xlabel('Iteration Number'), ylabel('Average Reward');
            if problem==2
                legend('eps=0.1','eps=0.2','eps=0.5')
            elseif problem==3
                legend('a.','b.','c.','d.','e.','f.','g.')
            end
            hold on
        elseif problem==4
            if t==1
                plot(AR_cmp,'r')

                hold on
            elseif t==2
                plot(AR_cmp,'g')
                hold on
            elseif t==3
                plot(AR_cmp,'b')
            elseif t==4
                plot(AR_cmp,'c')
            elseif t==5
                plot(AR_cmp,'y')
            elseif t==6
                plot(AR_cmp,'m')    
            end
            xlabel('Iteration Number'), ylabel('Average Reward');
            legend('a.','b.','c.','d.','e.','f.')
            hold on
        end

    end
end

if problem==5
    problem5;
end
