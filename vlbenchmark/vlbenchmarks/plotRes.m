    colors = {'y','m','c','r','b','g','w','k'};
cmap = ...
    [0.1451    0.2039    0.5804
    0.1469    0.2235    0.5898
    0.1488    0.2431    0.5992
    0.1506    0.2627    0.6086
    0.1524    0.2824    0.6180
    0.1542    0.3020    0.6275
    0.1561    0.3216    0.6369
    0.1579    0.3412    0.6463
    0.1597    0.3608    0.6557
    0.1616    0.3804    0.6651
    0.1634    0.4000    0.6745
    0.1652    0.4196    0.6839
    0.1671    0.4392    0.6933
    0.1689    0.4588    0.7027
    0.1707    0.4784    0.7122
    0.1725    0.4980    0.7216
    0.1771    0.5100    0.7242
    0.1817    0.5220    0.7268
    0.1863    0.5340    0.7294
    0.1908    0.5460    0.7320
    0.1954    0.5580    0.7346
    0.2000    0.5699    0.7373
    0.2046    0.5819    0.7399
    0.2092    0.5939    0.7425
    0.2137    0.6059    0.7451
    0.2183    0.6179    0.7477
    0.2229    0.6298    0.7503
    0.2275    0.6418    0.7529
    0.2320    0.6538    0.7556
    0.2366    0.6658    0.7582
    0.2412    0.6778    0.7608
    0.2458    0.6898    0.7634
    0.2503    0.7017    0.7660
    0.2549    0.7137    0.7686
    0.2800    0.7231    0.7644
    0.3051    0.7325    0.7603
    0.3302    0.7420    0.7561
    0.3553    0.7514    0.7519
    0.3804    0.7608    0.7477
    0.4055    0.7702    0.7435
    0.4306    0.7796    0.7393
    0.4557    0.7890    0.7352
    0.4808    0.7984    0.7310
    0.5059    0.8078    0.7268
    0.5310    0.8173    0.7226
    0.5561    0.8267    0.7184
    0.5812    0.8361    0.7142
    0.6063    0.8455    0.7101
    0.6314    0.8549    0.7059
    0.6559    0.8646    0.7122
    0.6805    0.8742    0.7184
    0.7051    0.8839    0.7247
    0.7297    0.8936    0.7310
    0.7542    0.9033    0.7373
    0.7788    0.9129    0.7435
    0.8034    0.9226    0.7498
    0.8280    0.9323    0.7561
    0.8525    0.9420    0.7624
    0.8771    0.9516    0.7686
    0.9017    0.9613    0.7749
    0.9263    0.9710    0.7812
    0.9508    0.9807    0.7875
    0.9754    0.9903    0.7937
    1.0000    1.0000    0.8000];
    %% read set sizes
    fid = fopen(fullfile('..','..','sizes.txt'));
    line = '.';
    lineindex = 1;
    sizes = 1:length(mAP);
%     while ischar(line)
%         line = fgets(fid);
%         isRightFormat = strfind(line,Format);
%         if(isRightFormat>=0)
%             k = strfind(line,' ');
%             sizes(lineindex) = str2double(line(k+1:end));
%             lineindex = lineindex +1;
%         end
%     end
    fclose(fid);
    %% print mAP
    figure(1);clf;
    if numSets == 1
        for i=1:numDet
            b = bar(i,mAP(i));
            hold on
            set(b,'FaceColor', colors{i})
        end
    else
        for i=1:numDet
            plot(fliplr(sizes),fliplr(mAP(1:end,i)));
            hold on
        end
    end
    title('Detector MAP over Ratio');
    legend(detNames);
    ax = gca;
    s = size(mAP);
    if s(1)~=1
        ax.YLim = [floor(min(mAP(1,:))*10)/10,ceil(max(mAP(length(mAP),:))*10)/10];
    end

    disp('mAP');
    disp(mAP);
    
    %% print prc's
   rows = ceil(numDet/2.0);
   cols = 2;
   figure(2);clf;
   colormap(cmap)
   for i=1:numDet
        nQuery = length({prcs{1,:}});
        x = reshape(cell2mat({prcs{i,:}}),[length(prcs{1})],length({prcs{1,:}}));
        subplot(cols,rows,i);
        if(numSets<=1)
            plot(x);
        else
            s = surf(x);
           view(-170,35);
            s.FaceColor = 'interp';
        end
        title(sprintf(detNames{i}),'FontSize', 32);
        ax = gca;
        ax.YTickLabel = 0:1/2:1;
        xlim(ax,[0,10]);
        ax.XTickLabel = pow2(linspace(numSets,1,numSets));
   end
   
   %% print queries ap
   figure(3);clf;
   fig = gcf;
   colormap(cmap)
   rows = ceil(numDet/2.0);
   cols = 2;
   if numSets==1
       for i=1:numDet
           subplot(cols,rows,i);
           bar(transpose(queriesAp{1}(i,:)));
       end
           title(sprintf(detNames{i}),'FontSize', 32);
   else
       for i=1:numDet
           subplot(cols,rows,i);
           d = zeros(numSets,length(queriesAp{1}(i,:)));
           minAp = inf;
           for j=1:numSets
               minAp = min([queriesAp{j}(i,:),minAp]);
           end
           for j=1:numSets
              d(j,:) = queriesAp{j}(i,:); 
           end
           b = bar3(d);
           set(gca,'Color',[248/255.0, 235/255.0, 252/255.0])
           for k = 1:length(b)
               zdata = b(k).ZData;
               b(k).CData = zdata;
               b(k).FaceColor = 'interp';
               b(k).EdgeColor = 'interp';
               b(k).AlphaData = gradient(zdata);
               b(k).FaceAlpha = 'interp';
               b(k).EdgeAlpha = 1;
               
           end
           title(sprintf(detNames{i}),'FontSize', 32);
           ax = gca;
           ax.ZLim = [minAp,1];
           ax.YTickLabel = pow2(linspace(numSets,1,numSets));
           view(-170,35);
       end
   end
   
   