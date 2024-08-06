function calibrateWater


dq  = daq("ni");
addoutput(dq,"Dev2", "port0/line7", "Digital"); % Check device, port, line number
write(dq, 0);

loopNo = 30;
for i = 1:loopNo

    duration = 2;

    write(dq, 1)
    bgn = GetSecs;
    while(GetSecs - bgn <= duration); end

    write(dq, 0)
    bgn = GetSecs;
    while(GetSecs - bgn <= 1); end

end

fprintf('total duration : %.3f',duration*loopNo)

end