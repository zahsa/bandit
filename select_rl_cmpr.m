%******************************************************
%----- Zahra Sadeghi
%----- University of Tehran
%----- Institute for Research in Fundamental Sciences (IPM)
%----- zahra.sadeghi@ut.ac.ir
%----- zahra.sadeghi@ipm.ac.ir
%******************************************************
function sel_arm=select_rl_cmpr(P)
n_armed=5;
for i=1:n_armed
prob(i)=exp(P(i))/(sum(exp(P)));
% prob(i)=(P(i))/sum((P));
end
r=rand(1,1);
% %%%%%%%%%%%%%CUMSUM%%%%%%%%%%%%%%
% % for i=1:5
% %     cum_prob(i)=prob(i);
% %     for j=1:i-1
% %         cum_prob(i)=cum_prob(i)+prob(j);
% %     end
% % end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cum_prob=cumsum(prob);

for i=1:n_armed
    if r<=cum_prob(i)
        sel_arm=i;
        break;
    end
end

% n=histc(r,cum_prob);
% cQ=find(n==1);
