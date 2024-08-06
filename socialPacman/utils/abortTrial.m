function [opt,data] = abortTrial(opt,data)


if ~opt.debugMode
    [joy_vec, ~] = JoyMEX(0);
    joy_vec = norm_joy(joy_vec);
else
    joy_vec = [0,0];
end

isJoyMoved = (abs(joy_vec(1)) > opt.minInput) | (abs(joy_vec(2)) > opt.minInput);

if ~isJoyMoved
    opt.abortTrial = 0;
else
    opt.abortTrial = 1;
    bgn = GetSecs;
    while (GetSecs - bgn < 1),
        [opt,data] = updateScreen(opt,data,[0,0,0]);
    end
end


end