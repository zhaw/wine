% this file act as a monitoring service for single_match
apppath = '/var/www/apps/imagetest/';
lockpath = [apppath 'command.lock'];
commandpath = [apppath 'command.txt'];

disp('service listening start ...');
p = gcp();
disp('parallel pool obtained successfully');
while 1
    % check the file lock
    while exist(lockpath, 'file')
        % need to wait
        pause(0.01)
    end
    % relock the commmand.lock
    flock = fopen(lockpath, 'w');
    fclose(flock);
		fcomm = fopen(commandpath);        
		while ~feof(fcomm)
                [type] = fscanf(fcomm, '%s', 1);
				[sourceimg] = fscanf(fcomm, '%s', 1);
				[logpath] = fscanf(fcomm, '%s', 1);
				if strcmp(sourceimg, '')
						continue
				end
				disp(['task send : source @' sourceimg ', log @' logpath ', at ' datestr(now, 0)])
				% FIXIT : parallel optimization        
				% task = parfevalOnAll(@single_match, 0, sourceimg, logpath);
				% display(['task submitted @ ID :' num2str(task.ID)]);
                switch(type)
                    case 'wine'
                        cd 'Doctor_wine_web/';
                        single_match(sourceimg, logpath);
                        display('single match finished.');
                        cd '../';
                    case 'scenery'
                        cd 'scenery_recognition/';
                        single_match_for_scenery(sourceimg, logpath);
                        cd '../';
                    case 'invoice'
                end
				display('task finished!');
		end  
		fclose(fcomm);
		% erase file content
		fcomm = fopen(commandpath, 'w');
		fclose(fcomm);    
    % release the lock
    delete(lockpath);
    pause(0.2);
end
