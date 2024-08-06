function [opt,data] = checkReward(opt,data,addBoundary)
if nargin < 3, addBoundary = 0; end

avat2preyDist = sqrt((opt.avatarX-opt.preyX)^2+(opt.avatarY-opt.preyY)^2);
isAvatar = avat2preyDist < (opt.avatarSz/2 + opt.preySz/2 + addBoundary);
if opt.opponentPresent, isOpponent = sqrt((opt.opponentX-opt.preyX)^2+(opt.opponentY-opt.preyY)^2) < (opt.opponentSz/2 + opt.preySz/2 + addBoundary); else isOpponent = 0; end
if opt.phase == 3,  isTimer = (GetSecs - opt.phase3Bgn > opt.timerTrial); else isTimer = 0; end

opt.rewarded = max(isAvatar,opt.rewardWeight(max(min(round(opt.friendlyness*1000),1000),1)));
opt.trialDone = isAvatar | isOpponent | isTimer;
opt.isAvatar = isAvatar;
opt.isTimer = isTimer;
opt.a2pDist = avat2preyDist;

end
