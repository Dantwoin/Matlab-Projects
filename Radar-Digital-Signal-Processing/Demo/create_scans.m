function SCN = create_scans(srl,param)


%totNbyt = 4380;  % 8m scan
%totNbyt = 2924;

ctl_rqst(srl,1,0,1)

Ktry = 0;

while srl.BytesAvailable < param.totNbyt && Ktry <= 100
  
  Ktry = Ktry + 1;
  
  pause(0.0001)
  
end

if Ktry <= 100
  
  msg = uint8(fread(srl,srl.BytesAvailable,'uint8'));
  
  SCN = typecast(msg(param.Iscn),'int32')';
  
else
  fprintf('Scan data not returned.')
  
end

%{
SCNmsgNbin = 350;  % number of bins in each message (see API)
USBpfxNbyt = 4;
CFRMmsgNbyt = 8;
SCNmsgNbyt = 1452;

Nmsg = ceil(param.Nbin/SCNmsgNbin);
totNbyt = USBpfxNbyt + CFRMmsgNbyt + Nmsg*(USBpfxNbyt + SCNmsgNbyt)

ctl_rqst(srl,1,0,1)

Ktry = 0;

while srl.BytesAvailable < totNbyt && Ktry <= 10
  
  Ktry = Ktry + 1;
  
  pause(0.0001)
  
end

if Ktry <= 10
  
  msg = uint8(fread(srl,srl.BytesAvailable,'uint8'));
  
  Ibyt = 1;
  
  Ibyt = Ibyt + USBpfxNbyt;
  [str,msg_typ,msgID] = parse_msg(msg(Ibyt:Ibyt+CFRMmsgNbyt-1));
  Ibyt = Ibyt + CFRMmsgNbyt;
  
  SCN = [];
  
  for n = 1:Nmsg
    Ibyt = Ibyt + USBpfxNbyt;
    [str,msg_typ,msgID] = parse_msg(msg(Ibyt:Ibyt+SCNmsgNbyt-1));
    Ibyt = Ibyt + SCNmsgNbyt;
    
    SCN = [SCN str.scanData(1:str.messageSamples)];
  end
  
  Iscn = [69:1468 1525:2924 2981:3636];
  Iscn = reshape(flipud(reshape(Iscn,4,[])),1,[]);
  scn = typecast(msg(Iscn),'int32')';
  
else
  fprintf('Scan data not returned.')
  
end
%}
