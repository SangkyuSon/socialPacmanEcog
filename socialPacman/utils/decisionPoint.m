function [opt,data] = decisionPoint(opt,data)

if ~opt.trialDone,
    
    if (GetSecs - opt.preBgn) < opt.preLength,
        opt.phase = 1;
        opt.choiceRingPresent = 0;
        opt.choiceRingX = opt.avatarX;
        opt.choiceRingY = opt.avatarY;
        opt.isJoyMoved = 1;
    else,
        if opt.isJoyMoved,
            opt.phase = 2;
            opt.choiceRingPresent = 1;
            opt.opponentPresent = 0;
            opt.preyPresent = 0;
            
            [joy_vec, ~] = JoyMEX(0);
            joy_vec = norm_joy(joy_vec);
            opt.isJoyMoved = (abs(joy_vec(1)) > opt.minInput) | (abs(joy_vec(2)) > opt.minInput);
        else
            opt.phase = 3;
            opt = checkPhase2Choice(opt);
            
            if opt.phase==1,
                opt.preBgn = GetSecs;
                opt.preLength = opt.phase1(1) + rand*diff(opt.phase1,[],2);
                %opt.opponentSpd = max(opt.opponentSpd + (opt.opponentSpdStandard * opt.itemBenefit*opt.choiceItem),0);
                opt.opponentSpd = opt.opponentSpdStandard * (1 + opt.itemBenefit*opt.choiceItem);
                opt.avatarX = opt.choiceRingX;
                opt.avatarY = opt.choiceRingY;
                opt.choiceRingAng = randperm(360,1);
                opt.choiceRingPresent = 0;
                opt.opponentPresent = 1;
                opt.preyPresent = 1;
            end
        end
    end
end
end