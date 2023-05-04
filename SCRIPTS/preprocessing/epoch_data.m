function EEG = epoch_data(EEG)
    % epoch data for condition 1 and 3
    EEG = pop_epoch( EEG, { 'condition 1' 'condition 3' }, [-0.5 1.3], 'epochinfo', 'yes');
    EEG.setname='P03_B_Locfix_run1_reRef_hpFilt_remExt_rej_epoched';
    EEG = eeg_checkset( EEG );

    % apply baseline correction
    prompt = "Do you want to perform baseline correction? Y/N [Y]: ";
    baseline_corr = input(prompt,"s");
    if isempty(baseline_corr) | contains('YyyesYes', baseline_corr)
        EEG = pop_rmbase( EEG, [-100 0] ,[]);
        EEG.setname='P03_B_Locfix_run1_reRef_hpFilt_remExt_rej_epoched_bCorr';
        EEG = eeg_checkset( EEG );  
    end