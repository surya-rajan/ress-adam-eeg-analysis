function save_file(EEG, params, timestamp)
    prompt = "Do you want to save the dataset? Y/N [Y]: ";
    save = input(prompt,"s");

    if isempty(save) | contains('YyyesYes', save)
        name = sprintf('%s%s.set', string(EEG.filename), timestamp);
        pop_saveset( EEG, 'filename', name, 'filepath', params.paths.preprocessed);

        text = sprintf('%s\n', string(cellstr(EEG.comments)));
        text = regexprep( text, '\', '\\\');

        txt_file = fopen(params.paths.preprocessed + string(EEG.filename) + timestamp + '.txt', 'w');
        fprintf(txt_file, text);
        fclose(txt_file);
    end