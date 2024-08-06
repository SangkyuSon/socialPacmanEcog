function [opt,data] = trialReset2(opt)

if ~opt.abortTrial, 
    
    opt.blockCnt = opt.blockCnt + 1;
    
    if opt.blockCnt > opt.blockLen,
        cblockPool = setdiff(opt.blockPool,opt.block);
        opt.block = cblockPool(randperm(length(cblockPool),1));
        opt.blockCnt = 1;
    end
    
    opt.friendlinessChg = sign(opt.block-1.5) * opt.blockRatio * opt.blockCnt + -sign(opt.block-1.5) * opt.friendlinessChgMax;
    
    opt.friendlyness = rand;
    opt.friendlyness3 = max(min(opt.friendlyness + opt.friendlinessChg,1),0);
    
    opt = resetPosition(opt);
    
    if opt.trainingMode, opt.friendlyness3 = opt.friendlyness; end
    
    fprintf('trial %d / friend %.2f->%.2f(%d)',opt.trial,  opt.friendlyness, opt.friendlyness3,opt.block);
    opt.initPos.avatar = [opt.avatarX,opt.avatarY];
    opt.initPos.prey = [opt.preyX,opt.preyY];
    opt.initPos.opponent = [opt.opponentX,opt.opponentY];
else
    opt.avatarX = opt.initPos.avatar(1);
    opt.avatarY = opt.initPos.avatar(2);
    
    opt.preyX = opt.initPos.prey(1);
    opt.preyY = opt.initPos.prey(2);
    
    opt.opponentX = opt.initPos.opponent(1);
    opt.opponentY = opt.initPos.opponent(2);
    
    fprintf('.')
end
opt.choiceRingAng = randperm(360,1);


opt.abortTrial = 0;
opt.rewarded = 0;
opt.trialDone = 0;
opt.expDone = 0;
opt.phase2 = 0;
opt.phase = 0;
opt.joyTrace = zeros(2,5);
opt.preyTrace = nan(2,10);
opt.oppoTrace = zeros(2,10);
opt.isJoyMoved = 1;

opt.preLength = opt.phase1(1) + rand*diff(opt.phase1,[],2);
opt.opponentSpd = opt.opponentSpdStandard;
opt.proofBoundary = ((opt.opponentSz/2+opt.opponentSpd) + (opt.preySz/2 + opt.preySpd))*1.1;
data = [];

opt.trialBgn = GetSecs;
opt.frameBgn = GetSecs;
opt.preBgn = GetSecs;
while (GetSecs - opt.trialBgn < opt.initialFreeze), 
    [opt,data] = updateScreen(opt,data);
end

opt.frameBgn = GetSecs;
opt.trialBgn = GetSecs;
opt.preBgn = GetSecs;

opt.timeCounter = 0;


end

function opt = randomWalkFriendlyness(opt,rangeVal)
fpool = opt.lastFriendlyness + randn(1,10000)/3*opt.friendlynessRandomWalk;
fpool(fpool < rangeVal(1) | fpool > rangeVal(2)) = [];
opt.friendlyness = fpool(randperm(length(fpool),1));
end
