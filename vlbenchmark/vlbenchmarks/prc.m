open res/t10/t1006.04.16.19.11.10prc.fig
D=get(gca,'Children'); %get the handle of the line object
recalls =get(D,'XData'); %get the x data
precisions =get(D,'YData'); %get the y data


steps = 0:0.05:1;
interp = prcinterp(precisions, recalls,steps);

figure(7);
plot(steps,interp);
axis([0 1 0 1]);