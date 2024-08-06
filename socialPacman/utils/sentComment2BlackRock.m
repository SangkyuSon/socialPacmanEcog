function sentComment2BlackRock(opt)

if ~opt.debugMode & ~opt.trainingMode,
    
    event_msg = sprintf('tr%d_b%d_fr%.0f_phase%d',opt.trial,opt.block,opt.friendlyness*10,opt.phase);

    for i = 1:2
        try
            cbmex('comment',16711680,0,event_msg,'instance',i-1);
        catch
            disp("BlackRock did not receive the event");
        end
    end

end

end