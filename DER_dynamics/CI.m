function [v]=CI(EleInf, NE, NUMGEN)
% 输出v为系统的初始构型
v=zeros(NUMGEN,1);

% %长直绳
num=0;
mid=0;

for i=1:NE
    EPLx=EleInf(i,1);
    num=num+1;
    v(3*num-2:3*num,1)=[mid 0  0]';
    
    mid=mid+EPLx;
end
num=num+1;
v(3*num-2:3*num,1)=[mid 0  0]';


return