function EEG = load_files(paths)

    % Load EEG dataset(s)
    % TODO: bdf vs set, load more than one file (maybe whole folder?)
    EEG = pop_biosig(strcat(paths.data, paths.filename));
    EEG.setname= paths.filename;
    EEG = eeg_checkset( EEG );