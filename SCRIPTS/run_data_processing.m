clear all

paths.data = 'path\to\data';
paths.eeglab = 'C:\\TOOLBOXES\\eeglab2022.1\\';
paths.filename = 'P03_B_Locfix_run1.bdf';

EEG.etc.eeglabvers = '2022.1';

EEG = load_files(paths);

% channel allocation, re-referencing, remove externals, high pass fillter (.1),
% remove begin and end
EEG = basic_preprocessing(EEG, paths);

% epoch data 
EEG = epoch_data(EEG);

% remove bad channels
EEG = remove_data(EEG);

% inspect (time) frequency domain
plot_static_frequency(EEG);
plot_time_frequency(EEG, 'PO8');

% TODO: plot/inspect more data info?
% TODO: convert condition names: high - low frequency
% TODO: concatenate files

% save data as *.set file
% TODO: file naming, use EEG.setname?
prompt = "Do you want to save the dataset? Y/N [Y]: ";
save = input(prompt,"s");
if isempty(save) | contains('YyyesYes', save)
    pop_saveset( EEG, 'filename','participant_3_cli.set','filepath', paths.data);
end