
    %%print mAP
    figure(1); clf;
    for i=1:numDet-1
        plot(mAP(:,i));
        hold on
    end
    plot(mAP(numDet,:));
    ax = gca;
    ax.XTick = 1:numSets;
    ax.XTickLabels = labels;
    set(gca, 'XTickLabelRotation', 45)
    legend(featExtractors{1}.Name,...
        featExtractors{2}.Name,featExtractors{3}.Name, ....
        featExtractors{4}.Name,featExtractors{5}.Name, ...
        'Location','northoutside', ...
        'Orientation','horizontal');
    
    xlabel('%filesize');
    ylabel('mAP');