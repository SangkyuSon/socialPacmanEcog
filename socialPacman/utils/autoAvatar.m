function opt = autoAvatar(opt,data)

if ~opt.abortTrial
    avat = [opt.avatarX;opt.avatarY];
    
    
    addPreyPos = mean(-diff(opt.preyTrace(:,1:5),[],2),2)*0.5/opt.screenFlipTime;
    addPreyPos(isnan(addPreyPos)) = 0;
    %addPreyPos = mean(diff(data.prey(end-5:end,:),[],1),1)'*0.75/opt.screenFlipTime;
    prey = [opt.preyX;opt.preyY] + addPreyPos;
    
    avatVector = prey-avat;
    avn  = norm(avatVector);
    avatVector = avatVector./avn;

    currentJoy = avatVector * opt.avatarSpd;
    
    opt.joyTrace = [currentJoy,opt.joyTrace(:,1:end-1)];
        
    nX = opt.avatarX + currentJoy(1);
    nY = opt.avatarY + currentJoy(2);
    
    opt = checkAvatar(nX,nY,opt);
    
end


end
