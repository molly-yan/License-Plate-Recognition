    function fout=charray(a,b,c)
    if nargin==1
       fout=a;
    elseif nargin==2
       fout=a+b;
    elseif nargin==3
       fout=(a*b*c)/2;
    end
x=[1:3];
y=[1;2;3];
    examp(x)
    examp(x,y')
    examp(x,y,3)
