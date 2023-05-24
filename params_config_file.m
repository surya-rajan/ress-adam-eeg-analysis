%% Paths
params.paths.results = '';
params.paths.data = '';
params.paths.preprocessed = '';
params.paths.ress_trace = '';

params.paths.eeglab = 'C:\\TOOLBOXES\\eeglab2022.1\\';
params.paths.participant_nr = 'P05\';
params.paths.session = 'Session2\';
params.paths.raw_filenames = {'P05_FA_Loc_run1', 'P05_FA_Loc_run2'}; 
params.paths.prep_filenames = {
    % 'P01_B_LOC_run1+2_22947', 'P01_FA_LOC_run1+2__221043', ...
    'P03_B_Locfix_run1+2__221131' 'P03_B_Locfix_run1+2__221151' ...
    % 'P03_FA_Loc_run1+2__221210','P03_OM_Loc_run1+2__221140', ...
    % 'P04_B_Locfix_run1+2__221226', 'P04_FA_LOC_run1+2__221234', ...
    % 'P04_B_Locfix_run1+2__221240', 'P04_OM_LOC_run1+2__221246', ...
    % 'P05_B_Locfix_run1+2__22241', 'P05_OM_Loc_run1+2__22249', ...
    % 'P05_B_Locfix_run1+2__22255', 'P05_FA_Loc_run1+2__2230'
}; % WARNING: for ADAM a comma means test vs train! For ress comma is needed

%% General Params
params.low_freq = 6;
params.high_freq = 7.5;
params.low_freq_con = "1";
params.high_freq_con = "3";

%% RESS params


%% ADAM params
