function cdata = catData(name,genDir)

if nargin < 2, dataDir = fullfile(pwd,'data',name);
else           dataDir = fullfile(genDir,'data',name); end

dataFiles = dir(dataDir);

for f = 1:length(dataFiles)-2,
    
    try,
        load(fullfile(dataFiles(f+2).folder,dataFiles(f+2).name));
        
        try,cdata.friendlyness(f) = data.friendlyness; catch cdata.friendlyness(f) = data.info.friendlyness; end
        cdata.choiceItem(f) = data.choiceItem;
        cdata.rewarded(f) = data.rewarded;
        try, cdata.earnedMoney(f) = data.earnedMoney; end
        
        try,
            eraseIdx = abs(data.eyePos)>1e3*5;
            data.eyePos(eraseIdx) = nan;
            data.eyeSz(sum(eraseIdx,2)==2) = nan;
            
            cdata.eyePos{f} = data.eyePos;
            cdata.eyeSz{f} = data.eyeSz;
        end
        cdata.avatar{f} = data.avatar;
        cdata.prey{f} = data.prey;
        cdata.opponent{f} = data.opponent;
        
        cdata.phase{f} = data.phase;
    end
    
    
end


end