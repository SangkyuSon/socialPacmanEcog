function [opt,data] = updateScreen(opt,data,definedCol)

opt = specialCase(opt);

if ~exist('definedCol','var')
    avatarCol = opt.avatarCol;
    preyCol = opt.preyCol;
    opponentCol = opt.opponentCol;
else
    avatarCol = definedCol;
    preyCol = definedCol;
    opponentCol = definedCol;
end

% if opt.phase == 3,  currentlySpent = (GetSecs - opt.phase3Bgn);  else, currentlySpent = 0; end
% spent = opt.timerSpent + currentlySpent;
% remainingBoxSz = round(opt.timerBoxSz(2) * min(spent/(opt.timerMax*60),1));

Screen('DrawTexture',opt.window,opt.playgroundIdx);
if opt.phase < 2, % in phase 1        
    Screen('FillOval',   opt.window, [0,0,0],              makeRect(opt.avatarX,    opt.avatarY,    opt.avatarSz+10));... 
    if opt.opponentPresent,  
        Screen('FillOval',   opt.window, [0,0,0],              makeRect(opt.opponentX,  opt.opponentY,  opt.opponentSz+10));
    end
    Screen('FillRect',   opt.window, [0,0,0],              makeRect(opt.preyX,      opt.preyY,      opt.preySz+10)); 
end

if opt.avatarPresent,    Screen('FillOval',   opt.window, avatarCol,            makeRect(opt.avatarX,    opt.avatarY,    opt.avatarSz)); end
if opt.preyPresent,      Screen('FillRect',   opt.window, preyCol,              makeRect(opt.preyX,      opt.preyY,      opt.preySz)); end
if opt.opponentPresent,  Screen('FillOval',   opt.window, opponentCol,          makeRect(opt.opponentX,opt.opponentY,opt.opponentSz)); end
% if opt.timerPresent,     Screen('FillRect',   opt.window, [1,1,1]*128,          [50,50,50+opt.timerBoxSz(2),50+opt.timerBoxSz(1)]);...
%                          Screen('FillRect',   opt.window, [1,1,1]*255,          [50,50,50+remainingBoxSz,   50+opt.timerBoxSz(1)]); end
if opt.choiceRingPresent,Screen('DrawTexture',opt.window, opt.choiceRingIdx,[], makeRect(opt.choiceRingX,opt.choiceRingY,opt.choiceBoundDist), opt.choiceRingAng ); end
if opt.rewardPresent,    DrawFormattedText(   opt.window, opt.rewardText,       'center','center'); end

if opt.flashBoxOn,
    % draw photo diode
    flashBoxPosition = [0,opt.screenHeight-opt.flashBoxSz,opt.flashBoxSz,opt.screenHeight];
    Screen('DrawTexture',opt.window, opt.flashBoxIdx,[], flashBoxPosition);
    opt.flashBoxOnCnt = opt.flashBoxOnCnt + 1;
    if opt.flashBoxOnCnt >= 3,
        opt.flashBoxOn = 0;
        opt.flashBoxOnCnt = 0;
    end
end

if opt.debugMode,
    if (GetSecs-opt.frameBgn > opt.screenFlipTime),
        fprintf('\n frame no %d missing\n',opt.timeCounter); 
    end
end

[~,opt.frameBgn] = Screen('Flip', opt.window);

opt.timeCounter = opt.timeCounter + 1;
[opt,data] = collectData(opt,data);

%if opt.videoRecord ,
%    imageArray = Screen('GetImage', opt.window);
%    writeVideo(opt.video, imageArray);
%end

end


