function demo_threshold(srl, param, log_file)

% USER SETTINGS
memDepth = 2;
detectMode = 5;
threshold = 2;
blindspot = [1:326 2250:2726];
F0t = 10.1604/1.96;
%

Hfig = figure('Units','normalized','Position',[0.1 0.1 0.6 0.8],'Color','w', ...
  'MenuBar','none','Name','MRM Demo','NumberTitle','off', ...
  'KeyPressFcn',@fig_cbk,'UserData',true);
subplot(2,1,1)
hold on
grid on
xlabel('range (m)')
ylabel('Signal Strength')
xlim([param.Rstrt param.Rstp])
%ylim([0 0.5])
envScan(1)=plot(param.Rbin,zeros(1,param.Nbin))
dList(1)=plot(param.Rbin,zeros(1,param.Nbin),'r')
subplot(2,1,2)
hold on
grid on
xlabel('range (m)')
ylabel('Signal Strength')
xlim([param.Rstrt param.Rstp])
%ylim([0 0.5])
envScan(2)=plot(param.Rbin,zeros(1,param.Nbin));
dList(2)=plot(param.Rbin,zeros(1,param.Nbin),'r');

Nrdr = length(srl);

SCN = struct('rawSCN',zeros(1,param.Nbin),...
             'SCN',zeros(1,param.Nbin),...
             'mtiMEM',[],...
             'ENV',zeros(1,param.Nbin),...
             'detectList',nan(1,param.Nbin));
        
while get(Hfig,'UserData')
%   t=tic;
  for n = 1:Nrdr
    [scn,log_end] = get_scans(srl(n),param,log_file);
    if log_end == true
        set(Hfig,'UserData',false)
        break;
    end
    
    SCN(n).rawSCN = double(scn);
  end
  
% F0t = 1.96*(toc(t)/2)^-1;

if log_end == true
    set(Hfig,'UserData',false)
    break;
end
      for n = 1:Nrdr
        % Normalize scan
        scn=SCN(n).rawSCN/max(max(abs(SCN(n).rawSCN)));
        % Match Filter Scan
        SCN(n).SCN = matchedfilter(scn);
        % MTI Filter scan
        [dSCN,SCN(n)]=motionFilter(SCN(n),memDepth);
        % Lowpass Filter scan
         eSCN = 2*pi*cos(F0t).*dSCN;
         I=envelope(eSCN.*2*pi*cos(F0t));
         Q=envelope(eSCN.*2*pi*sin(F0t));
         env= envelope((I.^2 + Q.^2).^0.5);
         SCN(n).ENV= env/max(env);
%         SCN(n).ENV = envelope(dSCN);
        % Create detection track for scan
        SCN(n).detectList = detect(SCN(n).ENV,param,detectMode,threshold);
        % Get Threshold
        scnTH = detectThreshold(SCN(n).ENV,param.Nbin,detectMode,threshold);

        % Plot Signals verse threshold
        subplot(2,1,n)
        set(envScan(n),'Ydata',SCN(n).ENV);
        set(dList(n),'Ydata',scnTH);
      end
      drawnow;
end
delete(Hfig)