function opt = resetPosition(opt)

% avatar
[opt.avatarX,opt.avatarY] = randomSelection(opt,opt.playground);
avatarMap = (sqrt((opt.mapX-opt.avatarX).^2+(opt.mapY-opt.avatarY).^2) < opt.choiceBoundDist/2*1.3);

% prey
distMap = sqrt((opt.mapX-opt.avatarX).^2+(opt.mapY-opt.avatarY).^2);
posDistMap = (distMap >= opt.preyInitialDist(1)) & (distMap <= opt.preyInitialDist(2));
cannotEnter = opt.playground & posDistMap;
[opt.preyX,opt.preyY] = randomSelection(opt,cannotEnter);

% opponent
prey2avat = sqrt((opt.preyX-opt.avatarX)^2 + (opt.preyY-opt.avatarY)^2);
cannotEnter = (abs(sqrt((opt.mapX-opt.preyX).^2 + (opt.mapY-opt.preyY).^2) - prey2avat) < 1) & opt.playground & ~avatarMap ;
[opt.opponentX,opt.opponentY] = randomSelection(opt,cannotEnter);

end

function [x,y] = randomSelection(opt,boundary)

[posy,posx] = find(boundary);
selPos = randperm(length(posy),1);
x = posx(selPos);
y = posy(selPos);

end
