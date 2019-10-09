testPath = '\\hpcnas\dev\test_data\ravenx_data\test0041-SHRU\input'
input = ['example_data' filesep '05221228.D18'];
filename = fullfile(testPath, input);

recs = 1;    % 0~127, one SHRU file nominally contains 128 records, specify a record number 
chns = 0:3;  % extract all four channels  
[Data,t0,header] = shru.SHRU_getdata(filename,recs,chns);

fs = header.rhfs; %sampling frequency 
hydrophone_sensitivity = -170; % nominal hydrophone sensitivity, dBv/1microPa
Data = Data*10^(-hydrophone_sensitivity/20); 

% 
window = floor(1*fs);
nfft = window;
noverlap = floor(nfft/2);

for ich = 1:length(chns)
%     subplot(length(chns),1,ich)

subplot(4,2,2*ich-1);
plot(Data(:,1));
subplot(4,2,2*ich);

    
    [s,f,t,ps] = spectrogram(Data(:,ich),window,noverlap,nfft,fs);
    
    imagesc(t,f,10*log10(ps)); axis xy
    title(sprintf('CH#%d, T0=%s',ich-1,datestr(datenum(t0.yr-1,12,31)+t0.yday)))
    xlabel('Seconds after T0')
    ylabel('Freq (Hz)')
    caxis([40 100])
    ih = colorbar; set(get(ih,'ylabel'),'string','PSD (dB re 1\muPa^2/1Hz)')
    
end