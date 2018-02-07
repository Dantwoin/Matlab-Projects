function demo_2d(srl,param,log_file)
% USER SETTINGS
memDepth = 2;
detectMode = 5;
threshold = 10^-1;
F0t = 10.1604/1.96;
%

Nrdr = length(srl);
initializeFig();

SCN = struct('rawSCN',zeros(1,param.Nbin),...
             'SCN',zeros(1,param.Nbin),...
             'mtiMEM',[],...
             'ENV',zeros(1,param.Nbin),...
             'detectList',nan(1,param.Nbin));
         
while get(Hfig,'UserData')
  for n = 1:Nrdr
    [scn,log_end] = get_scans(srl(n),param,log_file);
    if log_end == true
        set(Hfig,'UserData',false)
        break;
    end
    
    SCN(n).rawSCN = double(scn);
  end
  
  if log_end == true
    set(Hfig,'UserData',false)
    break;
  end
  
  for n = 1:Nrdr      
        % Normalize scan
        scn=SCN(n).rawSCN/max(max(abs(SCN(n).rawSCN)));
        % Match Filter Scan
        SCN(n).SCN = matchedfilter(bpscn);
        % MTI Filter scan
        [dSCN,SCN(n)]=motionFilter(SCN(n),memDepth);
        % Lowpass Filter scan
        SCN(n).ENV = envelope(dSCN);
        % Create detection track for scan
        SCN(n).detectList = detect(SCN(n).ENV,param,detectMode,threshold);
  end
  
  set(Htrk,'XData',nan,'YData',nan)  
  
  Xtrk = nan(1,4);
  Ytrk = nan(1,4);
  Ztrk = nan(1,4);
   
  % Correlate detection tracks to produce cartesian tracks
  [Xtrk,Ytrk] = findCoordinates(param,SCN(1).detectList,SCN(2).detectList);
  set(Htrk,'XData',Xtrk,'YData',Ytrk);
  if param.Fimg
     make_image(param,Himg,[SCN(1).ENV; SCN(2).ENV]);
  end
end
delete(Hfig)