function data = refreshScreen(opt,data,frameNo)
if nargin < 3, duration = 10*1/opt.screenFlipHz-0.001;
else,          duration = frameNo*1/opt.screenFlipHz-0.001; end

stateSave = [opt.choiceRingPresent, opt.avatarPresent, opt.preyPresent, opt.opponentPresent, opt.phase];

opt.choiceRingPresent = 0;
opt.avatarPresent = 0;
opt.preyPresent = 0;
opt.opponentPresent = 0;
opt.phase = 0;

bgn = GetSecs; 
while (GetSecs - bgn < duration),  [opt,data] = updateScreen(opt,data); end

opt.choiceRingPresent = stateSave(1);
opt.avatarPresent = stateSave(2);
opt.preyPresent = stateSave(3);
opt.opponentPresent = stateSave(4);
opt.phase = stateSave(4);

[opt,data] = updateScreen(opt,data);

end