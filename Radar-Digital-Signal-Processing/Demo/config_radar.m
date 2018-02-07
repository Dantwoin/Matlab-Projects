function param = config_radar(srl,param)


[T1,T2,R1,R2,Rbin,Nbin] = rdr_scn_setup(param.Rstrt,param.Rstp);

param.Rbin = Rbin - param.Rdly;  % m
param.Nbin = Nbin;
param.Iscn = param.Iscn(1:4*Nbin); %%%%% TEST 

Nrdr = length(srl);

for n = 1:Nrdr
  chng_cfg(srl(n),[T1 T2],param.Gtx(n),param.PII)
end
