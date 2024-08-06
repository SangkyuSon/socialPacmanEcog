function [opt,idx] = playgroundOffset(opt,offset)
if nargin < 2, offset = 0; end

idx = zeros(opt.screenHeight,opt.screenWidth);
cenSz = opt.circularity*opt.screenHeight/2-offset;
if cenSz <= offset, return; end
for i = 1:4,
    if i == 1,    cenPos = [cenSz+offset,cenSz+offset];
    elseif i == 2,cenPos = [cenSz+offset,opt.screenHeight-cenSz-offset];
    elseif i == 3,cenPos = [opt.screenWidth-cenSz-offset,cenSz+offset];
    elseif i == 4,cenPos = [opt.screenWidth-cenSz-offset,opt.screenHeight-cenSz-offset];
    end
    idx = idx | (sqrt((opt.mapX-cenPos(1)).^2+(opt.mapY-cenPos(2)).^2) < cenSz);
end

idx(cenSz+offset:(opt.screenHeight-cenSz-offset),offset+1:opt.screenWidth-offset) = 1;
idx(offset+1:opt.screenHeight-offset,cenSz+offset:(opt.screenWidth-cenSz-offset)) = 1;

end