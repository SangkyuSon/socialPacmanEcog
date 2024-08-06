function [opt,data] = collectData(opt,data)

data.avatar(opt.timeCounter,1) = opt.avatarX;
data.avatar(opt.timeCounter,2) = opt.avatarY;

data.prey(opt.timeCounter,1) = opt.preyX;
data.prey(opt.timeCounter,2) = opt.preyY;

data.opponent(opt.timeCounter,1) = opt.opponentX;
data.opponent(opt.timeCounter,2) = opt.opponentY;

data.phase(opt.timeCounter) = opt.phase;

if opt.timeCounter == 1,
    data.info.subject = opt.subName;
    data.info.trial = opt.trial;
    data.info.date = date;
    data.info.passiveLength = opt.passiveLength;
    data.friendlyness = opt.friendlyness;
    data.friendlynessPursuit = opt.friendlyness3;
    data.block = opt.block;

    data.spd.avatar = opt.avatarSpd;
    data.spd.opponent = opt.opponentSpd;
    data.spd.prey = opt.preySpd;
end

data.rewarded = opt.rewarded;
data.earnedMoney = opt.currentMoney;
data.choiceItem = opt.choiceItem;
data.info.totalSpent = opt.totalSpent;

end