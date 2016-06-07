    %% read set sizes
    fid = fopen(fullfile('..','..','sizes.txt'));
    line = '.';
    lineindex = 1;
    sizes = zeros(1,20);
    while ischar(line)
        line = fgets(fid);
        isRightFormat = strfind(line,Format);
        if(isRightFormat>=0)
            k = strfind(line,' ');
            sizes(lineindex) = str2double(line(k+1:end));
            lineindex = lineindex +1;
        end
    end
    sizes = 389120./sizes(find(sizes));
    %% print mAP
    figure(1);clf;
    for i=1:numDet
        semilogx(fliplr(sizes),fliplr(mAP(2:end,i)));
        hold on
    end
    title('Detector MAP over Ratio: %s');
    ax = gca;
    ax.YLim = [0.7,0.95];
    ax.XLim = [sizes(1) sizes(end)];
    legend(detNames,'Location','northwest');
    disp('mAP');
    disp(mAP);
    
    %% print prc's
   rows = ceil(numDet/2.0);
   cols = 2;
   figure(2);clf;
   for i=1:numDet
        x = reshape(cell2mat({prcs{i,:}}),[length(prcs{1})],length({prcs{1,:}}));
        subplot(cols,rows,i);
        if(numSets<=1)
            plot(x);
        else
            surf(x);
            view([-1,1,1]);
        end
        title(sprintf(detNames{i}));
        ax = gca;
        ax.YTickLabel = [0:0.1:1];
        xlim(ax,[0,10])
        ax.XTickLabel = pow2(linspace(7,1,7));
   end
   