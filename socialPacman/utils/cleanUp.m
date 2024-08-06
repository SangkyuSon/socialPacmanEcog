function cleanUp(opt)
% shut down program
fclose(opt.fid);
sca;
clear JoyMEX;

end