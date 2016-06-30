clear all;
figure(f);
f = open(fullfile('t20_qap.fig'));
axh = findobj( gcf, 'Type', 'Axes' );


for i=1:length(axh)
    t = get(axh(i), 'Title');
    Titles{i}=t.String;
    Data = get(axh(i), 'Children');
    z = fliplr(get(Data,'YData'));
    Z{i}(:,1) = z;
    Z{i}(:,2) = z;
end
clf;

for i=1:length(axh)
    figure();
    h = surf(Z{i});
    title(Titles{i},'FontSize',26)
    view(180,90);
    ax = gca;
    ylim([1 18]);
    xlabel('Ratio','FontSize',20);
    ylabel('Query','FontSize',20);
    ax.XTickLabel = fliplr(2.^[1:8]);
    ax.XTick = 1:9;
    colorbar('Ticks',[0,0.25,0.5,0.75,1])
end