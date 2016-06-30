clc;

open(fullfile('jp2_16_06_14.fig'));
axh = findobj( gcf, 'Type', 'Axes' );




for i=1:length(axh)
end

Data = get(axh(1), 'Children');
ZData = get(Data,'ZData');
for i=1:length(ZData)
    x = ZData{i};
    z(i,:)=x(2:6:end,2:4:end);
end
HeatMap(z,'ColorMap', redgreencmap(10));