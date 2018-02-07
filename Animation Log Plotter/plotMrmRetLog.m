% plotMrmRetLog.m
% This script prompts the user for a MRM-RET logfile, reads, parses, and
% produces a plot of the raw data. It should of the motion filtered scans and detection lists 
% in the logfile
clear all; close all; clc

%% Query user for logfile
%dnm = '.'; fnm = 'MRM_002.csv';
[fnm,dnm] = uigetfile('*.csv');
fprintf('Reading logfile %s\n',fullfile(dnm,fnm));
[cfg,req,scn,det] = readMrmRetLog(fullfile(dnm,fnm));

%% Separate raw, bandpassed, and motion filtered data from scn structure
% (only raw filtered is used)

% Pull out the raw scans (if saved)
rawScanI = find([scn.Nfilt] == 1);
rawScanV = reshape([scn(rawScanI).scn],[],length(rawScanI))';

%% Compute and plot data logged in amplitude/range plot. 

%STATIC VARIABLES
C_mps = 299792458; % Speed of light in mps
scanRes_ps = 61; % 61 picoseconds between each data point (from API.) Used for plotting.
  
% Initalizing Memory for Variables

loopI=1; % This is the loop and scan index.
         % to starts from 1 and increments up to the last logged
         % file
         
slength=1; % Length of the scan samples. IE. How many samples are in the scan.
getSize=size(rawScanV);
maxI=getSize(1); % Number of scans taken. 

%Note: I create an animation by looping through the raw scans logged in the log file.

while loopI<maxI
    
    tStart = tic;
    slength=length(rawScanV);   % adjust sample size
    
% Process the scan depending on the loop iteration
%
% In iteration 1 save the scan as a reference template
% Note: the first scan is lousy for some reason, so changed to scan2
  if loopI == 2;
    %maxMag = max(abs(scanRaw));
    scanScaleFactor = 100.0/max(abs(rawScanV(loopI,:)));
    scanTemplate = scanScaleFactor*rawScanV(loopI,:);
    distanceAxis_m = ([0:length(rawScanV(loopI,:))-1]*scanRes_ps/1e12)*C_mps/2;  % scanIndex*(61ps/step)/(ps/sec)*(meters/sec)/2 (round trip)
    hold off;
    plot(distanceAxis_m,scanTemplate,'Color',[0.5 0.5 0.5]);
    axis tight;
    xlabel('Distance (m)');
    ylabel('Signal Strength');
  end
  
  % On iteration 2 compute and plot the delta between raw and template
  % Low-pass filter the absolute value to estimate an envelope
  if loopI == 3
    scanLen = length(rawScanV(loopI,:));
    scanDelta = abs(scanScaleFactor*rawScanV(loopI,:) - scanTemplate);
    scanEnvelope = movingAvg(scanDelta);
    minThreshold = 3*[scanEnvelope + std(scanDelta)];
    scanThreshold = (100./[1:scanLen].^0.6) + minThreshold; % add 1/r^alpha. adjust alpha until it looks right.
    hold on
    plot(distanceAxis_m,scanThreshold,'r--');
    hEnv = plot(distanceAxis_m,scanEnvelope,'b');
    hDetList = plot(distanceAxis_m(1:scanLen),zeros(1,scanLen),'r.');  % Do this to set up detection list update
    legend('Raw Scan','Threshold','Enveloped Scan','Detection List');
  end
  
  % From now on compute and plot delta scan and detection list
  if loopI >= 4
    scanDelta = abs(scanScaleFactor*rawScanV(loopI,:) - scanTemplate);
    scanEnvelope = fir_lpf_ord5(scanDelta);
    detectionI = find(scanEnvelope > scanThreshold);
    detectionV = scanEnvelope(detectionI);

    set(hEnv,'YData',scanEnvelope);
    set(hDetList,'XData',distanceAxis_m(detectionI),'YData',detectionV);

    tElapsed = toc(tStart)*1000;
   
    if length(detectionI) >= 3
      distance1 = distanceAxis_m(detectionI(1));
      sigStr1 = sum(scanEnvelope(detectionI(1:3)));
    end
    
  end    
  
  drawnow;
  loopI=mod((loopI+1),(maxI));
end
%% ADDITIONAL IMPROVEMENTS
% Compute and plot data in 2D space
%

Fpls = 80;  % Hz
Tpls = 1e6/Fpls;  % us
Ffft = (-Nfft/2:Nfft/2-1)*Fpls/Nfft;

figure('Units','normalized','Position',[0.1 0.1 0.8 0.8],'Color','w')

Himg = image(Ffft,Rbin,ones(Nbin,Nfft));

hold on
grid on
xlabel('Doppler (Hz)')
ylabel('range (m)')
set(gca,'YDir','normal')

for k = 1:Nrqst
  SCN=rawScanV;
  IQ = hilbert(double(SCN'));
  
  fftSCN = fft(IQ,Nfft,2);
  fftSCN = abs(fftSCN);
  fftSCN(:,1) = 0;
  fftSCN = fftshift(fftSCN,2);
  fftSCN = min(round(63*fftSCN/1.6e5) + 1,64);
  
  set(Himg,'CData',fftSCN)
end
