%% COMPUTE RAW GROUP ERPs FROM THE HIGH_LOW_FREQUENCY FIRST LEVEL ANALYSIS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.electrode_def = {'03'};                 % electrode to plot
erp_stats = adam_compute_group_ERP(cfg);     

%% COMPUTE THE DIFFERENCE BETWEEN THE ERPs FROM THE HIGH_LOW_FREQUENCY FIRST LEVEL ANALYSIS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.electrode_def = {'03'};                 % electrode to plot
cfg.condition_method = 'subtract';           % compute subtraction of ERP 
erp_stats_dif = adam_compute_group_ERP(cfg); 

%% PLOT THE ERPs AND THEIR DIFFERENCE IN A SINGLE PLOT
cfg = [];                                    % clear the config variable
cfg.singleplot = true;                       % all graphs in a single plot
cfg.line_colors = {[.75 .75 .75] [.5 .5 .5] [0 0 .5]};  % change the colors
adam_plot_MVPA(cfg, erp_stats, erp_stats_dif);   % actual plotting

%% INSPECTING THE STATS STRUCTURE TO FIND ONSET AND 
% PEAK TIMES
erp_stats_dif(1)
erp_stats_dif(1).pStruct
erp_stats_dif(1).pStruct.negclusters

%% COMPUTE THE DIAGONAL DECODING RESULTS FOR ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.reduce_dims = 'diag';                    % train and test on the same points
mvpa_stats = adam_compute_group_MVPA(cfg);   % select RAW_EEG when dialog pops up

%% PLOT THE DIAGONAL DECODING RESULTS FOR ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.singleplot = true;                       % all erps in a single plot
cfg.acclim = [.4 .8];                        % change the y-limits of the plot
adam_plot_MVPA(cfg, mvpa_stats);             % actual plotting

%% PLOT SINGLE SUBJECT RESULTS OF THE HIGH_LOW_FREQUENCY COMPARISON
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.reduce_dims = 'diag';                    % train and test on the same points
cfg.splinefreq = 11;                         % acts as an 11 Hz low-pass filter
cfg.plotsubjects = true;                     % also plot individual subjects
adam_compute_group_MVPA(cfg);                % select EEG_FAM_VS_SCRAMBLED when dialog pops up

%% PLOT ACTIVATION PATTERNS OF ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.mpcompcor_method = 'cluster_based';      % amultiple comparison correction method
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots
cfg.timelim = [250 400];                     % time window to visualize
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
cfg.trainlim = [250 400];                    % specify a 250-400 ms interval in the training data
cfg.reduce_dims = 'avtrain';                 % average over that training interval
mvpa_eeg_stats = adam_compute_group_MVPA(cfg);  % select RAW_EEG when dialog pops up

%% PLOT GENERALIZATION ACROSS TIME FOR THE 250-400 MS TIME WINDOW FOR EEG AND MEG COMPARISONS 
cfg = [];                                    % clear the config variable
adam_plot_MVPA(cfg, mvpa_eeg_stats);  % actual plotting, combine EEG/MEG results

adam_compare_MVPA_stats()