clear all;
f = open(fullfile('jxr_qap.fig'));
figure(f);
axh = findobj( gcf, 'Type', 'Axes' );



for i=1:length(axh)
    t = get(axh(i), 'Title');
    Titles{i}=t.String;
    Data = get(axh(i), 'Children');
    ZData = get(Data,'ZData');
    for j=1:length(ZData)
        z(j,:)=ZData{j}(2:6:end,2:4:end);
    end
    Z{i}=z(:,1:end-1);
end
clf;

for i=1:length(axh)
    figure();
    h = surf(Z{i});
    title(Titles{i},'FontSize',26)
    view(180,90);
    ax = gca;
    ylim([1 18]);
    ylabel('Query','FontSize',20);
    xlabel('Ratio','FontSize',20);
    ax.XTickLabel = fliplr(2.^[1:8]);
    ax.XTick = 1:9;
    colorbar('Ticks',[0,0.25,0.5,0.75,1])
end