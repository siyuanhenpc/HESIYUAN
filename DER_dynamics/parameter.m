global len lineth Node_num Node_num_old m

%%ģ�Ͳ���
lineth=11;%ÿ���ʵ���
Node_num = lineth;
Node_num_old=Node_num;

len = 1/(lineth-1);%����ԭ��״̬�������ʵ��࣬��1m�����ȷֲ�lineth���ʵ�
E=2e11;
A=pi*(2e-2)^2;%��Ϊ���������ΪԲ��
% rho=1.796e-3;%���ܶȵ�λ��kg/m
kexi=0;

%%ģ�͹���
NodelinK;

%%�㷨����
% rou=0.0;
% am=(2*rou-1)/(rou+1);
% af=rou/(rou+1);
% Gam=1/2-am+af;
% Beta=(1-am+af)^2/4;

% h=1e-4;
% n_time=6e4;
% delta_t_ani=0.01;

%%��ʼ����
r0=zeros(Node_num*3,1);
for i=1:Node_num
    r0(3*i-2:3*i,1)=[len*(i-1) 0 0]';
end
%%�ֶβ���
beta=1;
[Nodelink,r0,Node_num] = rope_partager(Nodelink,r0,beta,Node_num,Node_num_old,lineth);

L_11=1/(beta*(lineth-1));%ÿһС��ԭ��!!!!!!!

%%�趨�����᷶Χ
display_region=[0 1.2 -0.006 0.006 0 1];

%��������
F=zeros(Node_num*3,1);
F(31:33,1)=[0;150;0];

