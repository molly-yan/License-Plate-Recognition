function [d]=main(jpg)
I=imread('yu.jpg');
figure(1),imshow(I);title('ԭͼ');
I1=rgb2gray(I);
figure(2),subplot(1,2,1),imshow(I1);title('�Ҷ�ͼ');
%figure(2),subplot(1,2,2),imhist(I1);title('�Ҷ�ͼֱ��ͼ');
I2=edge(I1,'canny',0.08,'both');
figure(3),imshow(I2);title('robert���ӱ�Ե���')
se=[1;1;1];
I3=imerode(I2,se);
figure(4),imshow(I3);title('��ʴ��ͼ��');
se=strel('rectangle',[40,40]);%����һ������
I4=imclose(I3,se);  %������
figure(5),imshow(I4);title('ƽ��ͼ�������');
I5=bwareaopen(I4,2000,8);
figure(6),imshow(I5);title('�Ӷ������Ƴ�С����');
[y,x,z]=size(I5);
myI=double(I5);
    %begin����ɨ��
tic
     white_y=zeros(y,1);
      for i=1:y
         for j=1:x
             if(myI(i,j,1)==1) 
          %���myI(i,j,1)��myIͼ��������Ϊ(i,j)�ĵ�Ϊ��ɫ
          %��Blue_y����Ӧ�е�Ԫ��white_y(i,1)ֵ��1
           white_y(i,1)= white_y(i,1)+1;%��ɫ���ص�ͳ�� 
              end  
end       
 end
 [temp MaxY]=max(white_y);%tempΪ����white_y��Ԫ���е����ֵ��MaxYΪ��ֵ�������� �������е�λ�ã�
 PY1=MaxY;
     while ((white_y(PY1,1)>=120)&&(PY1>1))
          PY1=PY1-1;
 end    
 PY2=MaxY;
     while ((white_y(PY2,1)>=40)&&(PY2<y))
        PY2=PY2+1;
 end
     IY=I(PY1:PY2,:,:);
%IYΪԭʼͼ��I�н�ȡ����������PY1��PY2֮��Ĳ���
 %end����ɨ��
 %begin����ɨ��
      white_x=zeros(1,x);%��һ��ȷ��x����ĳ�������
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
      %end����ɨ��
 PX1=PX1-2;%�Գ��������У��
 PX2=PX2+2;
 dw=I(PY1:PY2,:,:);
 
 [temp MaxX]=max(white_x);%tempΪ����white_x��Ԫ���е����ֵ��MaxXΪ��ֵ�������� �������е�λ�ã�
 PX3=MaxX;
     while ((white_x(PX3,1)>=1536)&&(PX3>1))
          PX3=PX3-1;
 end    
 PX4=MaxX;
     while ((white_x(PX4,1)>=384)&&(PX4<x))
        PX4=PX4+1;
 end
     IX=I(PX3:PX4,:,:);
%IYΪԭʼͼ��I�н�ȡ�ĺ�������PX1��PX2֮��Ĳ���
 %end����ɨ��
 %begin����ɨ��
      white_y=zeros(1,y);%��һ��ȷ��y����ĳ�������
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
      %end����ɨ��
 PY3=PY3-2;%�Գ��������У��
 PY4=PY4+2;
        t=toc;
dw1=I(PX3:PX4,:,:);
dw2=dw1+dw
%figure(7),subplot(1,2,1),imshow(IY),title('�з����������');
figure(7),subplot(1,2,2),imshow(dw2),title('��λ���к�Ĳ�ɫ����ͼ��')
imwrite(dw2,'dw2.jpg');
% [filename,filepath]=uigetfile('dw.jpg','����һ����λ�ü���ĳ���ͼ��');
% jpg=strcat(filepath,filename);
a=imread('dw2.jpg');
b=rgb2gray(a);
imwrite(b,'1.���ƻҶ�ͼ��.jpg');
figure(8);subplot(3,2,1),imshow(b),title('1.���ƻҶ�ͼ��')
g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ
[m,n]=size(b);
d=(double(b)>=T);  % d:��ֵͼ��
imwrite(d,'2.���ƶ�ֵͼ��.jpg');
figure(8);subplot(3,2,2),imshow(d),title('2.���ƶ�ֵͼ��')
figure(8),subplot(3,2,3),imshow(d),title('3.��ֵ�˲�ǰ')
% �˲�
h=fspecial('average',3);  %��ֵ�̲���
d=im2bw(round(filter2(h,d)));  %BW = im2bw(I, level) ���Ҷ�ͼ�� I ת��Ϊ������ͼ�����ͼ�� %BW ������ͼ��������ֵ���� level �������滻Ϊֵ1 (��ɫ)�������滻Ϊֵ0(��ɫ
imwrite(d,'4.��ֵ�˲���.jpg');  %matlab�ﺯ��bwarea ����Ŀ��������
figure(8),subplot(3,2,4),imshow(d),title('4.��ֵ�˲���')
% ĳЩͼ����в���
% ���ͻ�ʴ
% se=strel('square',3); % ʹ��һ��3X3�������ν��Ԫ�ض���Դ�����ͼ������
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix ��λ����
[m,n]=size(d);
temp=bwarea(d);
% assignin( 'base','tmp',temp)
if bwarea(d)/m/n>=0.365  %�������
        d=imerode(d,se);   %imerode ʵ��ͼ��ʴ dΪ������ͼ��se�ǽṹԪ�ض���
elseif bwarea(d)/m/n<=0.235
         d=imdilate(d,se); %imdilate ͼ������
end
imwrite(d,'5.���ͻ�ʴ�����.jpg');
figure(8),subplot(3,2,5),imshow(d),title('5.���ͻ�ʴ�����')
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�
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
%            d(:,k1+num+5)=0;  % �ָ�
%           end
% end
%figure(10),subplot(2,1,1),imshow(d),title('n1');
% ���и�
d=qiege(d);
% �и�� 7 ���ַ�
y1=10;y2=0.25;flag=0;word1=[];
while flag==0
        [m,n]=size(d);
        left=1;wide=0;
        while sum(d(:,wide+1))~=0
            wide=wide+1;
         end
         if wide<y1   % ��Ϊ��������
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
% �ָ���ڶ����ַ�
[word2,d]=getword(d);
% �ָ���������ַ�
[word3,d]=getword(d);
% �ָ�����ĸ��ַ�
[word4,d]=getword(d);
% �ָ��������ַ�
[word5,d]=getword(d);
% �ָ���������ַ�
[word6,d]=getword(d);
% �ָ�����߸��ַ�
[word7,d]=getword(d);
figure(9),imshow(word1),title('1');
figure(10),imshow(word2),title('2');
figure(11),imshow(word3),title('3');
figure(12),imshow(word4),title('4');
figure(13),imshow(word5),title('5');
figure(14),imshow(word6),title('6');
figure(15),imshow(word7),title('7');
[m,n]=size(word1);
% ����ϵͳ�����й�һ����СΪ 40*20,�˴���ʾ
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
liccode=char(['0':'9' 'A':'Z' '��ԥ��³']);  %�����Զ�ʶ���ַ������  
SubBw2=zeros(40,20);
l=1;
for I=1:7
           ii=int2str(I);   %������ת��Ϊ�ַ���
        t=imread([ii,'.jpg']);
        SegBw2=imresize(t,[40 20],'nearest');  %ʵ������ڲ�ֵ���Ŵ�ͼ��
        for l=1:7 
            if l==1                 %��һλ����ʶ��
                kmin=37;
                kmax=40;
            elseif l==2             %�ڶ�λ A~Z ��ĸʶ��
                kmin=11;
                kmax=36;
            else l>=3               %����λ�Ժ�����ĸ������ʶ��
                kmin=1;
                kmax=36;
            end
        end
                
        for k2=kmin:kmax
            fname=strcat('�ַ�ģ��\',liccode(k2),'.jpg');
            SamBw2 = imread(fname);
            for  i=1:40
                for j=1:20
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % �����൱������ͼ����õ�������ͼ
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




%�ӳ��򣺣�getword�ӳ���
function [word,result]=getword(d)
word=[];flag=0;y1=8;y2=0.5;
    while flag==0
        [m,n]=size(d);
        wide=0;
        while sum(d(:,wide+1))~=0 && wide<=n-2  %�а�ɫ��1֪��û�а�ɫ��Ҳ��%���ҳ�һ����ɫ����
            wide=wide+1;
        end
        temp=qiege(imcrop(d,[1 1 wide m])); 
        [m1,n1]=size(temp);
        if wide<y1 && n1/m1>y2
            d(:,[1:wide])=0;
            if sum(sum(d))~=0
                d=qiege(d);  % �и����С��Χ
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
while sum(d(top,:))==0 && top<=m     %�и����ɫ���򣨺��У�
            top=top+1;
end
while sum(d(bottom,:))==0 && bottom>1   %ͬ��  
          bottom=bottom-1;
end
while sum(d(:,left))==0 && left<n        %�и�����������У�
          left=left+1;
end
while sum(d(:,right))==0 && right>=1
right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);     %��һ�����ִ�����ʾͼ��dI��X��RGB�ֱ��Ӧ�Ҷ�ͼ������ͼ��RGBͼ������ݾ���MAPΪ����ͼ����ɫ��I2��X2��RGB2�ֱ�Ϊ���������������Ӧ��������󡣶�RECTΪ��ѡ��������ʽΪ[XMIN YMIN WIGTH HEIGHT].����[20 20 40 40]������ú��ͼ������Ͻ�����Ϊԭͼ��λ���ڣ�20,20�������أ������ú�ͼ������½�����Ϊԭͼ��λ���ڣ�60,60�������ء�









