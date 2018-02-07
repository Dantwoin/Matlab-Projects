function Himg = make_image(param,varargin)

switch nargin
  case 1
    x = xlim;
    y = ylim;
    
    x = x(1):param.Dimg:x(2);
    y = y(1):param.Dimg:y(2);
    
    Nx = length(x);
    Ny = length(y);
    
    IMG = zeros(Ny,Nx);
    
%     Himg = imagesc(x,y,IMG);
    Himg = imagesc(x,y,IMG,[0 param.IMGmax]);
    
    [Y,X] = ndgrid(y,x);
    
    R1 = sqrt((X + param.Drdr/2).^2 + Y.^2);
    R2 = sqrt((X - param.Drdr/2).^2 + Y.^2);
    
    I1 = round(interp1(param.Rbin+param.Rcal(1),1:param.Nbin,R1));
    I2 = round(interp1(param.Rbin+param.Rcal(2),1:param.Nbin,R2));
    
    set(Himg,'UserData',{Nx Ny I1 I2 R1 R2 X Y});
    
    if ~isempty(param.IMGcmap)
      colormap(feval(param.IMGcmap));
    end
    
    uistack(Himg,'bottom')
    set(gca,'Layer','top')
    
  case 3
    Himg = varargin{1};
    ENV = varargin{2};

    udat = get(Himg,'UserData');
    Nx = udat{1};
    Ny = udat{2};
    I1 = udat{3};
    I2 = udat{4};
    R1 = udat{5};
    R2 = udat{6};
    
    IMG = zeros(Ny,Nx);
    for i = 1:Ny
      for j = 1:Nx
        if I1(i,j) >= 0 && I1(i,j) <= param.Nbin
          %IMG(i,j) = IMG(i,j) + ENV(1,I1(i,j));
          IMG(i,j) = IMG(i,j) + ENV(1,I1(i,j))*R1(i,j);
        end
        if I2(i,j) >= 0 && I2(i,j) <= param.Nbin
          %IMG(i,j) = IMG(i,j) + ENV(2,I2(i,j));
          IMG(i,j) = IMG(i,j) + ENV(2,I2(i,j))*R2(i,j);
        end
      end
    end
    set(Himg,'CData',IMG);
end

