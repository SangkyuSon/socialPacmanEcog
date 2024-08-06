function opt = reward(opt)

if opt.rewarded,
    write(opt.dq, 1)
    
    bgn = GetSecs;
    while(GetSecs - bgn <= opt.rewardDuration)
    end
    
    write(opt.dq, 0)
    
    opt.drank = opt.drank + opt.rewardDuration* opt.waterRatio;
end
end

