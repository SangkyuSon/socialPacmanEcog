function opt = specialCase(opt)

[keyIsDown, ~, keyCode] = KbCheck;
if keyIsDown
    
    if keyCode(KbName('Escape'))
        opt.expDone = 1;
        opt.trialDone = 1;
        sca;
        clear JoyMEX;
        TaskComment('kill',opt.EMUfname);
    elseif keyCode(KbName('UpArrow'))   % up
        nY = opt.avatarY - opt.avatarSpd*2;
        nX = opt.avatarX;
        opt = checkAvatar(nX,nY,opt);
    elseif keyCode(KbName('DownArrow')) % down
        nY = opt.avatarY + opt.avatarSpd*2;
        nX = opt.avatarX;
        opt = checkAvatar(nX,nY,opt);
    elseif keyCode(KbName('LeftArrow')) % left
        nX = opt.avatarX - opt.avatarSpd*2;
        nY = opt.avatarY;
        opt = checkAvatar(nX,nY,opt);
    elseif keyCode(KbName('RightArrow'))% right
        nX = opt.avatarX + opt.avatarSpd*2;
        nY = opt.avatarY;
        opt = checkAvatar(nX,nY,opt);       
    elseif keyCode(KbName('p')) % pause (p):: press 'r' to resume
        pause = 1;
        while pause,
            [keyIsDown, ~, keyCode] = KbCheck;
            if keyCode(KbName('r')),
                pause = 0;
                opt.abortTrial = 1;
            end
        end
    elseif (keyCode(KbName('h')) | keyCode(KbName('e')) | keyCode(KbName('o'))) % make it easier or harder

        opt.abortTrial = 1; % restart after resetting the parameter
        if keyCode(KbName('h')), % make it harder
            opt.preySpd = opt.preySpd + opt.chractorSpdSv(2)*0.1;
            opt.opponentSpdStandard = opt.opponentSpdStandard + opt.chractorSpdSv(3)*0.1;
            
        elseif keyCode(KbName('e')), % make it easier

            opt.preySpd = opt.preySpd - opt.chractorSpdSv(2)*0.1;
            opt.opponentSpdStandard = opt.opponentSpdStandard - opt.chractorSpdSv(3)*0.1;

        elseif keyCode(KbName('o')), % restore to original
            opt.avatarSpd = opt.chractorSpdSv(1);
            opt.preySpd = opt.chractorSpdSv(2);
            opt.opponentSpd = opt.chractorSpdSv(3); 
        end

    end
end

end