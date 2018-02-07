dot = 0.8;
Hfig = figure('Units','normalized','Position',[0.1 0.1 0.6 dot],'Color','w', ...
  'MenuBar','none','Name','MRM Demo','NumberTitle','off', ...
  'KeyPressFcn',@fig_cbk,'UserData',true);
hold on
grid on
axis equal
xlim([-param.Rstp param.Rstp])
ylim([0 param.Rstp])
set(gca,'XTick',-param.Rstp:1:param.Rstp,'YTick',0:1:param.Rstp)
xlabel('x (m)')
ylabel('y (m)')
set(gca,'Color',[0.6 0.6 0.6])

if param.Fimg
  Himg = make_image(param);
end

%A = -90:5:90;
A = -90:15:90;
%R = [0.5 8];
R = [1 param.Rstp+2];
for i = 1:length(A)
  plot(R*sind(A(i)),R*cosd(A(i)),'Color',[dot dot dot],'LineStyle',':','Marker','none')
end

A = -90:1:90;
%R = 0.5:0.5:8;
R = 1:1:param.Rstp+2;
for i = 1:length(R)
  plot(R(i)*sind(A),R(i)*cosd(A),'Color',[dot dot dot],'LineStyle',':','Marker','none')
end

% Place dots for radars 
plot(param.Drdr/2*[-1 1],[0 0],'Color','k','Marker','.','MarkerSize',28,'LineStyle','none')
 
% Place 2 black lines . 
plot(-1*ones(1,2),[0 param.Rstp],'Color','k','LineStyle','-','LineWidth',2,'Marker','none')
plot(1*ones(1,2),[0 param.Rstp],'Color','k','LineStyle','-','LineWidth',2,'Marker','none')

Htrk = plot(nan,nan,'Color','r','Marker','.','MarkerSize',32,'LineStyle','none');