function flashScreen(opt)

Screen('FillRect', opt.window, 0*[255, 255, 255]);
Screen('Flip', opt.window);
WaitSecs(3/60);
%updateScreen(opt);

end