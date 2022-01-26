a=imread('Fig0206(a)(rose-original).tif');
imhist(a)
g=histeq(a,256);
ylim('auto')
 g=histeq(a,256);
imhist(g)
imshow(g)
