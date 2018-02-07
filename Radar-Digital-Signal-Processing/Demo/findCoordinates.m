function [x, y] = findCoordinates(param, aRdr, bRdr)
% FINDCOORDINATES - Uses Leading Edge Detection to find cartesian
% coordinates for the detection lists of the radar.
%
% Input
% param = radar settings
% aRdr = SCAN 1 detection List
% bRdr = SCAN 2 detecton List
%
% Output
% x = x track
% y = y track
       
       aRdr = aRdr(aRdr>0.43);
       bRdr = bRdr(bRdr>0.43);
       
       if any(isempty(aRdr))||any(isempty(bRdr))
          x = [];
          y = [];
          return
       end
        d1 = length(aRdr);
        d2 = length(bRdr);
        if d1 == d2
            r1 = aRdr;
            r2 = bRdr;
        else
        lensum =d1+d2;
        
        atest = nan(1,lensum);
        btest = nan(1,lensum);
        
        atest(1,1:d1) = aRdr;
        btest(1,1:d2) = bRdr;
        
       % Check how close the values are to each other.  If they are not
       % within tolerance, they can not be paired together.  
       for k = 1:lensum-1
             val = abs(atest(1,k) - btest(1,k)) < param.Drdr;
           if val~=1
                if d1<d2
                    if (atest(1,k) < btest(1,k+1))
                        atest(1,k:lensum) = [nan atest(1,k:lensum-1)];
                    else
                        atest(1,k) = nan;
                    end
                else
                    if (btest(1,k) < atest(1,k+1))
                        btest(1,k:lensum) = [nan btest(1,k:lensum-1)];
                    else
                        btest(1,k) = nan;
                    end
                end
                
           end
       end
   
        r1 = atest;
        r2 = btest;
        end
        
        x = (r1.^2-r2.^2+param.Drdr^2)./(2*param.Drdr);
        y = abs(sqrt(r1.^2-x.^2));
        
        x = x(~isnan(x));
        y = y(~isnan(y));
end
