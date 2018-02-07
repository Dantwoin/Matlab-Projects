function [dSCN,SCN]=motionFilter(SCN,memDepth)
% motionFilter MTI filter
%
% Input
% SCN  - Struct containing history of scans k to k-3
% memDepth - input values 1-3. Adjusts how many taps used by the filter 
%
% Output
% SCN  - Returns Struct with updated/shifted scans
% dSCN - MTI filtered scan returned

% Implement the Binomial MTI (Moving Target Indicator) filter

if isempty(SCN.mtiMEM)
  xN = length(SCN.SCN);
  SCN.mtiMEM = min(abs(SCN.SCN))*randn(memDepth,xN);
end

switch memDepth
  case 1
    H = [1 -1];  % Subtract previous
  case 2
    H = [1 -0.6 -0.4];
  case 3
    H = [1,-3,3,-1];
  case 4
    H = [1,-4,6,-4,1];
  otherwise
    error('Max motion memory depth is 4');
end
Xp = [SCN.SCN;SCN.mtiMEM];
H = H/max(abs(H));
dSCN = H*Xp;

% Update memory
SCN.mtiMEM(2:memDepth,:) = SCN.mtiMEM(1:memDepth-1,:);
SCN.mtiMEM(1,:) = SCN.SCN;

end
