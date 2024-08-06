function [opt,data] = phase3(opt,data)


if ~opt.abortTrial
    opt.phase = 3;
    opt = resetPosition(opt);
    opt.phase3Bgn = GetSecs;
    while (GetSecs - opt.phase3Bgn < 1),
        [opt,data] = updateScreen(opt,data);
    end

    opt.friendlyness = opt.friendlyness3;

    opt.flashBoxOn = 1;
    opt.phase3Bgn = GetSecs;
    %opt.opponentSpd = opt.opponentSpdStandard * (1+opt.itemBenefit*opt.choiceItem);
    opt.opponentSpd = opt.opponentSpdStandard * (1+opt.itemBenefit((opt.choiceItem+3)/2));
    opt.proofBoundary = ((opt.opponentSz/2+opt.opponentSpd) + (opt.preySz/2 + opt.preySpd))*2;
    sentComment2BlackRock(opt)
    while ~opt.trialDone & ~opt.abortTrial
        opt = movePrey(opt);
        opt = moveAvatar(opt,data);
        opt = moveOpponent(opt);
        [opt,data] = updateScreen(opt,data);
        [opt,data] = checkReward(opt,data);
    end

    opt.timerSpentThisTrial = (GetSecs - opt.phase3Bgn);
    opt.timerSpent = opt.timerSpent + opt.timerSpentThisTrial;
    opt.totalSpent = opt.totalSpent + opt.timerSpentThisTrial;

    [opt,data] = feedback(opt,data);

    opt.opponentSpd = opt.opponentSpdStandard;

    notify(opt);
end
end

function notify(opt)

runningTime = GetSecs-opt.expBgn;
runningMin = floor(runningTime/60);
runningSec = round(mod(runningTime,60));

pursuitTime = opt.totalSpent;
pursuitMin = floor(pursuitTime/60);
pursuitSec = round(mod(pursuitTime,60));

%timeRatio = floor(opt.timerSpent/(opt.timerMax*60)*100);
fprintf(' / time total[%02d:%02d], pursuit[%02d:%02d] / money %d\n', runningMin, runningSec, pursuitMin, pursuitSec, opt.totalMoney);
end