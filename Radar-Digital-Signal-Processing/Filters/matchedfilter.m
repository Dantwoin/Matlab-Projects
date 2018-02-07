function Y = matchedfilter(X)

% From funky fractus w/ FR4 dielectric-filled backreflector
% H_template = [-0.01614 -0.02726 0.0043323 0.110619 -0.0115698 -0.130454 ...
%   -0.0121927 0.0446573 0.142988 0.0526065 -0.227171 -0.12215 0.16459 ...
%   0.223785 -0.070985 -0.269889 -0.122745 0.161684 0.248545 0.0459951 ...
%   -0.226775 -0.205635 0.05301 0.220264 0.15149 -0.0726883];

% From Backreflected Broadspecs
H_template = [0.0487 -0.1283 -0.1200 0.2913 0.1990 -0.5646 -0.1674 ...    
   0.8045 0.1614 -0.9717 -0.0696 1.0000 0.2143 -0.8394 -0.1224 0.7399 ...    
   0.0461 -0.3810 0.0051];

% Normalize Signal
H_template = H_template/max(abs(H_template));
Y = filter(H_template,1,X);
end  