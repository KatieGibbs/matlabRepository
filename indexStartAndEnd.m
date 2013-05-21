function [numind, numindend] = indexStartAndEnd(noTests, startTime, endTime, Time)
inda = ones(noTests,1);
indb = ones(noTests,1);
startPU = datestr(Time(1),'HH:MM:SS AM');

for kk = 1:noTests
    start1 = startTime(kk,:);
    end1 = endTime(kk,:);
    
    diffT(kk,:) = start1 - startPU;
    diffTend(kk,:) = end1 - startPU;
    
if diffT(kk, 1)~= 0
    hh(kk, :) = [0 1 diffT(kk,3:end)];
else 
    hh(kk,:) = diffT(kk,:);
end

if diffTend(kk, 1)~= 0
    hk(kk, :) = [0 1 diffTend(kk,3:end)];
else 
    hk(kk,:) = diffTend(kk,:);
end

    ind = [3600; 3600; 0; 600; 60; 0; 10; 1; 0; 0; 0];
    ff(kk) = 32*(hh(kk,:) * ind);
    gg(kk) = 32*(hk(kk,:) * ind);
    
    T1 = datestr(Time(ff(kk):ff(kk)+2000),'HH:MM:SS AM');
    T2 = datestr(Time(gg(kk):gg(kk)+2000),'HH:MM:SS AM');
    
    clear TF FT
    for jj = 1:length(T1)
        TF(jj) = isequal(T1(jj,:),start1);
        FT(jj) = isequal(T2(jj,:),end1);
    end
    aa = find(TF==1);
    bb = find(FT==1);
    inda(kk) = aa(1);
    indb(kk) = bb(1);
end

numind = inda+ff';
numindend = indb+gg';
return;
