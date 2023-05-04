function EEG = basic_preprocessing(EEG, paths)

    % add channel locations
    EEG = pop_chanedit(EEG, 'lookup', strcat(paths.eeglab,'plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc'));
    EEG = eeg_checkset( EEG );

    % check powerplot before re-referencing
    % TODO: topoplots not displalying?
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
        disp(electrodes)
        EEG = pop_reref( EEG, electrodes );
        EEG.setname='P03_B_Locfix_run1_reRef';
        EEG = eeg_checkset( EEG );
    end
   
    % high pass filter data (0.1)
    EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'plotfreqz',1);
    EEG.setname='P03_B_Locfix_run1_reRef_hpFilt';
    EEG = eeg_checkset( EEG );

    % remove signal before and after trial start
    begin_point_exp = EEG.event(1).latency;
    EEG = eeg_eegrej( EEG, [0 begin_point_exp] ); % 0 to onset condition 10
    end_point_exp = EEG.event(end).latency;
    EEG = eeg_eegrej( EEG, [end_point_exp EEG.pnts] ); % onset condition 12 to end
    EEG.setname='P03_B_Locfix_run1_reRef_hpFilt_remExt_rej';
    EEG = eeg_checkset( EEG );

    % remove external channels
    % TODO: if re-referenced to one channel, remove the other here aswell?
    prompt = "Do you want to remove the external channels? Y/N [Y]: ";
    remove = input(prompt,"s");
    if isempty(remove) | contains('YyyesYes', remove)
        EEG = pop_select( EEG, 'nochannel',{'EXG1','EXG2','EXG3','EXG4','EXG7','EXG8'});
        EEG.setname='P03_B_Locfix_run1_reRef_hpFilt_remExt';
        EEG = eeg_checkset( EEG );
    end
