clear;
clc;
profile on;
format long;
NUM_Point=320;%Model%
global EleInf_S NE_S LM_S
[NE_S, NE_B, NN, NDOFN, NNODE_S, NNODE_B, NUMGEN, LOC_S, LOC_B, EleInf_S, EleInf_B] = ElementInformation(NUM_Point);%Model%
[LM_S, ~] = LMF(NUMGEN, NDOFN, NNODE_S, NE_S, LOC_S, NN);
LM_S_DER=LM_S;
[LM_B, DOF_NNOFN] = LMF(NUMGEN, NDOFN, NNODE_B, NE_B, LOC_B, NN);



%------------
[Q0_INIT]=CI(EleInf_S, NE_S, NUMGEN);%给定系统初始位置 %Model%
[d_Q0_INIT]=CIV(EleInf_S, NE_S, NUMGEN);%给定系统初始位置 %Model%
q=Q0_INIT;
Kappa_0=zeros(3*NE_B,1);

dq=d_Q0_INIT;%zeros(NUMGEN,1)
ddq=zeros(NUMGEN,1);


rou=0.8;
am=(2*rou-1)/(rou+1);
af=rou/(rou+1);
Gam=1/2-am+af;
Beta=(1-am+af)^2/4;

NUMCON1=3;%运动约束 %Model%
NUMCON2=0;%单元长度约束 NE_S %Model%
NUMCON=NUMCON1+NUMCON2;

h=1e-4; %Model%
n_time=3e4; %Model%


SimBeta =(1-am)/(h^2*Beta*(1-af));
SimGam=Gam/(h*Beta);
an=zeros(NUMGEN,1);% an是n和n-1中间某一时刻的加速度


V=q';
VV=dq';
Index=0;
I=EleInf_B(1,4);
E=EleInf_S(1,2);
L=EleInf_S(1,1)*NE_S;
EPLx_S=EleInf_S(1,1);

M=0.0162/NUM_Point*eye(NUMGEN,NUMGEN);%质量重力一起改 %Model%
% Gravity=zeros(NUMGEN,1);
% for i=1:NN
%     Gravity(3*i,1)=(0.004241)/NUM_Point*(-9.81);%质量重力一起改 %Model%
% end
weiyue=zeros(1,2);
for t=h:h:h*n_time

    q=q+dq*h+(1/2-Beta)*h^2*an;%预估n+1时刻的全部节点的位移
    dq=dq+(1-Gam)*h*an;
    Lam1=zeros(NUMCON1,1);%NUMCON1为运动约束
%     Lam2=zeros(NUMCON2,1);%NUMCON2为长度约束
    Lam=[Lam1];%;Lam2 %Model%
    aa=(af*ddq-am*an)/(1-am);%预估n和n+1中间时刻的加速度aa
    q=q+h^2*Beta*aa;%预估完
    dq=dq+h*Gam*aa;%预估完
    ddq=zeros(NUMGEN,1);
    
    dif1=1;
    cont1=0;
    while dif1>=1e-5
        %-------------------集中力
%         Force=zeros(NUMGEN,1);
%         Vec_T=q(LM_S(NE_S,[4 5 6]))-q(LM_S(NE_S,[1 2 3]));
%         Vec_N=[-Vec_T(2);Vec_T(1);0]/norm(Vec_T);
%         Force(LM_S(NE_S,[4 5 6]))=Force_Extr*Vec_N;%施加外力
%         Force(LM_S(NE_S,[1 2 3]))=-Force_Extr*Vec_N;%施加外力
        %----------------解析解的力
        [ElasticForce, Fq]=assembleElaQ(Kappa_0,q,NUMGEN,NE_S,LM_S,EleInf_S,NE_B,LM_B,EleInf_B);
        [CQ]=Cq(q,NUMGEN); %Model%
        v1=h^2*Beta*(M*ddq+ElasticForce)+CQ'*Lam;%-Gravity%
        v4=fi(t,q); %Model%
        v=[v1;v4];%

        J=[ (h^2*Beta)*(SimBeta*M+Fq) CQ' ;  % 
            CQ    zeros(size(Lam,1),size(Lam,1))];
        
        Deta=-sparse(J)\v;
        dif1=norm(v);
        q = q+Deta(1:NUMGEN,1);% q(Freedom_free) = q(Freedom_free)+Deta;
        dq = dq+SimGam*Deta(1:NUMGEN,1);% dq(Freedom_free) = dq(Freedom_free)+SimGam*Deta;
        ddq = ddq+SimBeta*Deta(1:NUMGEN,1);% ddq(Freedom_free) = ddq(Freedom_free)+SimBeta*Deta;
        Lam=Lam+Deta(NUMGEN+1:end,1);
        cont1=cont1+1;
    end   
    [Index cont1 dif1 t]
    
%     %%
%     %约束方程展开取一阶近似
%     q_=q;    
%     dif2=1;
%     cont2=1;
%     while dif2>=1e-6
%         CT_=CT(t,q_,LM_S,NUMGEN,EleInf_S);
%         dCT=d_CT(t,q_,LM_S,NUMGEN,EleInf_S);
%         M_rev=M\eye(NUMGEN)*h^2;
%         deta_lamda=-(dCT'*M_rev*dCT)\CT_;
%         
%         q_=q_+M_rev*dCT*deta_lamda;
%         dif2=norm(CT_);
%         dif2=0;
% %         q_lamda=q_lamda+deta;
%         cont2=cont2+1;
%     end
%     dq1=dq+1/h*(q_-q);
%     q1=q_;
%     [Index cont1 cont2 dif1 dif2]
    
%     %%
%     %约束方程直接采取牛顿迭代策略
%     q_=q;    
%     dif2=1;
%     cont2=1;
%     lamda_=zeros(NE_S,1);
%     deta_=zeros(NUMGEN+NE_S,1);
%     while dif2>=1e-5
%         v4_=CT(t,q_,LM_S,NUMGEN,EleInf_S);
%         CQ_Len=CQ_q_t1(t,q_,LM_S,NUMGEN,EleInf_S);%_lamda%_lamda
%         
%         dCQ_Len_lamda=d_CQ_q_t1_lamda(t,q_,lamda_,LM_S,NUMGEN,EleInf_S);%_lamda%_lamda
%         J=[M+h^2*dCQ_Len_lamda          CQ_Len;%
%            CQ_Len'             zeros(NE_S,NE_S)];
%         v1_=M*deta_(1:NUMGEN)+CQ_Len*lamda_;
%         
%         v_=[v1_;v4_];
%         deta_deta_=-J\v_;
%         deta_=deta_+deta_deta_;
%         q_=q_+deta_(1:NUMGEN);
%         lamda_=lamda_+deta_(NUMGEN+1:end);
%         dif2=norm(v_);
%         if cont2>=1
%             weiyue=[weiyue;
%                    [t,dif2]];
%             dif2=0;%只迭代一次
%         end
%         cont2=cont2+1;
%     end
%     dq=dq+1/h*(q_-q);
%     q=q_;
%     [Index cont1 cont2-1 dif1 dif2 t]
% %     norm(q1-q2)%q1是约束方程一阶线性化的约束投影法的结果%q2是完整约束投影法只迭代一次的结果%验证完整约束投影法的书写正确性
%     %%
    aa=aa+ddq*(1-af)/(1-am); % aa准确值（是n和n+1中间某一时刻的加速度）
    an=aa; % 将n和n+1中间时刻加速度赋给n+1和n+2中间时刻准备下次迭代
    
    V=[V;q'];   
    VV=[VV;dq'];
end
V_DER=V; 
VV_DER=VV; 
% weiyue_h4_YZ_EAEI_la_P1=weiyue;
% V_DER_lp_Pro_w_he4=V;
% V_DER_projection=V;
% Animation(q,LM_S,EleInf_B,Force,NE_S);
% profile viewer;

% A=[ 1 -1;
%    -1  1];
% B=A\eye(2)
