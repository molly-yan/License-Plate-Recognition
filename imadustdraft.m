subplot(1,2,1)
IM=imread('yu.jpg');
imshow(IM)
subplot(1,2,2)
f=IM;
Low_High=stretchlim(f);
g=imadjust(f, stretchlim(f),[1 0]);
imshow(g)