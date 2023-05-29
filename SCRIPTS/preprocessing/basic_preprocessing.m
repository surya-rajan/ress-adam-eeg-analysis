function EEG = basic_preprocessing(EEG, params)

    % add channel locations
    EEG = pop_chanedit(EEG, 'lookup', strcat(params.paths.eeglab,'plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc'));
    EEG = eeg_checkset( EEG );

    % check powerplot before re-referencing
    pop_prop( EEG, 1, [69  70], NaN, {'freqrange',[2 55] });

    % inspect scroll data before re-referencing
    pop_eegplot( EEG, 1, 1, 1);
    waitfor( findobj('parent', gcf, 'string', 'REJECT'), 'userdata');

    % ask if data should be rereferenced
    prompt = "Do you want to rereference using 69 and 70? Y/N [Y]: ";
    rereference = input(prompt,"s");

    if isempty(rereference) | contains('YyyesYes', rereference)
        electrodes = [69 70];
    elseif contains('NnnoNo', rereference)
        prompt = "Which electrode do you want to use? 69/70/None: ";
        answer = input(prompt,"s");
        if answer == "69" | answer == "70"
            electrodes = [str2double(input(prompt,"s"))];
        else
            electrodes = false;
        end
    end
    
    % re-reference data
    if electrodes
        EEG = pop_reref( EEG, electrodes );
        EEG.setname = sprintf('%s_ref', string(EEG.filename));
        EEG = eeg_checkset( EEG );
        EEG.comments = pop_comments(EEG.comments,'',sprintf('Dataset was rereferenced, with channels: %s and %s', string(electrodes)),1);
    end
   
    % high pass filter data (0.1)
    prompt = "Do you want to high pass filter the data? Y/N [Y]: ";
    filter = input(prompt,"s");

    if isempty(filter) | contains('YyyesYes', filter)
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.1);
        EEG.setname = sprintf('%s_hpf', string(EEG.setname));
        EEG = eeg_checkset( EEG );
        EEG.comments = pop_comments(EEG.comments,'','Dataset was highpass filtered at 0.1 Hz.',1);
    end

    % TODO: add cleanline

    % remove signal before and after trial start
    % TODO: check onset conditions
    begin_point_exp = EEG.event(1).latency;
    EEG = eeg_eegrej( EEG, [(begin_point_exp - 500) begin_point_exp] ); % onset condition - 500 miliseconds
    end_point_exp = EEG.event(end).latency;
    EEG = eeg_eegrej( EEG, [end_point_exp (EEG.pnts - 500)] ); % onset condition 12 + 500 miliseconds
    EEG.setname= sprintf('%s_rej', string(EEG.setname));
    EEG = eeg_checkset( EEG );

    % remove external channels
    % TODO: if re-referenced to one channel, remove the other here aswell?
    prompt = "Do you want to remove the external channels? Y/N [Y]: ";
    remove = input(prompt,"s");
    if isempty(remove) | contains('YyyesYes', remove)
        EEG = pop_select( EEG, 'nochannel',{'EXG1','EXG2','EXG3','EXG4','EXG7','EXG8'});
        EEG.setname= sprintf('%s_remex', string(EEG.setname));
        EEG = eeg_checkset( EEG );
        EEG.comments = pop_comments(EEG.comments,'','Externals where removed',1);
    end
