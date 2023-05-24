function ALLEEG = concat_files(ALLEEG, params)
    
    ask = true; 

    while ask
        prompt = "Do you want to concatenate (more) files? Y/N [Y]: ";
        answer = input(prompt,"s");
    
        if isempty(answer) | contains('YyyesYes', answer) 
            sprintf('%s, ', ALLEEG.setname)
            prompt = "Which datasets do you want to merge, enter index nr with whitespace inbetween? 1 2 / [None]: ";
            response = input(prompt,"s");
            sets_to_merge = zeros(1,2);
    
            if string(response) == "" | contains('NnnoNoNonenone', string(response))
                ask = false;
            else
                sets = split(response, ' ');
                
                sets_to_merge(1) =  str2num(sets{1});
                sets_to_merge(2) =  str2num(sets{2});
            
                % TODO: avoid hard coded run_2
                EEG = pop_mergeset(ALLEEG, sets_to_merge, 0);
                EEG.filename = sprintf('%s+2', string(EEG.filename));
                EEG.setname = sprintf('%s', string(EEG.filename));
                EEG = eeg_checkset( EEG);
                EEG.comments = pop_comments(EEG.comments,'',sprintf('%s', string(strip(params.paths.session, '\'))),1);
                EEG.comments = pop_comments(EEG.comments,'',sprintf('Dataset was merged with: %s', string(params.paths.raw_filenames(sets_to_merge(2)))),1);
                ALLEEG(sets_to_merge(1)) = EEG;
                ALLEEG(sets_to_merge(2)) = [];
            end
        elseif contains('NnnoNo', answer)
           ask = false;
        end
    end

    