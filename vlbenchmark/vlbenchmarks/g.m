bar(1,log(25328.1691792295),'r');
hold on
bar(2,log(211.708543),'g');
hold on
bar(3,log(1756.961474),'b');

figure(1);clf;
raw = 3.916590280466127e+05;
bar(1,log2(raw),'r');
hold on
jpg = 25328.1691792295;
bar(2,log2(jpg),'y');
hold on
jxr = 1756.961474;
bar(3,log2(jxr),'g');
hold on
jp2 = 211.708543;
bar(4,log2(jp2),'b');

grid on

ax = gca;
ax.XTick = 1:4;

t = 2:2:24;
ax.YTick = t;
ax.FontSize = 16;
ylabel('2^x Byte');
ax.XTickLabel = {'RAW','JPG','JXR','J2P'};

figure(2);clf;
bar(1,log2(raw/jpg),'y');
hold on
bar(2,log2(raw/jxr),'g');
hold on
bar(3,log2(raw/jp2),'b');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'JPG','JXR','J2P'};

t =log2(1:6);
ax.YTick = t;
ax.FontSize = 16;
ylabel('ratio');

