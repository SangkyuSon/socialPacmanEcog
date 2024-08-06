function [opt,data] = feedback(opt,data)

opt.currentMoney = round((opt.timerTrial-opt.timerSpentThisTrial) * opt.rewarded);


opt.totalMoney = opt.totalMoney + opt.currentMoney;
%opt.expectMoney = round(opt.totalMoney *(60*60)/(opt.totalSpent*5));
curScore = min(round(opt.currentMoney/((opt.timerTrial-3))*100),100);
if opt.isTimer,
    curScore = round(min(1-opt.a2pDist/opt.screenWidth,1)*100);
end

avgScore = min(round(opt.totalMoney/((opt.timerTrial-3)*opt.trial)*100),100);

opt.rewardText = sprintf('Score\nCurrent: %d/100 \nAverage: %d/100',curScore,avgScore);

opt.rewardPresent = 1;
if opt.isAvatar,
    bgn = GetSecs;
    while (GetSecs - bgn < 1.3),
        [opt,data] = updateScreen(opt,data,opt.rewardCol);
    end
else
    bgn = GetSecs;
    while (GetSecs - bgn < 1.3),
        [opt,data] = updateScreen(opt,data,opt.notRewardCol);
    end
end
opt.rewardPresent = 0;

end