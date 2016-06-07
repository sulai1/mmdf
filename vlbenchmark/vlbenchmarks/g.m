bar(1,log(25328.1691792295),'r');
hold on
bar(2,log(211.708543),'g');
hold on
bar(3,log(1756.961474),'b');

ax = gca;
ax.XTick = 1:3;

t = linspace(2, 6, 5);
ax.YTick = t.*2;
ax.YTickLabel = 10.^t;
ax.XTickLabel = {'jpg','j2p','jxr'};