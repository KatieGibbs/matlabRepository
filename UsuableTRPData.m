%% Upload Blood Flow Data

clear all;clc; close all;

%% 1.	Enter subject specific information, possibly as a read only textfile.

pathname = 'C:\Documents and Settings\Jason.VA-SCHOEN\My Documents\My Dropbox\VA\4. Perception Tests\5. Testing\1. Intact Controls\TRPC20';
pathForFunctions = 'C:\Documents and Settings\Jason.VA-SCHOEN\My Documents\GitHub\matlabRepository';
subNo = 20;    noTests = 8;

%% 2.	Upload blood flow data: use xlsread().

cd(pathname);       subName = sprintf('TRPC%d', subNo);
[num txt raw] = xlsread(sprintf('%s_BF.xls', subName));

cd(pathForFunctions)
[Time, BF, endBF] = BFandTime(num);

%% 3.	Upload setpoint data to find start and end time (unique function named: startAndEndTimes.m).

cd(pathForFunctions)
[startTime, endTime, tempData] = startAndEndTimes(subName, noTests, pathname);

%% 4.	Match the initial and final time with the blood flow time data and determine correct indices 
%for the start and end of the blood flow (unique function named: indexStartAndEnd.m).

startPU = datestr(Time(1),'HH:MM:SS AM');   noStartPU = datenum(startPU);

noStartTime = datenum(startTime);       noEndTime = datenum(endTime);
dStartPU = noStartTime - noStartPU;     dEndPU = noEndTime - noStartPU;

dSPU = datestr(dStartPU,'HH:MM:SS AM'); dEPU = datestr(dEndPU,'HH:MM:SS AM');

dSPU_H = str2num(dSPU(:,1:2));   dSPU_M = str2num(dSPU(:,4:5));    dSPU_S = str2num(dSPU(:,7:8));
a = find(dSPU_H==12); dSPU_H(a) = 0;


timeDifference = 32*(3600*dSPU_H+60*dSPU_M + dSPU_S);
%%
cd(pathForFunctions)
[noInd, noIndEnd] = indexStartAndEnd(noTests, startTime, endTime, Time);

%% 5.	Calculate min, mean, and max of the initial blood flow measured within the first minute of testing.

MinMeanMax = [min(BF(noInd(1):noInd(1)+(32*60))); mean(BF(noInd(1):noInd(1)+(32*30))); max(BF(noInd(1):noInd(1)+(32*30)))];   
tenpercMinMeanMax = 0.1*MinMeanMax;

%% 6.	Determine the mean initial blood flow of each test.

for ii = 1:noTests
    meanAllBF(ii) = mean(BF(noInd(ii):noInd(ii)+(32*30)));
end

%% 7.	Determine which test is useable (falls within the min and max bounds) or possibly useable (falls within 10% of the min and max bounds).  

for ii = 1:noTests
    if meanAllBF(ii) >= MinMeanMax(1) && meanAllBF(ii) < MinMeanMax(3)
        c(ii) = 1;
    elseif meanAllBF(ii) >= MinMeanMax(1)-tenpercMinMeanMax(1) || meanAllBF(ii) < MinMeanMax(3) + tenpercMinMeanMax(3)
        c(ii) = 0.5;
    else
        c(ii) = 0;
    end
end

d = find(c==1);     e = find(c==0.5);

%% 8.	Create a plot which displays in darker color the useable blood flow data for each test.

figure
t = (1/(32*60))*(1:length(BF));
plot(t,BF, 'c'); hold on;
for jj = 1:length(d)
    usethis = d(jj);
    t1 = (noInd(usethis):noIndEnd(usethis));
    plot((t1/(32*60)),BF(t1),'k:')
end

for jj = 1:length(e)
    usethis = e(jj);
    t1 = (noInd(usethis):noIndEnd(usethis));
    plot((t1/(32*60)),BF(t1),'b--')
end

axis([noInd(1)/(32*60) noIndEnd(end)/(32*60) 0 120])
xlabel('Time (Minutes)','FontSize',16)
ylabel('Blood Perfusion (PU)','FontSize',16)
set(gca,'FontSize',15)
title(sprintf('Useable Blood Perfusion Data for %s',subName),'FontSize',18);

%% 9.	Create a matrix with 0 for not useable, 0.5 for possibly useable, and 1 for useable data next to the trial number.

tests = 1:noTests;
UseableData = [tests', c']