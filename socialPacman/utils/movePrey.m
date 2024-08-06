function opt = movePrey(opt)

avat = [opt.avatarX;opt.avatarY];
prey = [opt.preyX;opt.preyY];
oppo = [opt.opponentX;opt.opponentY];

avatVector = prey-avat;
oppoVector = prey-oppo;
avn  = norm(avatVector);
ovn  = norm(oppoVector);

avatVector = avatVector/avn;
oppoVector = oppoVector/ovn;

if opt.opponentPresent,
    vector = avatVector/avn^2 + oppoVector/ovn^2*opt.strategyWeight;
    vector = vector/norm(vector);
else
    vector = avatVector;
end

costs = ones(opt.optionNum,2)*1e5;
nprey = zeros(2,opt.optionNum);
for s = 1:opt.optionNum,
    
    sVector = opt.optionRotMat{s}*vector * opt.preySpd * opt.preySpdWeight(round(min(avn,ovn)));
    nprey(:,s) = round(prey+sVector);
    
    if opt.opponentPresent,
        distCost = -sqrt(sum((nprey(:,s)-avat).^2)) + -sqrt(sum((nprey(:,s)-oppo).^2));
    else
        distCost = -sqrt(sum((nprey(:,s)-avat).^2));
    end
    
    if opt.playground(nprey(2,s),nprey(1,s)),
        costs(s,1) = distCost;
        costs(s,2) = opt.mapCost(nprey(2,s),nprey(1,s));
    end
end
costs = normalize(costs,'range').*[opt.weightDist,opt.weightMap];
[~,minIdx] = min(sum(costs,2));
nPreyPos = nprey(:,minIdx);

if ~sum(sum(nPreyPos==opt.preyTrace,1)==2),
    opt.preyTrace = [nPreyPos,opt.preyTrace(:,1:end-1)];
    opt.preyX = nPreyPos(1);
    opt.preyY = nPreyPos(2);
end
end

