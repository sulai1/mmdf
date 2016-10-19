figure(1);
open('jpg_map.fig')
ax = gca;
data = get(ax,'Children');

phow{1} = fliplr(data(1).YData);
orb{1} = fliplr(data(2).YData);
sift{1} = fliplr(data(3).YData);
surf{1} = fliplr(data(4).YData);

clf;

figure(1);
open('jxr_map.fig')
ax = gca;
data = get(ax,'Children');

phow{2} = fliplr(data(1).YData);
orb{2} = fliplr(data(2).YData);
sift{2} = fliplr(data(3).YData);
surf{2} = fliplr(data(4).YData);

clf;

figure(1);
open('jp2_map.fig')
ax = gca;
data = get(ax,'Children');

phow{3} = fliplr(data(1).YData);
orb{3} = fliplr(data(2).YData);
sift{3} = fliplr(data(3).YData);
surf{3} = fliplr(data(4).YData);
clf;

%% replot
figure(1);clf;
plot(phow{1}, 'Linewidth',3);
hold on;
plot(phow{2}, 'Linewidth',3);
hold on;
plot(phow{3}, 'Linewidth',3);

title('PHOW');
ylabel('MAP');
xlabel('Ratio');
ax = gca;
set(ax,'FontSize',18);
set(gca,'XTickLabel',[2,4,8,16,32,64,128,256,512,1024,2048] );
legend('JPEG','JPEG-XR','JPEG-2000','Location', 'southwest');

figure(2);clf;
plot(orb{1}, 'Linewidth',3);
hold on;
plot(orb{2}, 'Linewidth',3);
hold on;
plot(orb{3}, 'Linewidth',3);

title('ORB');
ylabel('MAP');
xlabel('Ratio');
ax = gca;
set(ax,'FontSize',18);
set(gca,'XTickLabel',[2,4,8,16,32,64,128,256,512,1024,2048] );
legend('JPEG','JPEG-XR','JPEG-2000','Location', 'southwest');



figure(3);clf;
plot(sift{1}, 'Linewidth',3);
hold on;
plot(sift{2}, 'Linewidth',3);
hold on;
plot(sift{3}, 'Linewidth',3);

title('SIFT');
ylabel('MAP');
xlabel('Ratio');
ax = gca;
set(ax,'FontSize',18);
set(gca,'XTickLabel',[2,4,8,16,32,64,128,256,512,1024,2048] );

legend('JPEG','JPEG-XR','JPEG-2000','Location', 'southwest');

figure(4);clf;
plot(surf{1}, 'Linewidth',3);
hold on;
plot(surf{2}, 'Linewidth',3);
hold on;
plot(surf{3}, 'Linewidth',3);

title('SURF');
ylabel('MAP');
xlabel('Ratio');
ax = gca;
set(ax,'FontSize',18);
set(gca,'XTickLabel',[2,4,8,16,32,64,128,256,512,1024,2048] );

legend('JPEG','JPEG-XR','JPEG-2000','Location', 'southwest');
