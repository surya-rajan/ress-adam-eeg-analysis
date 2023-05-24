clear all
params_config_file

EEG.etc.eeglabvers = '2022.1';

%% load data 
ALLEEG = load_files(params, params.paths.preprocessed, '.set');

for i = 1:length(ALLEEG)
    EEG = ALLEEG(i);
    EEG.data = double(EEG.data);
    EEG = eeg_checkset(EEG);

    ress = BR_compute_RESS_SRS(EEG, params);
    BR_plot_RESS_component(EEG, params, ress);
    ress_2_EEG
end