figure(1);clf;
open('jp2_map.fig');
axh = gca;

Data = get(axh, 'Children');
z = get(Data,'YData');
figure(2);clf
for i=1:length(z)
    plot(fliplr(z{i}),'LineWidth',4);
    grid on
    hold on
end
ax = gca;
ax.XTickLabels = 2.^[1:10];
    ylabel('MAP','FontSize',20);
    xlabel('Ratio','FontSize',20);
    legend('PHOW','ORB','SIFT','SURF')