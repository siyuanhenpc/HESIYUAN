function [v]=CI(EleInf, NE, NUMGEN)
% ���vΪϵͳ�ĳ�ʼ����
v=zeros(NUMGEN,1);

% %��ֱ��
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