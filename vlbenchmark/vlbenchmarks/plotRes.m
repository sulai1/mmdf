    colors = {'y','m','c','r','b','g','w','k'};

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
   for i=1:numDet
        nQuery = length({prcs{1,:}});
        x = reshape(cell2mat({prcs{i,:}}),[length(prcs{1})],length({prcs{1,:}}));
        subplot(cols,rows,i);
        if(numSets<=1)
            plot(x);
        else
            surf(x);
            view([-1,1,1]);
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
   fig.PaperUnits = 'points';
   fig.PaperPosition = [0 0 1920 1080];
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
           for j=1:numSets
              d(j,:) = queriesAp{j}(i,:); 
           end
           bar3(d);
           title(sprintf(detNames{i}),'FontSize', 32);
           ax = gca;
           ax.YTickLabel = pow2(linspace(numSets,1,numSets));
           view(-150,30);
       end
   end
   
   