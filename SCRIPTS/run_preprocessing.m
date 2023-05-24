clear
params_config_file

EEG.etc.eeglabvers = '2022.1';

%% load data 
ALLEEG = load_files(params, params.paths.data, '.bdf'); % load set or bdf files 

%% concatenate files
ALLEEG = concat_files(ALLEEG, params);
EEG = ALLEEG(1);
EEG.data = double(EEG.data);
EEG = eeg_checkset(EEG);

%% channel alloc, re-ref, remove ext, high pass fillter, remove begin and end
EEG = basic_preprocessing(EEG, params);

%% convert condition names: high - low frequency
EEG = convert_condition_names(EEG, params);

%% remove bad channels
EEG = remove_data(EEG);

timestamp = string(datetime('now'), '_dhm');

%% inspect data
plot_continuous_data(EEG, params, 1, timestamp);
   
%% epoch data and make plots, it is not saved to EEG atm 
epoch_data(EEG, params, timestamp);

%% save in ALLEEG struct and as set file
save_file(EEG, params, timestamp);
