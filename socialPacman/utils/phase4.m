function [opt,data] = phase4(opt,data)

if ~opt.abortTrial,
    
    reportDone = 0;
    while ~reportDone,
        Screen('DrawTexture',opt.window,opt.playgroundIdx);
        
        Screen('Flip', opt.window);
    end
    
    
end

end