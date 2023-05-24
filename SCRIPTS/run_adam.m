clear all
params_config_file

%% GENERAL SPECIFICATIONS OF THE EXPERIMENT 
filenames = params.paths.prep_filenames;

% GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                  % clear the config variable  
cfg.datadir = params.paths.ress_trace;
cfg.model = 'BDM';                         % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                    % classify raw or time frequency representations ('tfr')
% cfg.frequencies = 4.5:1.5:7.5;
cfg.nfolds = 2;                            % the number of folds to use
cfg.class_method = 'AUC';             	   % the performance measure to use
cfg.crossclass = 'yes';                    % 'no' = faster but no GAT
cfg.resample = 128;                        % downsample (useful for temporal generalization)
% cfg.tfr_method = ?; diagLinear', 'mahalanobis' or 'quadratic'
% cfg.bintrain / cfg.bintest ?;
% cfg.reproduce = 'yes' --> sort of seed

%% FIRST LEVEL ANALYSES
cfg.filenames = filenames;              % specifies filenames (EEG in this case)
cfg.class_spec{1} = cond_string(params.low_freq_con);          % the first stimulus class
cfg.class_spec{2} =  cond_string(params.high_freq_con);         % the second stimulus class
cfg.outputdir = params.paths.results;  % output location
adam_MVPA_firstlevel(cfg);                 % run first level analysis

%% PLOT SINGLE SUBJECT RESULTS OF THE HIGH_LOW_FREQUENCY COMPARISON
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.reduce_dims = 'diag';                    % train and test on the same points
cfg.splinefreq = 11;                         % acts as an 11 Hz low-pass filter
cfg.plotsubjects = true;                     % also plot individual subjects
adam_compute_group_MVPA(cfg);                % select EEG_FAM_VS_SCRAMBLED when dialog pops up

%% COMPUTE THE DIAGONAL DECODING RESULTS FOR ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.reduce_dims = 'diag';                    % train and test on the same points
mvpa_stats = adam_compute_group_MVPA(cfg);   % select RAW_EEG when dialog pops up

%% PLOT THE DIAGONAL DECODING RESULTS FOR ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.singleplot = true;                       % all erps in a single plot
cfg.acclim = [.4 1];                        % change the y-limits of the plot
adam_plot_MVPA(cfg, mvpa_stats); 

%% PLOT ACTIVATION PATTERNS OF ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.mpcompcor_method = 'cluster_based';      % amultiple comparison correction method
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots
cfg.timelim = [100 200];                     % time window to visualize
adam_plot_BDM_weights(cfg,mvpa_stats);       % actual plotting

%% COMPUTE THE TEMPORAL GENERALIZATION MATRIX OF ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.iterations = 250;                        % reduce the number of iterations to save time
mvpa_eeg_stats = adam_compute_group_MVPA(cfg);  % select RAW_EEG when dialog pops up

%% PLOT THE TEMPORAL GENERALIZATION MATRIX OF ALL EEG COMPARISONs
cfg = [];                                    % clear the config variable
adam_plot_MVPA(cfg, mvpa_eeg_stats);  % actual plotting, combine EEG/MEG results

%% COMPUTE GENERALIZATION ACROSS TIME FOR THE 250-400 MS TIME WINDOW FOR EEG COMPARISONS 
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.trainlim = [100 200];                    % specify a 250-400 ms interval in the training data
cfg.reduce_dims = 'avtrain';                 % average over that training interval
mvpa_eeg_stats = adam_compute_group_MVPA(cfg);  % select RAW_EEG when dialog pops up

%% PLOT GENERALIZATION ACROSS TIME FOR THE 250-400 MS TIME WINDOW FOR EEG AND MEG COMPARISONS 
cfg = [];                                    % clear the config variable
adam_plot_MVPA(cfg, mvpa_eeg_stats);  % actual plotting, combine EEG/MEG results


% adam_compare_MVPA_stats()

