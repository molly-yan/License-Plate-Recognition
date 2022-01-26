function [d]=main(jpg)
I=imread('yu.jpg');
figure(1),imshow(I);title('原图');
I1=rgb2gray(I);
figure(2),subplot(1,2,1),imshow(I1);title('灰度图');
%figure(2),subplot(1,2,2),imhist(I1);title('灰度图直方图');
I2=edge(I1,'canny',0.08,'both');
figure(3),imshow(I2);title('robert算子边缘检测')
se=[1;1;1];
I3=imerode(I2,se);
figure(4),imshow(I3);title('腐蚀后图像');
se=strel('rectangle',[40,40]);%生成一个矩阵
I4=imclose(I3,se);  %闭运算
figure(5),imshow(I4);title('平滑图像的轮廓');
I5=bwareaopen(I4,2000,8);
figure(6),imshow(I5);title('从对象中移除小对象');
[y,x,z]=size(I5);
myI=double(I5);
    %begin横向扫描
tic
     white_y=zeros(y,1);
      for i=1:y
         for j=1:x
             if(myI(i,j,1)==1) 
          %如果myI(i,j,1)即myI图像中坐标为(i,j)的点为白色
          %则Blue_y的相应行的元素white_y(i,1)值加1
           white_y(i,1)= white_y(i,1)+1;%蓝色像素点统计 
              end  
end       
 end
 [temp MaxY]=max(white_y);%temp为向量white_y的元素中的最大值，MaxY为该值的索引（ 在向量中的位置）
 PY1=MaxY;
     while ((white_y(PY1,1)>=120)&&(PY1>1))
          PY1=PY1-1;
 end    
 PY2=MaxY;
     while ((white_y(PY2,1)>=40)&&(PY2<y))
        PY2=PY2+1;
 end
     IY=I(PY1:PY2,:,:);
%IY为原始图像I中截取的纵坐标在PY1：PY2之间的部分
 %end横向扫描
 %begin纵向扫描
      white_x=zeros(1,x);%进一步确定x方向的车牌区域
 for j=1:x
         for i=PY1:PY2
             if(myI(i,j,1)==1)
                  white_x(1,j)= white_x(1,j)+1;               
               end  
           end       
 end
  
 PX1=1;
      while ((white_x(1,PX1)<3)&&(PX1<x))
          PX1=PX1+1;
      end    
 PX2=x;
      while ((white_x(1,PX2)<3)&&(PX2>PX1))
             PX2=PX2-1;
       end 
      %end纵向扫描
 PX1=PX1-2;%对车牌区域的校正
 PX2=PX2+2;
 dw=I(PY1:PY2,:,:);
 
 [temp MaxX]=max(white_x);%temp为向量white_x的元素中的最大值，MaxX为该值的索引（ 在向量中的位置）
 PX3=MaxX;
     while ((white_x(PX3,1)>=1536)&&(PX3>1))
          PX3=PX3-1;
 end    
 PX4=MaxX;
     while ((white_x(PX4,1)>=384)&&(PX4<x))
        PX4=PX4+1;
 end
     IX=I(PX3:PX4,:,:);
%IY为原始图像I中截取的横坐标在PX1：PX2之间的部分
 %end纵向扫描
 %begin横向扫描
      white_y=zeros(1,y);%进一步确定y方向的车牌区域
 for j=1:y
         for i=PX1:PX2
             if(myI(i,j,1)==1)
                  white_y(1,j)= white_y(1,j)+1;               
               end  
           end       
 end
  
 PY3=1;
      while ((white_y(1,PY3)<3)&&(PY3<y))
          PY3=PY3+1
      end    
 PY4=y;
      while ((white_y(1,PY4)<3)&&(PY4>PY3))
            PY4=PY4-1
       end 
      %end纵向扫描
 PY3=PY3-2;%对车牌区域的校正
 PY4=PY4+2;
        t=toc;
dw1=I(PX3:PX4,:,:);
dw2=dw1+dw
%figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');
figure(7),subplot(1,2,2),imshow(dw2),title('定位剪切后的彩色车牌图像')
imwrite(dw2,'dw2.jpg');
% [filename,filepath]=uigetfile('dw.jpg','输入一个定位裁剪后的车牌图像');
% jpg=strcat(filepath,filename);
a=imread('dw2.jpg');
b=rgb2gray(a);
imwrite(b,'1.车牌灰度图像.jpg');
figure(8);subplot(3,2,1),imshow(b),title('1.车牌灰度图像')
g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值
[m,n]=size(b);
d=(double(b)>=T);  % d:二值图像
imwrite(d,'2.车牌二值图像.jpg');
figure(8);subplot(3,2,2),imshow(d),title('2.车牌二值图像')
figure(8),subplot(3,2,3),imshow(d),title('3.均值滤波前')
% 滤波
h=fspecial('average',3);  %均值绿波器
d=im2bw(round(filter2(h,d)));  %BW = im2bw(I, level) 将灰度图像 I 转换为二进制图像。输出图像 %BW 将输入图像中亮度值大于 level 的像素替换为值1 (白色)，其他替换为值0(黑色
imwrite(d,'4.均值滤波后.jpg');  %matlab里函数bwarea 计算目标物的面积
figure(8),subplot(3,2,4),imshow(d),title('4.均值滤波后')
% 某些图像进行操作
% 膨胀或腐蚀
% se=strel('square',3); % 使用一个3X3的正方形结果元素对象对创建的图像膨胀
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix 单位矩阵
[m,n]=size(d);
temp=bwarea(d);
% assignin( 'base','tmp',temp)
if bwarea(d)/m/n>=0.365  %计算面积
        d=imerode(d,se);   %imerode 实现图像腐蚀 d为待处理图像，se是结构元素对象
elseif bwarea(d)/m/n<=0.235
         d=imdilate(d,se); %imdilate 图像膨胀
end
imwrite(d,'5.膨胀或腐蚀处理后.jpg');
figure(8),subplot(3,2,5),imshow(d),title('5.膨胀或腐蚀处理后')
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割
d=qiege(d);
%figure(100),subplot(3,2,4),imshow(d),title('qiege')
[m,n]=size(d);
%figure(9),subplot(2,1,1),imshow(d),title('n')
% k1=1;k2=1;s=sum(d);j=1;
% while j~=n
%         while s(j)==0
%              j=j+1;
%         end
%                k1=j;
%           while s(j)~=0 && j<=n-1
%                j=j+1;
%          end
%                  k2=j-1;
%        if k2-k1>=round(n/6.5)
%               [val,num]=min(sum(d(:,[k1+5:k2-5])));
%            d(:,k1+num+5)=0;  % 分割
%           end
% end
%figure(10),subplot(2,1,1),imshow(d),title('n1');
% 再切割
d=qiege(d);
% 切割出 7 个字符
y1=10;y2=0.25;flag=0;word1=[];
while flag==0
        [m,n]=size(d);
        left=1;wide=0;
        while sum(d(:,wide+1))~=0
            wide=wide+1;
         end
         if wide<y1   % 认为是左侧干扰
              d(:,[1:wide])=0;
              d=qiege(d);
         else
              temp=qiege(imcrop(d,[1 1 wide m]));
              [m,n]=size(temp);
              all=sum(sum(temp));
              two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
          if two_thirds/all>y2
               flag=1;word1=temp;   % WORD 1
             end
              d(:,[1:wide])=0;d=qiege(d);
          end
end
% 分割出第二个字符
[word2,d]=getword(d);
% 分割出第三个字符
[word3,d]=getword(d);
% 分割出第四个字符
[word4,d]=getword(d);
% 分割出第五个字符
[word5,d]=getword(d);
% 分割出第六个字符
[word6,d]=getword(d);
% 分割出第七个字符
[word7,d]=getword(d);
figure(9),imshow(word1),title('1');
figure(10),imshow(word2),title('2');
figure(11),imshow(word3),title('3');
figure(12),imshow(word4),title('4');
figure(13),imshow(word5),title('5');
figure(14),imshow(word6),title('6');
figure(15),imshow(word7),title('7');
[m,n]=size(word1);
% 商用系统程序中归一化大小为 40*20,此处演示
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);
figure(16),
subplot(3,7,8),imshow(word1),title('1');
subplot(3,7,9),imshow(word2),title('2');
subplot(3,7,10),imshow(word3),title('3');
subplot(3,7,11),imshow(word4),title('4');
subplot(3,7,12),imshow(word5),title('5');
subplot(3,7,13),imshow(word6),title('6');
subplot(3,7,14),imshow(word7),title('7');
imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word3,'3.jpg');
imwrite(word4,'4.jpg');
imwrite(word5,'5.jpg');
imwrite(word6,'6.jpg');
imwrite(word7,'7.jpg');
liccode=char(['0':'9' 'A':'Z' '苏豫陕鲁']);  %建立自动识别字符代码表  
SubBw2=zeros(40,20);
l=1;
for I=1:7
           ii=int2str(I);   %将整数转换为字符串
        t=imread([ii,'.jpg']);
        SegBw2=imresize(t,[40 20],'nearest');  %实用最近邻插值法放大图像
        for l=1:7 
            if l==1                 %第一位汉字识别
                kmin=37;
                kmax=40;
            elseif l==2             %第二位 A~Z 字母识别
                kmin=11;
                kmax=36;
            else l>=3               %第三位以后是字母或数字识别
                kmin=1;
                kmax=36;
            end
        end
                
        for k2=kmin:kmax
            fname=strcat('字符模板\',liccode(k2),'.jpg');
            SamBw2 = imread(fname);
            for  i=1:40
                for j=1:20
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % 以上相当于两幅图相减得到第三幅图
           Dmax=0;
            for k1=1:40
                for l1=1:20
                    if  ( SubBw2(k1,l1) > 0 | SubBw2(k1,l1) <0 )
                        Dmax=Dmax+1;
                    end
                end
            end
            Error(k2)=Dmax;
        end
        Error1=Error(kmin:kmax);
        MinError=min(Error1);
        findc=find(Error1==MinError);
        l=l+1;
end
figure(17),subplot(3,1,2),imshow(dw),title (findc);




%子程序：（getword子程序）
function [word,result]=getword(d)
word=[];flag=0;y1=8;y2=0.5;
    while flag==0
        [m,n]=size(d);
        wide=0;
        while sum(d(:,wide+1))~=0 && wide<=n-2  %有白色加1知道没有白色，也就%是找出一个白色区域
            wide=wide+1;
        end
        temp=qiege(imcrop(d,[1 1 wide m])); 
        [m1,n1]=size(temp);
        if wide<y1 && n1/m1>y2
            d(:,[1:wide])=0;
            if sum(sum(d))~=0
                d=qiege(d);  % 切割出最小范围
            else word=[];flag=1;
            end
        else
            word=qiege(imcrop(d,[1 1 wide m]));
            d(:,[1:wide])=0;
            if sum(sum(d))~=0;
                d=qiege(d);flag=1;
            else d=[];
              end
           end
        end
          result=d;



function e=qiege(d)
[m,n]=size(d);
top=1;bottom=m;left=1;right=n;   % init
while sum(d(top,:))==0 && top<=m     %切割出白色区域（横切）
            top=top+1;
end
while sum(d(bottom,:))==0 && bottom>1   %同上  
          bottom=bottom-1;
end
while sum(d(:,left))==0 && left<n        %切割出白区域（纵切）
          left=left+1;
end
while sum(d(:,right))==0 && right>=1
right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);     %在一个数字窗口显示图像dI、X、RGB分别对应灰度图像、索引图像、RGB图像的数据矩阵，MAP为索引图像颜色表，I2、X2、RGB2分别为各自输入矩阵所对应的输出矩阵。而RECT为可选参数，格式为[XMIN YMIN WIGTH HEIGHT].例如[20 20 40 40]，则剪裁后的图像的左上角像素为原图像位置在（20,20）的像素，而剪裁后图像的右下角像素为原图像位置在（60,60）的像素。









