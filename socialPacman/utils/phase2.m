function [opt,data] = phase2(opt,data)
% phase 2 : item choice

opt.phase = 2;

opt.choiceRingX = opt.avatarX;
opt.choiceRingY = opt.avatarY;

opt.choiceRingPresent = 1;
opt.flashBoxOn = 1;

sentComment2BlackRock(opt)
while ~opt.phase2 & ~opt.abortTrial
    opt = moveAvatar(opt,data);
    [opt,data] = updateScreen(opt,data);
    opt = checkPhase2Choice(opt);
end

opt.choiceRingPresent = 0;
opt.avatarX = opt.choiceRingX;
opt.avatarY = opt.choiceRingY;

data = refreshScreen(opt,data);
fprintf('/ choice %.0f',(opt.choiceItem+1)/2);

end