function [isOkay,nX,nY] = checkOpponent(noppo,opt)
nX = min(max(round(noppo(1,:)),1),opt.screenWidth);
nY = min(max(round(noppo(2,:)),1),opt.screenHeight);

for s = 1:opt.optionNum,
    isOkay(s) = checkLists(nX(s),nY(s),opt);
end

end
function isOkay = checkLists(nX,nY,opt)

withinPlayground = opt.playground(nY,nX);
overlap = sqrt((opt.avatarX-nX)^2 + (opt.avatarY-nY)^2) < (opt.opponentSz + opt.avatarSz)/2;

isOkay = withinPlayground & ~overlap;

end

% function opt = checkOpponent(nX,nY,opt)
% 
% nX = min(max(round(nX),1),opt.screenWidth);
% nY = min(max(round(nY),1),opt.screenHeight);
% 
% isOkay = checkLists(nX,nY,opt);
% 
% if isOkay
%     opt.opponentX = nX(1);
%     opt.opponentY = nY(1);
% else
%     sameX = checkLists(opt.opponentX,nY,opt);
%     sameY = checkLists(nX,opt.opponentY,opt);
%     
%     if sameX,     opt.opponentX = nX(1);
%     elseif sameY, opt.opponentY = nY(1); end
%     
% end
% 
% end

% cannotEnter = opt.playground & ~(sqrt((opt.mapX-opt.opponentX).^2+(opt.mapY-opt.opponentY).^2) < opt.opponentSz*1.1);
% 
% dist = sqrt((opt.mapX-nX).^2+(opt.mapY-nY).^2);
% dist = dist+(1-cannotEnter)*1e3;
% spot = dist==min(dist(:));
% nX = find(sum(spot,1));
% nY = find(sum(spot,2));
% 
% opt.avatarX = nX(1);
% opt.avatarY = nY(1);

% function [isokay,opt] = checkOpponent(nX,nY,opt)
% 
% cannotEnter = opt.playground & ~(sqrt((opt.mapX-opt.avatarX).^2+(opt.mapY-opt.avatarY).^2) < opt.avatarSz*1.1);
% 
% nX = max(min(nX,opt.screenWidth),1);
% nY = max(min(nY,opt.screenHeight),1);
% 
% isokay = cannotEnter(nY,nX);
% if isokay,
%     opt.opponentX = nX;
%     opt.opponentY = nY;
% end
% 
% end
