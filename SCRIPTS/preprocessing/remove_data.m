function EEG = remove_data(EEG)

    % plot data to inspect which channels you want to remove
    pop_eegplot( EEG, 1, 1, 1);
    waitfor( findobj('parent', gcf, 'string', 'REJECT'), 'userdata');
    
    % remove channels
    prompt = "Which channels do you want to remove? ";
    channels = input(prompt,"s");

    if ~isempty(channels)
        EEG = pop_select( EEG, 'nochannel',{channels});
        EEG.setname='P03_B_Locfix_run1_reRef_hpFilt_remExt_rej_remChann';
        EEG = eeg_checkset( EEG );
    end

    % plot data again to check 
    pop_eegplot( EEG, 1, 1, 1);
    waitfor( findobj('parent', gcf, 'string', 'REJECT'), 'userdata');

    % TODO: remove data by eye?
 