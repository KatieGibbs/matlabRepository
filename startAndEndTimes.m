function [startTime, endTime, tempData] = startAndEndTimes(subnm, noTests, pathname)
cd(pathname)
tempData = [];
for kk = 1:noTests
    filename = sprintf('%s.test%dsp.txt',subnm,kk);
    [a{kk} b c{kk}] = textread(filename,'%s %s %f');
    startt(kk) = a{kk}(1);
    endt(kk) = a{kk}(end);
    
    tempData = [tempData, c{kk}(1), c{kk}(end)];
end
filename = sprintf('%s.maxbfsp.txt', subnm);
[a{9} b c{9}] = textread(filename,'%s %s %f'); 
 
startTime = datestr(startt,'HH:MM:SS AM');
endTime = datestr(endt, 'HH:MM:SS AM');

return;