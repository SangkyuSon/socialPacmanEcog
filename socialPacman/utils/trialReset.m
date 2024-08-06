function [opt,data] = trialReset(opt)

if ~opt.abortTrial, 
    
%     opt.blockCnt = opt.blockCnt + 1;
%     
%     if opt.blockCnt > opt.blockLen,
%         opt.blockLen = max(round(opt.blockLenMu + randn*opt.blockLenMu/5),1);
%         cblockPool = setdiff(opt.blockPool,opt.block);
%         opt.block = cblockPool(randperm(length(cblockPool),1));
%         opt.blockCnt = 1;
%     end
    
    %opt = resetPosition(opt);
    %opt.friendlyness = rand;
    %opt.friendlyness3 = max(min(opt.friendlyness + sign(opt.block-1.5) * (rand*range(opt.friendlinessChg)+opt.friendlinessChg(1)),1),0);

    opt.avatarX = opt.predefined.avat(opt.trial,1);
    opt.avatarY = opt.predefined.avat(opt.trial,2);
    opt.preyX = opt.predefined.prey(opt.trial,1);
    opt.preyY = opt.predefined.prey(opt.trial,2);
    opt.opponentX = opt.predefined.oppo(opt.trial,1);
    opt.opponentY = opt.predefined.oppo(opt.trial,2);

    opt.friendlyness = opt.predefined.friendliness(opt.trial);
    opt.friendlyness3 = opt.predefined.friendlinessP(opt.trial);
    opt.block = opt.predefined.block(opt.trial);
    %opt.friendlyness3 = min(max(opt.friendlyness-0.4,0),1);
    %opt.block = 1;
        
    if opt.trainingMode, opt.friendlyness3 = opt.friendlyness; end
    
    fprintf('trial %d / friend %.1f->%.1f(%d)',opt.trial,  opt.friendlyness, opt.friendlyness3,opt.block);
    opt.initPos.avatar = [opt.avatarX,opt.avatarY];
    opt.initPos.prey = [opt.preyX,opt.preyY];
    opt.initPos.opponent = [opt.opponentX,opt.opponentY];

else 

    % if the previous trial was aborted restart everything
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
