%% RESS to EEGLab

% edit the following fields in the EEG data structure to create an EEG
% dataset with only 2 channels corresponding to the RESS data

EEG.filepath = params.paths.ress_trace;
EEG.nbchan = 2;
EEG.data(1,:) = ress.ts1';
EEG.data(2,:) = ress.ts2';
EEG.data(3:end,:) = [];
chanlocs = struct('labels', { 'P1' 'P2'});
EEG.chanlocs = pop_chanedit( chanlocs );
EEG = epoch_data(EEG); % to input in ADAM
pop_saveset(EEG);