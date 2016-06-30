
I = uint8(rgb2gray(imread('t2.jpg'))) ;


[r,f] = vl_mser(I,'MinDiversity',0.7,...
                'MaxVariation',0.2,...
                'Delta',10) ;
f = vl_ertr(f) ;

figure(1); clf;
imshow(I);
vl_plotframe(f) ;

dims = size(f);
fn = zeros(3,dims(2));
for i=1:dims(2)
    fn(1,i) = f(1,i);
    fn(2,i) = f(2,i);
    
    A = [f(3,i),f(4,i);f(4,i),f(5,i)];
    [V , D] = eig(A);
    fn(3,i) = sqrt(mean([norm(D(:,1)),norm(D(:,2))]));
    
end
figure(2); clf;
imshow(I);
vl_plotframe(fn) ;

figure(3) ;

M = zeros(size(I)) ;
for x=r'
 s = vl_erfill(I,x) ;
 M(s) = M(s) + 1;
end

clf ; imagesc(I) ; hold on ; axis equal off; colormap gray ;
[c,h]=contour(M,(0:max(M(:)))+.5) ;
set(h,'color','y','linewidth',3) ;
