function plot_epoched_data(EEG, params, timestamp)
    
    prompt = "Which channel nr do you want to plot? 6 [62]: ";
    channel = input(prompt,"s");

    if string(channel) == ""
        chan = 62;
    else
        chan = str2num(channel);
    end

    if ~numel(size(EEG.data))==3
        error('data is not epoched');
    end

    figure(100), clf
    
    %% ERP
    subplot(221), hold on
    h = plot(EEG.times,squeeze(EEG.data(chan,:,:)),'linew',.5);
    set(h,'color',[1 1 1]*.75)
    plot(EEG.times,squeeze(mean(EEG.data(chan,:,:),3)),'k','linew',3);
    xlabel('Time (s)'), ylabel('Activity')
    title([ 'ERP from channel ' num2str(chan) ])

    %% time-frequency analysis

    % frequencies in Hz (hard-coded to 2 to 30 in 40 steps)
    frex = linspace(2,30,40);
    
    % number of wavelet cycles (hard-coded to 3 to 10)
    waves = 2*(linspace(3,10,length(frex))./(2*pi*frex)).^2;
    
    % setup wavelet and convolution parameters
    wavet = -2:1/EEG.srate:2;
    halfw = floor(length(wavet)/2)+1;
    nConv = EEG.pnts*EEG.trials + length(wavet) - 1;
    
    % initialize time-frequency matrix
    tf = zeros(length(frex),EEG.pnts);
    
    % spectrum of data
    dataX = fft(reshape(EEG.data(chan,:,:),1,[]),nConv);
    
    % loop over frequencies
    for fi=1:length(frex)
        
        % create wavelet
        waveX = fft( exp(2*1i*pi*frex(fi)*wavet).*exp(-wavet.^2/waves(fi)),nConv );
        waveX = waveX./max(waveX); % normalize
        
        % convolve
        as = ifft( waveX.*dataX );
        % trim and reshape
        as = reshape(as(halfw:end-halfw+1),[EEG.pnts EEG.trials]);
        
        % power
        tf(fi,:) = mean(abs(as),2);
    end
    
    % show a map of the time-frequency power
    subplot(222)
    contourf(EEG.times,frex,tf,40,'linecolor','none')
    xlabel('Time'), ylabel('Frequency (Hz)')
    title([ 'Time-frequency plot channel: ' num2str(chan) ])

    %% channel means for 3 condition in one power plot for specfic channel

    epochs_1 = double.empty;
    epochs_3 = double.empty;
    
    % note that some epochs contain both conditions (depending on epoch length)
    % and therefor appear in both epochs_1 and epochs_3
    for i=1:length(EEG.event)
        if convertCharsToStrings(EEG.event(i).type) == params.low_freq_con
            epochs_1(end + 1) = EEG.event(i).epoch;
        elseif convertCharsToStrings(EEG.event(i).type) == params.high_freq_con
            epochs_3(end + 1) = EEG.event(i).epoch;
        end
    end
    
    % perform fourier transform over timepoints for condition 1
    chanpowr_1 = ( 2*abs( fft(EEG.data(:,:,epochs_1),[],2) )/EEG.pnts ).^2;
    
    % average over trials
    chanpowr_1 = mean(chanpowr_1,3);
    
    % vector of frequencies
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    
    % plot power spectrum of all channels low freq
    subplot(234)
    plot(hz,chanpowr_1(:,1:length(hz)),'linew',2)
    title(string(params.low_freq) + "Hz trials, all channels")
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 55],'ylim',[0 20])
    
    
    % perform fourier transform over timepoints for condition 3
    chanpowr_3 = ( 2*abs( fft(EEG.data(:,:,epochs_3),[],2) )/EEG.pnts ).^2;
    
    % average over trials
    chanpowr_3 = mean(chanpowr_3,3);
    
    % vector of frequencies
    hz = linspace(0,EEG.srate/2,floor(EEG.pnts/2)+1);
    
    % plot power spectrum of all channels high freq
    subplot(235)
    plot(hz,chanpowr_3(:,1:length(hz)),'linew',2)
    title(string(params.high_freq) + "Hz trials, all channels")
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 55],'ylim',[0 20])

    subplot(236)
    plot(hz,mean(chanpowr_1(:,1:length(hz)),1),'linew',2,'DisplayName', string(params.low_freq) + "Hz" )
    hold on
    plot(hz,mean(chanpowr_3(:,1:length(hz)),1),'linew',2, 'DisplayName',string(params.high_freq) + "Hz")
    title("Mean all channels " + string(params.low_freq) + "hz trials "+ " and "+ string(params.high_freq) + "hz trials")
    xlabel('Frequency (Hz)'), ylabel('Power (\muV)')
    set(gca,'xlim',[0 20],'ylim',[0 15])
    legend

    %% save figure
    filename = sprintf("%s\\img\\%s%s.fig", params.paths.results, EEG.setname, timestamp);
    saveas(gcf, filename);