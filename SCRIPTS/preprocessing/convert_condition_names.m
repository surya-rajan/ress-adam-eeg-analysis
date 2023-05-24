function EEG = convert_condition_names(EEG, params)
    setname = split(EEG.setname, "_");
    participant_nr = setname(1);
    red_green = {'P02', 'P04', 'P09', 'P10', 'P11', 'P14', 'P15', 'P16'};
    green_red = {'P01','P03', 'P05', 'P06', 'P07', 'P08', 'P12', 'P13'};

    low_freq_con = '1';
    high_freq_con = '3';

    if any(strcmp(red_green, string(participant_nr{1})))
        % low_frequency = '1'; high_frequency = '3';  

        EEG = pop_selectevent( EEG, 'type',{'condition 1'},'renametype',low_freq_con ,'deleteevents','off');
        EEG = pop_selectevent( EEG, 'type',{'condition 3'},'renametype',high_freq_con,'deleteevents','off');
        EEG = pop_selectevent( EEG, 'type',{'condition 2'},'renametype',high_freq_con,'deleteevents','off');
        EEG.setname = sprintf('%s_conv', string(EEG.setname)); 
        EEG.comments = pop_comments(EEG.comments,'',sprintf("Condition names where converted, now '1'=" + ...
            string(params.low_freq) + "hz, '3 or 2'=" + string(params.high_freq) + "hz"),1);
    elseif any(strcmp(green_red, string(participant_nr{1})))
        % low_frequency = '3'; high_frequency = '1'; 

        EEG = pop_selectevent( EEG, 'type',{'condition 1'},'renametype',high_freq_con,'deleteevents','off');
        EEG = pop_selectevent( EEG, 'type',{'condition 3'},'renametype',low_freq_con,'deleteevents','off');
        EEG = pop_selectevent( EEG, 'type',{'condition 2'},'renametype',low_freq_con,'deleteevents','off');
        EEG.setname = sprintf('%s_conv', string(EEG.setname)); 
        EEG.comments = pop_comments(EEG.comments,'',sprintf("Condition names where converted, now '1'=" + ...
            string(params.low_freq) + "hz, '3 or 2'=" + string(params.high_freq) + "hz"),1);
    else
        error('Condition names NOT converted, participant name not known')
    end

    EEG = eeg_checkset( EEG );
    