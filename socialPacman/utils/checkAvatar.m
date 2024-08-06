function opt = checkAvatar(nX,nY,opt)

nX = min(max(round(nX),1),opt.screenWidth);
nY = min(max(round(nY),1),opt.screenHeight);

isOkay = checkLists(nX,nY,opt);

if isOkay
    opt.avatarX = nX(1);
    opt.avatarY = nY(1);
else
    sameX = checkLists(opt.avatarX,nY,opt);
    sameY = checkLists(nX,opt.avatarY,opt);
    
    if sameX, opt.avatarY = nY(1);
    elseif sameY, opt.avatarX = nX(1); 
    else,
        distField = (sqrt((opt.mapX-nX).^2+(opt.mapY-nY).^2));
        fieldWeight = (distField+(1-opt.playground)*1000);
        [nnY,nnX] = find(fieldWeight==min(fieldWeight(:)));
        opt.avatarX = nnX(1);
        opt.avatarY = nnY(1);
    end
    
end

end

function isOkay = checkLists(nX,nY,opt)

withinPlayground = opt.playground(nY,nX);
overlap = sqrt((opt.opponentX-nX)^2 + (opt.opponentY-nY)^2) < (opt.opponentSz + opt.avatarSz)/2;

isOkay = withinPlayground & ~overlap;

end

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