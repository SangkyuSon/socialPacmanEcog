function opt = moveOpponent(opt)

if opt.opponentPresent
    % distance version
    %if opt.timeCounter > 10, addAvatPos = nanmean(opt.joyTrace,2); else addAvatPos = [0;0]; end
    addAvatPos = [0;0];
    avat = [opt.avatarX;opt.avatarY] + addAvatPos;
    prey = [opt.preyX;opt.preyY];
    oppo = [opt.opponentX;opt.opponentY];
    
    avatVector = prey-avat;
    avn  = norm(avatVector);
    avatVector = avatVector/avn;

    noppo = zeros(2,opt.optionNum);
    for s = 1:opt.optionNum,
        weightIdx = round(norm(prey-oppo));
        noppo(:,s) = oppo + opt.optionRotMat{s}*[0;opt.opponentSpd * opt.opponentSpdWeight(weightIdx)];
    end
    
    [isOkay,nX,nY] = checkOpponent(noppo,opt);
     
    oppoVector = prey - noppo;
    ovn  = vecnorm(oppoVector);
    oppoVector = oppoVector./ovn;
    
    vector = avatVector/avn^2 + oppoVector./ovn.^2*opt.strategyWeight;
    vector = vector./vecnorm(vector);
    
    svector = vector * opt.preySpd * opt.preySpdWeight(floor(min([avn,ovn])));
    
    prey2avatDist = sqrt(sum([prey+svector-avat].^2,1));
    prey2oppoDist = sqrt(sum([prey+svector-noppo].^2,1));
    %prey2oppoDist = sqrt(sum([prey-noppo].^2,1));
    
    proofCrit = max(1 - prey2oppoDist/(opt.proofBoundary),0);
    proofCrit = normalize(proofCrit,'range') * (opt.friendlyness-0.5)*2;
    
    prey2avatDist = normalize(prey2avatDist,'range');
    prey2oppoDist = normalize(prey2oppoDist,'range');
    
    distCrit = prey2oppoDist * (1-opt.friendlyness) + prey2avatDist * opt.friendlyness;
    
    crit = proofCrit + distCrit;
    
    [~,minIdx] = min(crit + (isOkay==0)*1e3);
    
    nOppoPos = [nX(minIdx(1)); nY(minIdx(1))];
    if ~sum(sum(nOppoPos==opt.oppoTrace,1)==2),
        opt.oppoTrace = [nOppoPos,opt.oppoTrace(:,1:end-1)];
        opt.opponentX = nOppoPos(1);
        opt.opponentY = nOppoPos(2);
    end

end
end




    
%     avat = [opt.avatarX;opt.avatarY] + mean(opt.joyTrace,2);
%     prey = [opt.preyX;opt.preyY];
%     %oppo = [opt.opponentX;opt.opponentY];
% 
%     avatVector = prey-avat;
%     avn  = norm(avatVector);
%     avatVector = avatVector/avn;
% 
%     
%     end4 = (GetSecs-bgn4)*1000;
%     bgn5 = GetSecs;
%     
%     
%     cannotEnter = opt.playground & ~(sqrt((opt.mapX-opt.avatarX).^2+(opt.mapY-opt.avatarY).^2) < opt.avatarSz*1.1);
%     possiblePos = (sqrt((opt.mapX-opt.opponentX).^2+(opt.mapY-opt.opponentY).^2) < opt.opponentSpd) & cannotEnter;
%     [posy,posx] = find(possiblePos);
%     
%     oppoVector = prey - [posx,posy]';
%     ovn  = vecnorm(oppoVector);
%     oppoVector = oppoVector./ovn;
%     
%     vector = avatVector./avn.^2 + oppoVector./ovn.^2;
%     vector = vector./vecnorm(vector);
%     
%     svector = vector * opt.preySpd * opt.preySpdWeight(floor(min([avn,ovn])));
%     
%     prey2avatDist = sqrt(sum([prey+svector-avat].^2,1));
%     %prey2oppoDist = sqrt(sum([prey+svector-[posx,posy]'].^2,1));
%     prey2oppoDist = sqrt(sum([prey-[posx,posy]'].^2,1));
%     
%     prey2avatDist = normalize(prey2avatDist,'range');
%     prey2oppoDist = normalize(prey2oppoDist,'range');
%     
%     
%     crit = prey2oppoDist * (0.7-opt.friendlyness) + prey2avatDist * opt.friendlyness;
%     
%     [~,minIdx] = min(crit);
%     opt.opponentY = posy(minIdx(1));
%     opt.opponentX = posx(minIdx(1));


