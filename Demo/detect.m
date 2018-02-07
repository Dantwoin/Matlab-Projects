function detectList = detect(ENV,param,mode,k)
% DETECT
% Input
% ENV - Enveloped Scan.
% param - list of parameters preset for radar
% mode - 
%       Likely-hood-Detector
%        (0) Flat Threshold
%        (1) Gaussian Test of Mean 
% k - used in calculating the threshold alpha
%
% OUTPUT
% detectList - List of detections used to build detection track
persistent scnTH
persistent check
persistent mem
persistent memDepth

if isempty(mem)&& (mode == 5)
  memDepth = 100;                          
  mem = zeros(memDepth,size(ENV,2));           
elseif isempty(scnTH) || ~(check == mode)
    length = param.Nbin;
    check = mode;
    scnTH = zeros(1,length);
    n = 1:length;
    switch mode
        case 0
            scnTH = k*ones(1,length); % Flat Threshold
        case 1
            scnTH = k./n.^(.5); % Gaussian Test of Mean
        case 2
            scnTH = (k-n)./(2.*n).^(.5); % Gaussian Test of the Variance
        case 3
            scnTH = (k - n)./(n).^(.5); % Gaussian Test Exponential
        case 4
            scnTH = (k - n.*(((pi)^.5)/2))./(n.*(1-pi/4)).^.5; % Log Test                               
    end
end

if mode == 5                     
 % Move the scans up a notch and replace last with new scan
  mem(1:memDepth-1,:) = mem(2:memDepth,:);
  mem(memDepth,:) = ENV;                      

  y = k + std(mem);          
else
  y = scnTH+std(ENV);
end                              

Indx = ENV >= y; % find points ebove threshold
detectList = param.Rbin(Indx);
end