function opt = saveData(opt,data)

if ~opt.abortTrial & ~opt.trainingMode & ~opt.debugMode
    if ~exist(opt.dataDir,'dir'), mkdir(opt.dataDir); end
    fileName = sprintf('%d.mat',opt.trial);
    
    save(fullfile(opt.dataDir,fileName),'data')
    %opt.trial =  opt.trial + 1;
    
    if opt.totalSpent > (opt.timerMax*60),
        sca;
        clear JoyMEX;
        opt.expDone = 1;
        fprintf('Total money earned: ₩%d\n',opt.totalMoney)
    end
 
end

opt.lastFriendlyness = data.friendlyness;

end