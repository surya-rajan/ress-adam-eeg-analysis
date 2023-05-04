function plot_static_frequency(EEG)

    % load restingstate64chans.mat
    EEG.data = double(EEG.data);
    
    % perform fourier transform over timepoints
    chanpowr = ( 2*abs( fft(EEG.data,[],2) )/EEG.pnts ).^2;
  
    % average over trials
    chanpowr = mean(chanpowr,3);
    
    % vector of frequencies
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    
    % plot power spectrum of all channels
    subplot(3,1,1)
    plot(hz,chanpowr(:,1:length(hz)),'linew',2)
    title('all')
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 55],'ylim',[0 50])

    % TODO: if epoched == true, extract trials per conditions
    epochs_1 = double.empty;
    epochs_3 = double.empty;

    % note that some epochs contain both conditions (depending on epoching)
    % and therefor appear in both epochs_1 and epochs_3
    for i=1:length(EEG.event)
        if convertCharsToStrings(EEG.event(i).type) == "condition 1"
            epochs_1(end + 1) = EEG.event(i).epoch;
        elseif convertCharsToStrings(EEG.event(i).type) == "condition 3"
            epochs_3(end + 1) = EEG.event(i).epoch;
        end
    end

    % perform fourier transform over timepoints for condition 1
    chanpowr_1 = ( 2*abs( fft(EEG.data(:,:,epochs_1),[],2) )/EEG.pnts ).^2;
  
    % average over trials
    chanpowr_1 = mean(chanpowr_1,3);
    
    % vector of frequencies
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    
    % plot power spectrum of all channels
    subplot(3,1,2)
    plot(hz,chanpowr_1(:,1:length(hz)),'linew',2)
    title('condition 1')
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 55],'ylim',[0 50])


    % perform fourier transform over timepoints for condition 3
    chanpowr_3 = ( 2*abs( fft(EEG.data(:,:,epochs_3),[],2) )/EEG.pnts ).^2;
  
    % average over trials
    chanpowr_3 = mean(chanpowr_3,3);
    
    % vector of frequencies
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    
    % plot power spectrum of all channels
    subplot(3,1,3)
    plot(hz,chanpowr_3(:,1:length(hz)),'linew',2)
    title('condition 3')
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 55],'ylim',[0 50])


