function BR_plot_RESS_component(EEG, params, ress)

    peakfreq1 = params.low_freq;
    peakfreq2 = params.high_freq;
    
    % compute SNR and best electrodes
    [~,hz1_index] = min(abs(peakfreq1-ress.hz));
    snr1 = ress.snr1(hz1_index);
    [~,hz2_index] = min(abs(peakfreq2-ress.hz));
    snr2 = ress.snr2(hz2_index);
    ress.SNR = [snr1 snr2];
    
    [~,ch1_index] = maxk(ress.fr1_map2plot1, 10);
    for i = 1:10
        chan1{i} = EEG.chanlocs(ch1_index(i)).labels;
    end
    [~,ch2_index] = maxk(ress.fr2_map2plot1, 10);
    for i = 1:10
        chan2{i} = EEG.chanlocs(ch2_index(i)).labels;
    end
    ress.chans = {chan1, chan2};
    
    % start plotting
    f = figure('visible', 'off');
    xlim = [5 10];
    
    subplot(231)
    plot(ress.hz,ress.snr1,'ro-','linew',1,'markersize',5,'markerface','w')
    set(gca,'xlim',xlim)
    xticks(5:0.5:10);
    axis square
    xlabel('Frequency (Hz)'), ylabel('SNR')
    
    subplot(232)
    map2plot = ress.fr1_map2plot1;
    topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits',[-.7 .7],'numcontour',0,'conv','on','electrodes','off','shading','interp');
    %topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits','maxmin','numcontour',0,'conv','on','electrodes','off','shading','interp');
    title([ 'RESS for ' num2str(peakfreq1) ' Hz' ])

    subplot(233)
    map2plot = ress.fr1_map2plot2;
    topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits',[-.7 .7],'numcontour',0,'conv','on','electrodes','off','shading','interp');
    %topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits','maxmin','numcontour',0,'conv','on','electrodes','off','shading','interp');
    title([ 'RESS for ' num2str(peakfreq1) ' Hz' ])
    title([ 'Electrode power at ' num2str(peakfreq1) ' Hz' ])
    
    subplot(234)
    plot(ress.hz,ress.snr2,'ro-','linew',1,'markersize',5,'markerface','w')
    set(gca,'xlim',xlim)
    xticks(5:0.5:10);
    axis square
    xlabel('Frequency (Hz)'), ylabel('SNR')

    subplot(235)
    map2plot = ress.fr2_map2plot1;
    topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits',[-.7 .7],'numcontour',0,'conv','on','electrodes','off','shading','interp');
    %topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits','maxmin','numcontour',0,'conv','on','electrodes','on','shading','interp');
    title([ 'RESS for ' num2str(peakfreq2) ' Hz' ])

    subplot(236)
    map2plot = ress.fr2_map2plot2;
    topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits',[-.7 .7],'numcontour',0,'conv','on','electrodes','off','shading','interp');
    %topoplot(map2plot./max(map2plot),EEG.chanlocs,'maplimits','maxmin','numcontour',0,'conv','on','electrodes','on','shading','interp');
    title([ 'RESS for ' num2str(peakfreq2) ' Hz' ])
    title([ 'Electrode power at ' num2str(peakfreq2) ' Hz' ])

    filename = sprintf("%s\\img\\%s_ress", params.paths.results, extractBefore(EEG.filename, '.set'));
    saveas(f, filename,'png');
