% Stand alone:
% File: estimates the range the uwb radar can spot based on power used to send out signal.

lambda = 0.06972; RNG = 0:25; Pt = 0.00354834; 
    tau = 1e-9; RCS = 0.0729; G = 1;  
    pt = 0.00354834;
    r=1:0.1:25;
    pe = pt*(exp(2.7)/20)^2*RCS*lambda^2./((4*pi)^3.*r.^4);
    pem = pt*(exp(2.7)/20)^2*RCS*lambda^2./((4*pi)^3.*r.^2);
    y = 1./r.^4;
    
    figure, plot(r,1./pe,'r:',r,1./pem);
