function plot_continuous_data(EEG, params, fignum, timestamp)
% 
%     prompt = "Which channel nr do you want to plot? 6 [62]: ";
%     channel = input(prompt,"s");
% 
%     if string(channel) == ""
%         chan = 62;
%     else
%         chan = str2num(channel);
%     end
    
    figure(fignum), clf

    %% static power spectrum
    % first take FFT's of every trial, then average     
    hz = linspace(0,EEG.srate,EEG.pnts);
    if numel(size(EEG.data))==3
        pw = mean((2*abs(fft(EEG.data,[],2)/EEG.pnts)).^2,3);
    else
        pw = (2*abs(fft(EEG.data,[] ,2)/EEG.pnts)).^2;
    end

    subplot(234)
    plot(hz,pw,'linew',2)
    set(gca,'xlim',[0 30], 'ylim', [0 25])
    xlabel('Frequency (Hz)'), ylabel('Power')
    title('Static power all trials, all channels')
    
    %% topoplots
    
    % convert to indices
    freqidx_low = dsearchn(hz', params.low_freq);
    
    % extract average power
    low_freq = mean(pw(:,freqidx_low),2);
    
    % convert to indices
    freqidx_high = dsearchn(hz', params.high_freq);
    
    % extract average power
    high_freq = mean(pw(:,freqidx_high),2);
    
    % and plot
    subplot(231)
    all_freq = mean(pw, 2);
    topoplot(all_freq./max(all_freq),EEG.chanlocs, 'electrodes','numbers');
    set(gca,'clim',[-.9 .9])
    colorbar
    title('All Frequencies')

    subplot(232)
    topoplot(low_freq./max(low_freq),EEG.chanlocs,'electrodes','numbers');
     set(gca,'clim',[-.9 .9])
    colorbar
    title(string(params.low_freq) + ' hz')
    
    subplot(233)
    topoplot(high_freq./max(high_freq),EEG.chanlocs,'electrodes','numbers');
    set(gca,'clim',[-.9 .9])
    colorbar
    title(string(params.high_freq) + ' hz')


%     %% static power spectrum for specific channel
%     % first take FFT's of every trial, then average 
%     
%     hz = linspace(0,EEG.srate,EEG.pnts);
%     if numel(size(EEG.data))==3
%         pw = mean((2*abs(fft(EEG.data,[],2)/EEG.pnts)).^2,3);
%     else
%         pw = (2*abs(fft(EEG.data,[] ,2)/EEG.pnts)).^2;
%     end
% 
%     subplot(213)
%     hold on
%     plot(hz,pw(chan,:),'linew',2, 'DisplayName','all freq')
%     set(gca,'xlim',[4 9], 'ylim', [0 20])
%     xlabel('Frequency (Hz)'), ylabel('Power')
%     title(['Static power all trials channel: ' num2str(chan)])
%     legend

    %% save figure
    filename = sprintf("%s\\img\\%s%s.fig", params.paths.results, EEG.setname, timestamp);
    saveas(gcf, filename);



   
   