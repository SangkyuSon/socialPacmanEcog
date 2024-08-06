function opt = moveAvatar(opt,data)

if ~opt.abortTrial

    % Joystick use
    if ~opt.debugMode,
        [joy_vec, ~] = JoyMEX(0);
        joy_vec = norm_joy(joy_vec);
    else
        joy_vec = [0,0];
    end
    isJoyMoved = (abs(joy_vec(1)) > opt.minInput) | (abs(joy_vec(2)) > opt.minInput);



    curWeight = opt.choiceWeight(max(min(round((1-abs(opt.friendlyness - (opt.choiceItem+1)/2))*1000),1000),1));
    addAvatarSpd = max(opt.preySpd-opt.avatarSpd,0) * curWeight;


    if isJoyMoved,
        currentJoy = joy_vec(1:2)' * (opt.avatarSpd + addAvatarSpd);
        opt.joyTrace = [currentJoy,opt.joyTrace(:,1:end-1)];

        nX = opt.avatarX + opt.joyTrace(1,1);
        nY = opt.avatarY + opt.joyTrace(2,1);

        if opt.phase~=2, opt = checkAvatar(nX,nY,opt);
        else, opt.avatarX = nX; opt.avatarY = nY;  end
    end
end

end
