function ElementInformation
global NE NN NDOFN NNODE NUMGEN BLOC ND BEleInf
NE=4;%�����ӵ�Ԫ���� 32���ڵ�Ԫ���� 24%-------����ѧ-------��Ԫ���� 1 2 3 5 15 25 35 45=(�ڵ�����4 6 8 12 32 52 72 92)*3/6-1
NN=NE+1;%------------�ڵ����� 
NDOFN=6;%--------�ڵ����ɶ�
NNODE=2;%-----------��Ԫ�ڵ���
ND=NDOFN*NNODE;%-----------��Ԫ���ɶ�
NUMGEN=NN*NDOFN;%---------�����ɶ� 
BLOC=zeros(NE,NNODE);

for k=1:NE
    BLOC(k,1)=k;
    BLOC(k,2)=k+1;
end
%----------ֱ��
L1=30;
ro1=1909.8593;%7800
l_e1=L1/NE;
E1=2e+11;%2e+11
Mu1=0;
% ----------��Բ
% L1=0.5*pi;
% ro1=7800;
% l_e1=L1/NE;
% E1=2.0522e+11;
% Mu1=0;
% ---------------------Square Section
%----------ֱ��
% wide=0.01;
% high=0.01;
% A1=wide*high;
% I=wide*high^3/12;
% ----------��Բ
% wide=L1*0.022;
% high=L1*0.022;
A1=pi*(3e-4)^2;
I=A1^2/4/pi;


for i=1:NE
    BEleInf(i,:)=[l_e1,A1,ro1,E1,Mu1,0.5*E1*I/2,0.5*E1*A1/2];
end

end