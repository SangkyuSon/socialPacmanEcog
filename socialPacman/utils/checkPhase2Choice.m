function opt = checkPhase2Choice(opt)

dist = sqrt((opt.avatarX-opt.choiceRingX)^2+(opt.avatarY-opt.choiceRingY)^2);
if dist > opt.choiceBoundDist/2 - opt.choiceBoundWidth - opt.avatarSz/2,
    opt.choiceItem = sign(mod(atan2d(opt.avatarY-opt.choiceRingY,opt.avatarX-opt.choiceRingX)-opt.choiceRingAng+90,360)-180); % -1 for red / +1 for blue
    opt.phase2 = 1;
end

end