function EEG = remove_data(EEG)
    
    ask = true; 
    while ask
        prompt = "Do you want to remove (more) channels? Y/N [Y]: ";
        answer = input(prompt,"s");

        if isempty(answer) | contains('YyyesYes', answer) 

            % plot data to inspect which channels you want to remove
            pop_eegplot( EEG, 1, 1, 1);
            waitfor( findobj('parent', gcf, 'string', 'REJECT'), 'userdata');
            
            % remove channels
            sprintf('%s, ', EEG.chanlocs.labels)
            prompt = "Which channels do you want to remove? [Insert one ore more channels separated by a whitespace: Fp1 AF7]: ";
            channels = input(prompt,"s");
            channels = split(channels);
        
            if ~isempty(channels)
                EEG = pop_select( EEG, 'nochannel', channels );
                EEG.setname = sprintf('%s_remc', string(EEG.setname));
                EEG = eeg_checkset( EEG );
                EEG.comments = pop_comments(EEG.comments,'',sprintf('Channels Removed: %s', join(string(channels))), 1);
            end
        
            % plot data again to check 
            pop_eegplot( EEG, 1, 1, 1);
            waitfor( findobj('parent', gcf, 'string', 'REJECT'), 'userdata');

        elseif contains('NnnoNo', answer)
            ask = false;
        end
    end

    ask = true; 
    while ask
        prompt = "Do you want to remove (more) eopchs? Y/N [Y]: ";
        answer = input(prompt,"s");

        if isempty(answer) | contains('YyyesYes', answer) 
            prompt = "Which eopchs do you want to remove? [Insert one nr]: ";
            epochs = input(prompt,"s");

            EEG = pop_select( EEG, 'notrial', str2double(epochs) );
            EEG = eeg_checkset( EEG );

       elseif contains('NnnoNo', answer)
            ask = false;
        end
    end
