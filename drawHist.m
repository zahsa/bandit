%******************************************************
%----- Zahra Sadeghi
%----- University of Tehran
%----- Institute for Research in Fundamental Sciences (IPM)
%----- zahra.sadeghi@ut.ac.ir
%----- zahra.sadeghi@ipm.ac.ir
%******************************************************
% function drawHist()
for k=1:5
    for j=1:1000
        smpl(k,j)=Bandit(810188447,k);
        round_smpl(k,j)=round(smpl(k,j));
    end
end

for k=1:5
    max_val(k)=max(round_smpl(k,:));
    min_val(k)=min(round_smpl(k,:));
end


for k=1:5
    hist(round_smpl(k,:),min_val(k):1:max_val(k))
    figure
end