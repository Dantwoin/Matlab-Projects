function [Rbin,Nbin]=estRadarRequirements(T1,T2)
% estRadarRequiments Function sets uses radar theory to calculate Range of
% the radar sample and additional snippets below
%
% Syntax
% [T1,T2,R1,R2,Rbin,Nbin] = rdr_scn_setup(R1,R2)
%
% Input
% R1 - start range (m)
% R2 - stop range (m)
%
% Output
% T1 - start time (ns)
% T2 - stop time (ns)
% R1 - start range (m) [adjusted]
% R2 - stop range (m) [adjusted]
% Rbin - scan range array (m)
% Nbin - number of scan bins
%
% Usage Notes