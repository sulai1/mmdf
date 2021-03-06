p = [5.573559e-01,4.976970e-01,3.124829e-01,4.601566e-01,1.713640e-01; ...
    7.328136e-01,7.122770e-01,4.424916e-01, 6.415866e-01,1.522867e-01; ...
    7.542173e-01,7.250277e-01,4.525375e-01,6.558284e-01,1.545081e-01; ...  
    7.645033e-01,7.272191e-01,4.514741e-01,6.687177e-01,1.514527e-01; ...
    7.688687e-01,7.246981e-01,4.458625e-01,6.693845e-01,1.524921e-01; ...
    7.732782e-01,7.296987e-01,4.511144e-01,6.709657e-01,1.556742e-01]

figure;
a = area(p(:,1));
a.FaceColor = [129/255,204/255.0,116/255.0];
hold on

a = area(p(:,2));
a.FaceColor = [252/255.0,249/255.0,68/255.0];
hold on

a = area(p(:,3));
a.FaceColor = [107/255.0,147/255.0,219/255.0];
hold on

a = area(p(:,4));
a.FaceColor = [219/255,107/255.0,157/255.0];

a = area(p(:,5));
a.FaceColor = [121/255.0,116/255.0,204/255.0];

set(gca, 'XTick', [1 2 3 4 5,6]);
set(gca, 'XTickLabel', {'3%', '22.25%.' ,'41.5%','60.75%', '80%', '100%'});
xlabel('Ratio')
ylabel('mAP')

legend('SIFT','SURF','ORB','PHOW-RGB','PHOW-GRAY','Location','northoutside','Orientation','horizontal'),