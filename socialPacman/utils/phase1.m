function [opt,data] = phase1(opt,data)
% phase 1 : passive viewing
opt.phase = 1;
bgn = GetSecs;
duration = opt.phase1(1) + rand*diff(opt.phase1,[],2);

phase1bgn = GetSecs;
opt.flashBoxOn = 1;

sentComment2BlackRock(opt)
while (GetSecs-bgn < duration) & ~opt.abortTrial & ~opt.trialDone,
    
    opt = movePrey(opt);    
    opt = autoAvatar(opt,data);
    opt = moveOpponent(opt);
    
    [opt,data] = checkReward(opt,data,100);  
    [opt,data] = abortTrial(opt,data);
    [opt,data] = updateScreen(opt,data);
    
end
opt.passiveLength = GetSecs-phase1bgn;

opt.trialDone = 0;
opt.rewarded = 0;

data = refreshScreen(opt,data);

end