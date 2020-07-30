function [ Q_Lam,uc,ur,DETA_G ] = Solve_BDDC( q0,K1,K2,F1,F2)
%   �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global LM_L  NDOFN
global LM1 LM2 LM3 LM4 LM_Area_c LM_Area_r LM_Area_i LM_Area_b

%------------�ȰѴ������װ������ʵ�ʵĲ��м���ǰ����һ��������Ҳ����Ⲣ���㷨�Ĺؼ���(�ܸն���λ����װдԼ��дlagrange���ӡ���Ҳ��������ʵ�ʲ���Ҫ����Ĵ����)
%------------&��Ϊһ����׼����1������ǰ�����ɸն������ȷ�ԣ�2���������Ǽ������Ǻ�߲����ĶԴ�
K_G=zeros(70);
LM11=1:40;         %--------��ᷢ����ǵ���صĸն��������ĸ�������װ���̷������ص����
LM22=31:70;

K_G(LM11,LM11)=K_G(LM11,LM11)+K1; %---------�ն���������Ų���ʽ������qҲ�Ƿ������Ų��ģ���ζ��q��֮ǰ��q0����ȫ��ͬ��
K_G(LM22,LM22)=K_G(LM22,LM22)+K2;

% CQ=zeros(8,26);                                %�ĸ�˺���ĵ�Ҫ��Լ������Ӧ�˸�lagrange���ӣ�����
% CQ(1:2,[3 4 5 6])=[eye(2) -eye(2)];            %���Լ�������д��
% CQ(3:4,[9 10 15 16])=[eye(2) -eye(2)];
% CQ(5:6,[13 14 17 18])=[eye(2) -eye(2)];
% CQ(7:8,[21 22 23 24])=[eye(2) -eye(2)];
% JJ=[K_G CQ'
%     CQ zeros(8)];
FF_G=zeros(70,1);                   %70�����ɶȸ���
FF_G(LM11)=FF_G(LM11)+F1;
FF_G(LM22)=FF_G(LM22)+F2;

JJ=K_G;

DETA_G=-JJ\FF_G;                      %�����ǹ�ʽ���Դ��ģ���Ϊ�����ɵ��������ģ���ʵ����Ӧ������ֱ����
%------------�������ɵ�DETA_G��ֱ�ӷ�б�����ó��Ľ�Աȿ��Լ���֮ǰ�������ȷ��

%------------------------------����Ԥ�ն���
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

%-----------------------------------------------���ɽ�������------------------------------------------------

S_intf=cell(M,1);
G_intf=cell(M,1);
S=zeros(10);        %10Ϊ�������ɶ�
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

%---------------------------------------------����Ԥ��������------------------------------------------------
%-------S_c--------%
S_c_L=cell(M,1);
for i=1:M
    S_c_L{i}=Kcc{i}-Krc{i}'/Krr{i}*Krc{i};
end
S_c=zeros(4);     %�ǵ����ɶ�Ϊ4
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
RR{1}=[zeros(12,30) Rb{1}'];%30����һ�����ڲ������ɶ�
RR{2}=[zeros(12,30) Rb{2}'];%30����������ڲ������ɶ�

R_c=cell(M,1);
R_c{1}=eye(4);   %��һ��4��һ����ǵ����ɶ�
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
KK_I_i=zeros(12,4);  %4���Գ�����%������ȫ����Խ����ڲ���i������
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

% % % % %����Kccstar���治�����Ƿ�kccstar���ʲ��ã�(WRONG!!!!!!)
% % % % %Kccstar������棬�������п�������Ϊ�Խ���������Ԫ�أ�Ҫô�ټ���Ҫô���ǼӵĲ���������
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

