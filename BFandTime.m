function [Time, BF, endBF] = BFandTime(num)

BF = [];
Time = [];
[a b] = size(num);
for kk = 1:(b/4)
    aa = isnan(num(:,4*kk));
    ba = find(aa==1);
    if isempty(ba)==1
        ca(kk) = length(BF);
    else
        ca(kk) = ba(1)-1;
    end
    
    BF = [BF; num(1:ca(kk),4*kk)];
    Time = [Time; num(1:ca(kk),4*kk-1)];
end

endBF = ca;

figure 
t = (1/(32*60))*(1:length(BF));
plot(t,BF)
xlabel('Time (minutes)', 'FontSize',15)
ylabel('Blood Perfusion','FontSize',15)
title('Blood perfusion throughout test','FontSize',16)
set(gca,'FontSize',14)
return;
