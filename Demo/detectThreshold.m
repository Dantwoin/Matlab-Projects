function y = detectThreshold(ENV,length,mode,k )
%DETECTTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
persistent scnTH
persistent check
persistent mem
persistent memDepth
persistent alpha

if isempty(mem)&& (mode == 5)
  memDepth = 100;                          % BD
%   alpha= memDepth*(k^(-1/memDepth)-1);    % Automated CFAR rate
  mem = zeros(memDepth,size(ENV,2));      % BD   
  
elseif isempty(scnTH) || ~(check == mode)
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
if mode == 5                     % BD
 % Move the scans up a notch and replace last with new scan
  mem(1:memDepth-1,:) = mem(2:memDepth,:);    % BD
  mem(memDepth,:) = ENV;                      % BD
%   y = alpha + std(mem);          % BD
  y = k*mean(mem) + std(mem);
else 
  y = scnTH+std(ENV);

end                              % BD
  
end

