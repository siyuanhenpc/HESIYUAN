function [ Q_Lam,uc,ur,DETA_G ] = Solve_BDDC( q0,K1,K2,F1,F2)
%   此处显示有关此函数的摘要
%   此处显示详细说明
global LM_L  NDOFN
global LM1 LM2 LM3 LM4 LM_Area_c LM_Area_r LM_Area_i LM_Area_b

%------------先把大矩阵组装起来（实质的并行计算前，第一步工作，也是理解并行算法的关键）(总刚度阵按位置组装写约束写lagrange乘子——也就是我们实际并行要处理的大矩阵)
%------------&作为一个标准，（1）检验前边生成刚度阵的正确性（2）帮助我们检验我们后边操作的对错
K_G=zeros(70);
LM11=1:40;         %--------你会发现与角点相关的刚度来自于四个区域，组装过程发生了重叠相加
LM22=31:70;

K_G(LM11,LM11)=K_G(LM11,LM11)+K1; %---------刚度阵分区域排布方式决定了q也是分区域排布的，意味着q和之前的q0是完全不同的
K_G(LM22,LM22)=K_G(LM22,LM22)+K2;

% CQ=zeros(8,26);                                %四个撕开的点要加约束，对应八个lagrange乘子！！！
% CQ(1:2,[3 4 5 6])=[eye(2) -eye(2)];            %理解约束矩阵的写法
% CQ(3:4,[9 10 15 16])=[eye(2) -eye(2)];
% CQ(5:6,[13 14 17 18])=[eye(2) -eye(2)];
% CQ(7:8,[21 22 23 24])=[eye(2) -eye(2)];
% JJ=[K_G CQ'
%     CQ zeros(8)];
FF_G=zeros(70,1);                   %70是自由度个数
FF_G(LM11)=FF_G(LM11)+F1;
FF_G(LM22)=FF_G(LM22)+F2;

JJ=K_G;

DETA_G=-JJ\FF_G;                      %负号是公式里自带的，因为你生成的力是正的，但实际上应该是竖直朝下
%------------这里生成的DETA_G与直接反斜杠求解得出的解对比可以检验之前步骤的正确性

%------------------------------计算预刚度阵
global M LM_Area_c_L LM_Area_I_L LM_Area_i_L LM_Area_b_L LM_Area_r_L
Kii=cell(M,1);
Kii{1}=K1(LM_Area_i_L{1},LM_Area_i_L{1});
Kii{2}=K2(LM_Area_i_L{2},LM_Area_i_L{2});

Kbb=cell(M,1);
Kbb{1}=K1(LM_Area_b_L{1},LM_Area_b_L{1});
Kbb{2}=K2(LM_Area_b_L{2},LM_Area_b_L{2});

Kbi=cell(M,1);
Kbi{1}=K1(LM_Area_b_L{1},LM_Area_i_L{1});
Kbi{2}=K2(LM_Area_b_L{2},LM_Area_i_L{2});

Kcb=cell(M,1);
Kcb{1}=K1(LM_Area_c_L{1},LM_Area_b_L{1});
Kcb{2}=K2(LM_Area_c_L{2},LM_Area_b_L{2});
Kbc=cell(M,1);
Kbc{1}=Kcb{1}';
Kbc{2}=Kcb{2}';

Kci=cell(M,1);
Kci{1}=K1(LM_Area_c_L{1},LM_Area_i_L{1});
Kci{2}=K2(LM_Area_c_L{2},LM_Area_i_L{2});

Kcc=cell(M,1);
Kcc{1}=K1(LM_Area_c_L{1},LM_Area_c_L{1});
Kcc{2}=K2(LM_Area_c_L{2},LM_Area_c_L{2});

Krr=cell(M,1);
Krr{1}=K1(LM_Area_r_L{1},LM_Area_r_L{1});
Krr{2}=K2(LM_Area_r_L{2},LM_Area_r_L{2});

Krc=cell(M,1);
Krc{1}=K1(LM_Area_r_L{1},LM_Area_c_L{1});
Krc{2}=K2(LM_Area_r_L{2},LM_Area_c_L{2});

% P1=zeros(8,8);
% 
% F=-Frr-Frc/Kccstar*Frc';
% d=-dr+Frc/Kccstar*fcstar;
% for i=1:4
%     P_K=Kbb{i}-Kbi{i}/Kii{i}*Kbi{i}';
%     P1(L_B{i},L_B{i})=P1(L_B{i},L_B{i})+P_K;

g_I=cell(M,1);
g_I{1}=F1(LM_Area_I_L{1},1);
g_I{2}=F2(LM_Area_I_L{2},1);

g_i=cell(M,1);
g_i{1}=F1(LM_Area_i_L{1},1);
g_i{2}=F2(LM_Area_i_L{2},1);

%-----------------------------------------------生成界面问题------------------------------------------------

S_intf=cell(M,1);
G_intf=cell(M,1);
S=zeros(10);        %10为界面自由度
G=zeros(10,1);
for i=1:M
    K_I([3 4 5 6 7 8 1 2 9 10],[3 4 5 6 7 8 1 2 9 10])=[ Kbb{i} Kbc{i}
                                                         Kcb{i} Kcc{i} ];
    K_i_I([3 4 5 6 7 8 1 2 9 10],:)=[Kbi{i}; Kci{i}];
    S_intf{i}=K_I-K_i_I/Kii{i}*K_i_I';
    G_intf{i}=g_I{i}-K_i_I/Kii{i}*g_i{i};
    S=S+S_intf{i};
    G=G+G_intf{i};
end
u_I=-S\G;

% end

%---------------------------------------------计算预处理算子------------------------------------------------
%-------S_c--------%
S_c_L=cell(M,1);
for i=1:M
    S_c_L{i}=Kcc{i}-Krc{i}'/Krr{i}*Krc{i};
end
S_c=zeros(4);     %角点自由度为4
for i=1:M
    S_c=S_c+S_c_L{i};
end
%------R---------%
RIc=zeros(4,16);
RIc(1:2,1:2)=eye(2);
RIc(3:4,9:10)=eye(2);

RIb=zeros(12,16);
RIb(1:2,3:4)=eye(2);
RIb(3:4,5:6)=eye(2);
RIb(5:6,7:8)=eye(2);
RIb(7:8,11:12)=eye(2);
RIb(9:10,13:14)=eye(2);
RIb(11:12,15:16)=eye(2);


Rb=cell(M,1);
Rb{1}=zeros(6,12);
Rb{2}=zeros(6,12);
Rb{1}(1:2,1:2)=eye(2);
Rb{1}(3:4,3:4)=eye(2);
Rb{1}(5:6,5:6)=eye(2);

Rb{2}(1:2,7:8)=eye(2);
Rb{2}(3:4,9:10)=eye(2);
Rb{2}(5:6,11:12)=eye(2);

R_I=zeros(16,10);
R_I(1:2,1:2)=eye(2);
R_I(3:4,3:4)=eye(2);
R_I(5:6,5:6)=eye(2);
R_I(7:8,7:8)=eye(2);
R_I(9:10,9:10)=eye(2);
R_I(11:12,3:4)=eye(2);
R_I(13:14,5:6)=eye(2);
R_I(15:16,7:8)=eye(2);

R_D_I=(eye(10)/R_I)';
%-------phi--------%

RR=cell(M,1);
RR{1}=[zeros(12,30) Rb{1}'];%30代表一区域内部点自由度
RR{2}=[zeros(12,30) Rb{2}'];%30代表二区域内部点自由度

R_c=cell(M,1);
R_c{1}=eye(4);   %第一个4是一区域角点自由度
R_c{2}=eye(4);

K_ic=cell(M,1);
for i=1:M
    K_ic{i}=[Kii{i} Kbi{i}'
             Kbi{i} Kbb{i}];
end

K_cr=cell(M,1);
for i=1:M
    K_cr{i}=[Kci{i}';Kcb{i}'];
end
KK_I_i=zeros(12,4);  %4是试出来的%界面上全部点对界面内部点i的作用
for i=1:M
    KK_I_i=KK_I_i+RR{i}/Krr{i}*K_cr{i}*R_c{i};
end

phi=RIc'-RIb'*KK_I_i;
%---------------%
KK=zeros(12,12);
for i=1:M
    KK=KK+RR{i}/K_ic{i}*RR{i}';
end
M_BDDC=R_D_I'*(RIb'*KK*RIb+phi/S_c*phi')*R_D_I;
%-----------------------------------------------------------------------------------------------------------
cond(S)
cond(M_BDDC*S)
% [u_I_ , flag , relres ,ite] = pcg(S,G,1e-6,500);
[u_I_ , flag , relres ,ite] = pcg(S,G,1e-6,500,M_BDDC);
itretion=ite;
return

% % % % %发现Kccstar求逆不可行是否kccstar性质不好？(WRONG!!!!!!)
% % % % %Kccstar必须可逆，不可逆有可能是因为对角线上有零元素，要么少加了要么就是加的步长有问题
% F=Frr+Frc/Kccstar*Frc';
% d=dr-Frc/Kccstar*fcstar;
% lamda=F\d;
% % [lamda , flag , relres ,ite] = pcg(F,d,1e-6,500,inv(P1));
% uc=Kccstar\(Frc'*lamda-fcstar);
% ur=cell(4,1);
% for i=1:4
%     ur{i}=Krr{i}\(fr{i}-Krc{i}*CQC{i}*uc);
% end
% dif=norm([lamda ;uc]);
% end

