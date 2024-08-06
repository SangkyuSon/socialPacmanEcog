function opt = initiate_train()

opt = [];
opt.rewardRatio = 6;               % won, reward rate per second

opt.initialFreeze = 1;             % sec, duration of initial freeze after re-positioning
opt.phase1        = [3,4];         % sec, [min, max] duration of phase1 (passive viewing)

opt.monitorSize = 60.4;            % cm,  size of monitor
opt.viewingDistance = 53;          % cm,  viewing distance

opt.timerMax = 25;                 % min, total time of phase3 (foraging) per day

opt.timerTrial = 15;               % sec, maximum time per trial

opt.itemBenefit = [-0.2,0.3];      % + or - of opponent speed (e.g. "+0.5" means 50% increase)
opt.weightDist = 0.6;             % weight of prey's "distance" cost function 
                                   % e.g. "0.5" means equal weight for 
                                   %       (1) "distance" cost function (run away from opponent and avatar)
                                   %       (2) "map" cost function (stay away from the boundary)

opt.strategyWeight = 3;            % weight of prey's strategy ( values over 1 means valuing more on running away from oppoent )
                                   % The higher value make more shepherding movements.
                                   
opt.friendlinessChg = [0.15,0.3]; 
opt.screenNumber = 1;              % change accodingly 
opt.blockLenMu = 20;                           

opt = basicConfig(opt);
opt = makeCharacters(opt);
opt = makeScreenComponents(opt);

opt.rewardRatio = opt.rewardRatio + opt.dayIdx;
opt.expBgn = GetSecs;

end
%%


function opt = makeCharacters(opt)

opt.rewardWeight = sigmf(linspace(-8,8,1000),[1,0])*0.5;
opt.choiceWeight = sigmf(linspace(-8,8,1000),[1,0]);

% avatar
opt.avatarPresent = 1;
opt.avatarSz = 1.5*opt.pixelPerDeg;
opt.avatarSpd = 10/opt.screenFlipHz*opt.pixelPerDeg;
opt.avatarCol = [0,0.7,0]*255;

% prey
opt.preyPresent = 1;
opt.preySz = opt.avatarSz;
opt.preySpd = opt.avatarSpd * 1;
opt.preySpdWeight = fliplr(sigmf(linspace(-6,9,opt.screenWidth),[1.5 6]));
opt.preyCol = [0,0,1]*255;
opt.preyInitialDist = [20,20.5]*opt.pixelPerDeg;

% opponent
opt.opponentPresent = 1;
opt.opponentSz = opt.avatarSz;
opt.opponentSpdStandard = opt.avatarSpd * 1.1;
opt.opponentSpd = opt.opponentSpdStandard;
opt.opponentSpdWeight = sigmf(linspace(2,11,opt.screenWidth),[1 6])+1;
opt.opponentCol = [1,0,0]*255;

opt.friendlynessMin = 0;
opt.friendlynessRandomWalk = 0.3;

end



function opt = basicConfig(opt)

rng('shuffle'); warning off;

% subject info
opt.subName = [];
opt.trainingMode = isempty(opt.subName);
opt.dataDir = fullfile(pwd,'data',opt.subName);
opt.trial = max(length(dir(opt.dataDir))-2,1);

% initial variables
opt.expDone = 0;
opt.timeCounter = 0;
opt.abortTrial = 0;
opt.passiveLength = 0;
opt.choiceItem    = 0;
opt.phase2        = 0;
opt.totalMoney = 0;
opt.currentMoney = 0;
opt = countRewarded(opt);
opt.rewardPresent = 0;
opt.blockPool = [1,2]; % 1=betray / 2=over-helped
opt.blockCnt = 0;
opt.blockLen = max(round(opt.blockLenMu + randn*opt.blockLenMu/5),1);
opt.block = opt.blockPool(randperm(length(opt.blockPool),1));


% minimal control
opt.minInput = 0.05;
opt.rewardCol = [0,1,0]*255;
opt.notRewardCol = [1,0,0]*255;

% eyelink
try,
    opt.useEyelink = ~opt.trainingMode;
    eyelinkPrep(opt)
    try,opt.eyelinkPresent = Eyelink('IsConnected'); catch, opt.eyelinkPresent = 0; end
    if opt.eyelinkPresent,
        opt.eyeSide = Eyelink('EyeAvailable')+1;
    end
catch,
    opt.useEyelink = 0;
    opt.eyelinkPresent = 0;
    opt.eyeSide = 1;
end
opt.eyePresent = 0;

% Joystick
clear JOYMEX
JoyMEX('init',0);

% screen variables
Screen('Preference', 'SkipSyncTests', opt.screenNumber);
PsychDefaultSetup(2);
[opt.window, opt.windowRect] = Screen('OpenWindow',opt.screenNumber, [0,0,0]);
Screen('BlendFunction', opt.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextSize', opt.window, 50);

opt.screenWidth = opt.windowRect(3);
opt.screenHeight = opt.windowRect(4);
opt.centerX = opt.screenWidth / 2;
opt.centerY = opt.screenHeight / 2;
opt.screenFlipHz = 60;
opt.screenFlipTime = 1/opt.screenFlipHz;
opt.pixelPerDeg = opt.viewingDistance*tand(1)*sqrt(opt.screenWidth^2+opt.screenHeight^2)/opt.monitorSize;
opt.eyeGraceDist = 20 * opt.pixelPerDeg;

% (dist VS map) weight
opt.weightMap = 1-opt.weightDist;
opt.optionNum = 12;
theta = mat2cell((1:opt.optionNum)*(360/opt.optionNum),1,ones(1,opt.optionNum));
opt.optionRotMat = cellfun(@(x1) [cosd(x1), -sind(x1); sind(x1), cosd(x1)],theta,'un',0);


end

function opt = makeScreenComponents(opt)

% timer
opt.timerPos = round([1,1]*50);
opt.timerBoxSz = round([0.5,3]*opt.pixelPerDeg);
opt.timerSpent = opt.totalSpent;
opt.timerPresent = 1;

% playground
opt.playgroundCol(1,1,:) = [1,1,1]*1;
opt.circularity = 1;
[opt.mapX,opt.mapY] = meshgrid(1:opt.screenWidth,1:opt.screenHeight);
[opt,opt.mapBoundary] = playgroundOffset(opt);
[~,opt.playground] = playgroundOffset(opt,round(opt.avatarSz/2)*1.05);
opt.playgroundIdx = Screen('MakeTexture', opt.window, opt.mapBoundary.*opt.playgroundCol*255);
opt = getMapCost(opt,0);


% choice ring
opt.choiceBoundDist = round(3*opt.avatarSz);
opt.choiceBoundWidth = 5;
opt.choiceCol1(1,1,:) = [1,1,1].*153./255;
opt.choiceCol2(1,1,:) = [239,138,98]./255;
[X,Y] = meshgrid((1:opt.choiceBoundDist)-opt.choiceBoundDist/2);
choiceMap = (abs( sqrt(X.^2+Y.^2) - opt.choiceBoundDist/2 + opt.choiceBoundWidth) < opt.choiceBoundWidth) & (abs(X) > opt.avatarSz/2);
opt.choiceRing = ((choiceMap & X > opt.avatarSz/2).*opt.choiceCol1 + (choiceMap & X < -opt.avatarSz/2).*opt.choiceCol2 + ~choiceMap.*opt.playgroundCol);
opt.choiceRing = cat(3,opt.choiceRing,sum(opt.choiceRing==1,3)~=3);
opt.choiceRingIdx = Screen('MakeTexture', opt.window, opt.choiceRing*255);
opt.choiceRingPresent = 0;

end

function opt = getMapCost(opt,re)
if nargin < 2, re = 0; end

if re,
    boundCost = zeros(opt.screenHeight,opt.screenWidth);
    for i = 1:opt.screenHeight,
        [~,tmpcost] = playgroundOffset(opt,i);
        boundCost = boundCost + tmpcost*1;
    end
    boundCost = -boundCost/range(boundCost(:));
    
    distCost = (sqrt((opt.mapX-opt.centerX).^2 + (opt.mapY-opt.centerY).^2));
    distCost = distCost/range(distCost(:));
    mapCost = boundCost+distCost*3.5;
    opt.mapCost = mapCost;
    save(fullfile(pwd,'utils','mapCost.mat'),'mapCost')
else
    load(fullfile(pwd,'utils','mapCost.mat'))
    opt.mapCost = mapCost;
end
end

function opt = countRewarded(opt)

opt.totalMoney = 0;
opt.totalSpent = 0;
dateList = {date};
if ~opt.trainingMode
    prev = dir(opt.dataDir);
    for i = 3:length(prev),
        load(fullfile(prev(i).folder,prev(i).name))
        
        isToday = strcmp(data.info.date,date);
        if isToday, 
            opt.totalSpent = max(opt.totalSpent,data.info.totalSpent); 
            opt.totalMoney = opt.totalMoney + data.earnedMoney;
        end
            
        if ~sum(strcmp(dateList,data.info.date)),
            dateList = cat(1,dateList,data.info.date);
        end
    end
end
opt.dayIdx = length(dateList);

end