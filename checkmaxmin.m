function maxmin =checkmaxmin(a)
a=input('ÇëÊäÈëÒ»¸ö¾ØÕó£º');
[b, c]=size(a);
d=a(1,1);
e=a(1,1);
for i=1:b
    for j=1:c
            if a(i,j)>d
                d=a(i,j);
            end
            if a(i,j)<e
                e=a(i,j);
            end
    end
end
e 
d