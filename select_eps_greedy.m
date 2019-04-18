%******************************************************
%----- Zahra Sadeghi
%----- University of Tehran
%----- Institute for Research in Fundamental Sciences (IPM)
%----- zahra.sadeghi@ut.ac.ir
%----- zahra.sadeghi@ipm.ac.ir
%******************************************************
function max_act=select_eps_greedy(eps,Q)
r=rand(1,1);
if r<=1-eps
[max_val,max_act]=max(Q);
% max_act
else
    pr(1)=1-eps;
    for i=2:5
    pr(i)=1-eps+i*eps/4;
    end
    pr=sort(pr);
    for i=1:5
        if r<pr(i)
            max_act=i;
            break;
        end
    end
% %%%%select at random one action
% max_act=1+round(4*rand(1,1));
% % max_act=floor (rand * 5 + 1);
end


% switch r
%     case r<=1-eps
%      [max_val,max_act]=max(Q);
%     case r<=1-eps+eps/4
%     