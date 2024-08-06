function rewardONOFF(opt,val)
% val = 0 :: solenoid off
% val = 1 :: solenoid on

if opt.whichMonkey==1,     % Willy
    write(opt.dq, val);
elseif opt.whichMonkey==2, % Soju
    writeDigitalPin(opt.dq,'D2',val);
end

end