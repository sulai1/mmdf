open res/test/prc.fig
D=get(gca,'Children'); %get the handle of the line object
recalls =get(D,'XData'); %get the x data
precisions =get(D,'YData'); %get the y data


steps = 0:0.05:1;
interp1 = prcinterp(precisions(1), recalls(1),steps);
interp2 = prcinterp(precisions(2), recalls(1),steps);
interp3 = prcinterp(precisions(3), recalls(1),steps);

figure(7);
plot(steps,interp1);
hold on
plot(steps,interp2);
hold on
plot(steps,interp3);
axis([0 1 0 1]);

interp = prcinterp(precisions, recalls,steps);

figure(8);
plot(steps,interp);