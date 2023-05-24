function ALLEEG = load_files(params, path, type)
    % input: params (struct)
    % output: ALLEEG (struct) containing one or more EEG sets

    if type == ".bdf"
        ALLEEG = pop_biosig(cellstr(strcat(path, params.paths.participant_nr, params.paths.session , params.paths.raw_filenames, type)));
        for i = 1:length(ALLEEG)
             ALLEEG(i).setname = sprintf('%s', string(params.paths.raw_filenames(i)));
             ALLEEG(i).filename = sprintf('%s', string(params.paths.raw_filenames(i)));
             ALLEEG(i) = eeg_checkset( ALLEEG(i));
        end

    end
    if type == ".set"
        ALLEEG = pop_loadset('filename',cellstr(strcat(params.paths.prep_filenames, type)),'filepath', path);
    end