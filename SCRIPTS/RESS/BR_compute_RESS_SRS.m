function ress = BR_compute_RESS_SRS(EEG, params)
    
    peakfreq1 = params.low_freq; % hz
    peakfreq2 = params.high_freq; % hz
    
    tl = 150; % s Change this if using localizer task
    
    % parameters for RESS (How do you determine these values?)
    peakwidt  = .5; % FWHM at peak frequency 
    neighfreq = 2;  % distance of neighboring frequencies away from peak frequency, +/- in Hz
    neighwidt = 2;  % FWHM of the neighboring frequencies
                
    % FFT parameters
    tl_start = 2000;% (ms) start 2 seconds after trial starts
    tl_stop = ((tl-2)*1000)-2; % (ms) end 2 seconds before trial ends 
    nfft = ceil(EEG.srate/.1 ); % .1 Hz resolution (Why 0.1 Hz resolution though?)
                
    % Identify the index of nearest points to the starting and ending
    % timepoints on EEG.times (matrix which contains all the
    % timepoints of measurement) 
    tidx = dsearchn(EEG.times',[tl_start tl_stop]'); 
    
    % extract EEG data
    data  = EEG.data;
    dataX = mean(abs( fft(data(:,tidx(1):tidx(2),:),nfft,2)/diff(tidx) ).^2,3);
    hz    = linspace(0, EEG.srate, nfft);
    ress.hz = hz;
    hzindex1 = (peakfreq1*10)+1;
    hzindex2 = (peakfreq2*10)+1;
                
    %% FREQUENCY 1
    % compute covariance matrix at peak frequency
    fdatAt = filterFGx(data, EEG.srate, peakfreq1, peakwidt, 1);
    fdatAt = reshape( fdatAt(:,:,:), EEG.nbchan,[] );
    fdatAt = bsxfun(@minus,fdatAt,mean(fdatAt,2));
    covAt  = (fdatAt*fdatAt')/diff(tidx);
    
    % compute covariance matrix for lower neighbor
    fdatLo = filterFGx(data, EEG.srate, peakfreq1-neighfreq, neighwidt, 1);
    fdatLo = reshape( fdatLo(:,:,:), EEG.nbchan,[] );
    fdatLo = bsxfun(@minus,fdatLo,mean(fdatLo,2));
    covLo  = (fdatLo*fdatLo')/diff(tidx);
    
    % compute covariance matrix for upper neighbor
    fdatHi = filterFGx(data, EEG.srate, peakfreq1+neighfreq, neighwidt, 1);
    fdatHi = reshape( fdatHi(:,:,:), EEG.nbchan,[] );
    fdatHi = bsxfun(@minus,fdatHi,mean(fdatHi,2));
    covHi  = (fdatHi*fdatHi')/diff(tidx);
    
    % perform generalized eigendecomposition. This is the meat & potatos of RESS
    [evecs,evals] = eig(covAt,(covHi+covLo)/2);
    [~,comp2plot] = max(diag(evals)); % find maximum component
    evecs = bsxfun(@rdivide,evecs,sqrt(sum(evecs.^2,1))); % normalize vectors (not really necessary, but OK)
    
    % extract components and force sign
    maps = covAt * evecs / (evecs' * covAt * evecs); % this works either way
    [~,idx] = max(abs(maps(:,comp2plot))); % find biggest component
    maps = maps * sign(maps(idx,comp2plot)); % force to positive sign
    
    % DAPH 
    % [d,sidx] = sort(diag(evals),'descend');
    % plot(d,'ks-','markerfacecolor','w','linew',2,'markersize',13)
    
    % reconstruct RESS component time series
    ress_ts1 = zeros(EEG.pnts,size(data,3));
    for ti=1:size(data,3)
        ress_ts1(:,ti) = evecs(:,comp2plot)'*squeeze(data(:,:,ti));
    end
    ress.ts1 = ress_ts1;
    ress.ts1_vec = evecs(:,comp2plot)';
    
    % reconstruct RESS component power series
    wi = 3; % hz
    fdatAt = filterFGx(data, EEG.srate, peakfreq1, wi); % narrowband filter
    fdatAt = reshape( fdatAt(:,:,:), EEG.nbchan,[] );
    fdatAt = bsxfun(@minus,fdatAt,mean(fdatAt,2));
    ress_ts1_power = zeros(length(fdatAt),size(fdatAt,3));
    for ti=1:size(fdatAt,3)
        ress_ts1_power(:,ti) = evecs(:,comp2plot)'*squeeze(fdatAt(:,:,ti));
    end
    ress.ts1_power = ress_ts1_power;
    
    % compute SNR spectrum
    ressx = mean(abs( fft(ress_ts1(:,:),nfft,1)/diff(tidx) ).^2,2);
    snrR = zeros(size(hz));
    skipbins =  5; % .5 Hz, hard-coded!
    numbins  = 20+skipbins; %  2 Hz, also hard-coded!
    % loop over freqs to compute SNR
    for hzi=numbins+1:length(hz)-numbins-1
        numer = ressx(hzi);
        denom = mean( ressx([hzi-numbins:hzi-skipbins hzi+skipbins:hzi+numbins]) );
        snrR(hzi) = numer./denom;
    end
    ress.snr1 = snrR;
    ress.fr1_map2plot1 = maps(:,comp2plot);
    ress.fr1_map2plot2 = dataX(:,dsearchn(hz',peakfreq1));
    
    %% FREQUENCY 2
    % compute covariance matrix at peak frequency
    fdatAt = filterFGx(data, EEG.srate, peakfreq2, peakwidt);
    fdatAt = reshape( fdatAt(:,:,:), EEG.nbchan,[] );
    fdatAt2 = fdatAt;
    fdatAt = bsxfun(@minus,fdatAt,mean(fdatAt,2));
    covAt  = (fdatAt*fdatAt')/diff(tidx);
    
    % compute covariance matrix for lower neighbor
    fdatLo = filterFGx(data, EEG.srate, peakfreq2-neighfreq, neighwidt);
    fdatLo = reshape( fdatLo(:,:,:), EEG.nbchan,[] );
    fdatLo = bsxfun(@minus,fdatLo,mean(fdatLo,2));
    covLo  = (fdatLo*fdatLo')/diff(tidx);
    
    % compute covariance matrix for upper neighbor
    fdatHi = filterFGx(data, EEG.srate, peakfreq2+neighfreq, neighwidt);
    fdatHi = reshape( fdatHi(:,:,:), EEG.nbchan,[] );
    fdatHi = bsxfun(@minus,fdatHi,mean(fdatHi,2));
    covHi  = (fdatHi*fdatHi')/diff(tidx);
    
    % perform generalized eigendecomposition. This is the meat & potatos of RESS
    [evecs,evals] = eig(covAt,(covHi+covLo)/2);
    [~,comp2plot] = max(diag(evals)); % find maximum component
    evecs = bsxfun(@rdivide,evecs,sqrt(sum(evecs.^2,1))); % normalize vectors (not really necessary, but OK)
    
    % extract components and force sign
    maps = covAt * evecs / (evecs' * covAt * evecs); % this works either way
    [~,idx] = max(abs(maps(:,comp2plot))); % find biggest component
    maps = maps * sign(maps(idx,comp2plot)); % force to positive sign
    
    % reconstruct RESS component time series
    ress_ts2 = zeros(EEG.pnts,size(data,3));
    for ti=1:size(data,3)
        ress_ts2(:,ti) = evecs(:,comp2plot)'*squeeze(data(:,:,ti));
    end
    ress.ts2 = ress_ts2;
    ress.ts2_vec = evecs(:,comp2plot)';
    
    % reconstruct RESS component power series
    wi = 3; % hz
    fdatAt = filterFGx(data, EEG.srate, peakfreq2, wi); % narrowband filter
    fdatAt = reshape( fdatAt(:,:,:), EEG.nbchan,[] );
    fdatAt = bsxfun(@minus,fdatAt,mean(fdatAt,2));
    ress_ts2_power = zeros(length(fdatAt),size(fdatAt,3));
    for ti=1:size(fdatAt,3)
        ress_ts2_power(:,ti) = evecs(:,comp2plot)'*squeeze(fdatAt(:,:,ti));
    end
    ress.ts2_power = ress_ts2_power;
    
    % compute SNR spectrum
    ressx = mean(abs( fft(ress_ts2(:,:),nfft,1)/diff(tidx) ).^2,2);
    snrR = zeros(size(hz));
    skipbins =  5; % .5 Hz, hard-coded!
    numbins  = 20+skipbins; %  2 Hz, also hard-coded!
    % loop over freqs to compute SNR
    for hzi=numbins+1:length(hz)-numbins-1
        numer = ressx(hzi);
        denom = mean( ressx([hzi-numbins:hzi-skipbins hzi+skipbins:hzi+numbins]) );
        snrR(hzi) = numer./denom;
    end
    ress.snr2 = snrR;
    ress.fr2_map2plot1 = maps(:,comp2plot);
    ress.fr2_map2plot2 = dataX(:,dsearchn(hz',peakfreq2));
                
    %% SAVE RESS STRUCT
    save(strcat(params.paths.results, "\ress\", extractBefore(EEG.filename, '.set')), 'ress')
    
    
    
    

