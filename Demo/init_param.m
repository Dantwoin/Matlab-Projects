% broadspecs
param.Rstrt = 0.34;  % m
param.Rstp = 25;  % m


% horns

% param.Rdly = 0.56;  % m (approximate internal, cable, and antenna)
param.Rdly = 0;

param.Gtx = [42 42];
param.PII = 11;

param.Rbin = [];  % m
param.Nbin = [];

param.Drdr = 0.5;  % m

param.maxAerr = 15*pi/180;  % rad
param.minRdelta = 0.1;  % m

param.Xcal = 0;  % m
param.Ycal = 0.5;  % m
param.Zcal = 0;  % m

param.d1 = 0.5;  % m
param.d2 = 0;  % m
param.d3 = 0;  % m

param.Rcal = [0 0];  % m

param.Fimg = true;
param.Dimg = 0.08;
param.IMGmax = 1;
param.IMGcmap = @jet;

param.Fsoln = false;

% Find the indices of the scan data
[T1,T2,R1,R2,Rbin,Nbin] = rdr_scn_setup(param.Rstrt,param.Rstp);

SCNmsgNbin = 350;  % number of bins in each message (see API)
USBpfxNbyt = 4;
CFRMmsgNbyt = 8;
SCNmsgNbyt = 1452;

Nmsg = ceil(Nbin/SCNmsgNbin);
param.totNbyt = USBpfxNbyt + CFRMmsgNbyt + Nmsg*(USBpfxNbyt + SCNmsgNbyt)
%param.totNbyt = 2924;

% Iscn must be sized 4*Nbin.
% Iscn dictates which values go to what range bin. 
% The numbers in Iscn are deceptively important. 

if Nbin <= 350
  Iscn = [69:1468];
elseif Nbin <=700
  Iscn = [69:1468 1525:2924];
else
  Iscn = [69:1468 1525:2924 2981:4380 4437:5836 5893:7292 7349:8748 8805:10204 10261:11660];
end
param.Iscn = reshape(flipud(reshape(Iscn,4,[])),1,[]);
%param.Iscn = param.Iscn(1:4*Nbin);

% param.log_filename = [];


