function [opt,data] = phaseDiscrete(opt,data)


opt = resetPosition(opt);

opt.opponentSpd = opt.opponentSpdStandard * (1+opt.itemBenefit*opt.choiceItem);

while ~opt.trialDone
    opt = movePrey(opt);
    opt = moveAvatar(opt);
    opt = moveOpponent(opt);
    [opt,data] = updateScreen(opt,data);
    [opt,data] = checkReward(opt,data);
    [opt,data] = decisionPoint(opt,data);
end
opt.opponentSpd = opt.opponentSpdStandard;
fprintf('trial %d (%.0f%%) \n', opt.trial, opt.drank/opt.trial*100);
data = refreshScreen(opt,data,30);


end