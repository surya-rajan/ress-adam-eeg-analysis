function EEG = epoch_data(EEG, params, timestamp)

    prompt = "Do you want to epoch the data? Y/N [Y]: ";
    epoch = input(prompt,"s");

    if isempty(epoch) | contains('YyyesYes', epoch)

        % epoch data for condition 1 and 3
        EEG = pop_epoch( EEG, { '1' '3' }, [-0.5 1.3], 'epochinfo', 'yes');
        EEG.setname = sprintf('%s_epch', string(EEG.setname));
        EEG = eeg_checkset( EEG );
    
        % apply baseline correction
        prompt = "Do you want to perform baseline correction? Y/N [Y]: ";
        baseline_corr = input(prompt,"s");
        if isempty(baseline_corr) | contains('YyyesYes', baseline_corr)
            EEG = pop_rmbase( EEG, [-100 0] ,[]);
            EEG.setname = sprintf('%s+b', string(EEG.setname));
            EEG.comments = pop_comments(EEG.comments,'',sprintf('Dataset was epoched with baseline correction'),1);
            EEG = eeg_checkset( EEG );  
        else
            EEG.comments = pop_comments(EEG.comments,'',sprintf('Dataset was epoched without baseline correction'),1);
            EEG = eeg_checkset( EEG );  
        end

    end

    prompt = "Do you want to plot the data? Y/N [Y]: ";
    epoch = input(prompt,"s");

    if isempty(epoch) | contains('YyyesYes', epoch)

        plot_epoched_data(EEG, params, timestamp);

    end

