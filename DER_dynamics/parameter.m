global len lineth Node_num Node_num_old m

%%模型参数
lineth=11;%每边质点数
Node_num = lineth;
Node_num_old=Node_num;

len = 1/(lineth-1);%梁在原长状态下相邻质点间距，长1m，均匀分布lineth个质点
E=2e11;
A=pi*(2e-2)^2;%认为梁界面近似为圆面
% rho=1.796e-3;%线密度单位是kg/m
kexi=0;

%%模型构建
NodelinK;

%%算法参数
% rou=0.0;
% am=(2*rou-1)/(rou+1);
% af=rou/(rou+1);
% Gam=1/2-am+af;
% Beta=(1-am+af)^2/4;

% h=1e-4;
% n_time=6e4;
% delta_t_ani=0.01;

%%初始构型
r0=zeros(Node_num*3,1);
for i=1:Node_num
    r0(3*i-2:3*i,1)=[len*(i-1) 0 0]';
end
%%分段参数
beta=1;
[Nodelink,r0,Node_num] = rope_partager(Nodelink,r0,beta,Node_num,Node_num_old,lineth);

L_11=1/(beta*(lineth-1));%每一小段原长!!!!!!!

%%设定坐标轴范围
display_region=[0 1.2 -0.006 0.006 0 1];

%定义外载
F=zeros(Node_num*3,1);
F(31:33,1)=[0;150;0];

