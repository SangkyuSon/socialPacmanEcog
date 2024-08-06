
clear all; 
genDir = pwd;
cd(genDir); addpath(genpath(genDir))

opt = initiate();
for tr = 1:opt.predefined.trialNo
    
    opt.trial = tr;
    [opt,data] = trialReset(opt);
    
    [opt,data] = phase1(opt,data);
    [opt,data] = phase2(opt,data);
    [opt,data] = phase3(opt,data);

    opt = saveData(opt,data);
   
end

sca
if ~opt.debugMode, TaskComment('stop',opt.EMUfname); end
