function ElementInformation
global NE NN NDOFN NNODE NUMGEN BLOC ND BEleInf
NE=4;%抖绳子单元总数 32绳摆单元总数 24%-------静力学-------单元总数 1 2 3 5 15 25 35 45=(节点总数4 6 8 12 32 52 72 92)*3/6-1
NN=NE+1;%------------节点总数 
NDOFN=6;%--------节点自由度
NNODE=2;%-----------单元节点数
ND=NDOFN*NNODE;%-----------单元自由度
NUMGEN=NN*NDOFN;%---------总自由度 
BLOC=zeros(NE,NNODE);

for k=1:NE
    BLOC(k,1)=k;
    BLOC(k,2)=k+1;
end
%----------直线
L1=30;
ro1=1909.8593;%7800
l_e1=L1/NE;
E1=2e+11;%2e+11
Mu1=0;
% ----------半圆
% L1=0.5*pi;
% ro1=7800;
% l_e1=L1/NE;
% E1=2.0522e+11;
% Mu1=0;
% ---------------------Square Section
%----------直线
% wide=0.01;
% high=0.01;
% A1=wide*high;
% I=wide*high^3/12;
% ----------半圆
% wide=L1*0.022;
% high=L1*0.022;
A1=pi*(3e-4)^2;
I=A1^2/4/pi;


for i=1:NE
    BEleInf(i,:)=[l_e1,A1,ro1,E1,Mu1,0.5*E1*I/2,0.5*E1*A1/2];
end

end