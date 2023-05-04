function plot_time_frequency(EEG, channel)

    % plot time frequency
    % TODO: go through setting maybe code plot withouth eeglab function
    EEG = eeg_checkset( EEG );
    figure; pop_newtimef( EEG, 1, 62, [0  239141], [3 0.8] , 'topovec', 62, ...
        'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', channel, ...
        'baseline',[0], 'plotphase', 'off', 'padratio', 1);