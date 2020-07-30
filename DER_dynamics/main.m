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
[Q0_INIT]=CI(EleInf_S, NE_S, NUMGEN);%����ϵͳ��ʼλ�� %Model%
[d_Q0_INIT]=CIV(EleInf_S, NE_S, NUMGEN);%����ϵͳ��ʼλ�� %Model%
q=Q0_INIT;
Kappa_0=zeros(3*NE_B,1);

dq=d_Q0_INIT;%zeros(NUMGEN,1)
ddq=zeros(NUMGEN,1);


rou=0.8;
am=(2*rou-1)/(rou+1);
af=rou/(rou+1);
Gam=1/2-am+af;
Beta=(1-am+af)^2/4;

NUMCON1=3;%�˶�Լ�� %Model%
NUMCON2=0;%��Ԫ����Լ�� NE_S %Model%
NUMCON=NUMCON1+NUMCON2;

h=1e-4; %Model%
n_time=3e4; %Model%


SimBeta =(1-am)/(h^2*Beta*(1-af));
SimGam=Gam/(h*Beta);
an=zeros(NUMGEN,1);% an��n��n-1�м�ĳһʱ�̵ļ��ٶ�


V=q';
VV=dq';
Index=0;
I=EleInf_B(1,4);
E=EleInf_S(1,2);
L=EleInf_S(1,1)*NE_S;
EPLx_S=EleInf_S(1,1);

M=0.0162/NUM_Point*eye(NUMGEN,NUMGEN);%��������һ��� %Model%
% Gravity=zeros(NUMGEN,1);
% for i=1:NN
%     Gravity(3*i,1)=(0.004241)/NUM_Point*(-9.81);%��������һ��� %Model%
% end
weiyue=zeros(1,2);
for t=h:h:h*n_time

    q=q+dq*h+(1/2-Beta)*h^2*an;%Ԥ��n+1ʱ�̵�ȫ���ڵ��λ��
    dq=dq+(1-Gam)*h*an;
    Lam1=zeros(NUMCON1,1);%NUMCON1Ϊ�˶�Լ��
%     Lam2=zeros(NUMCON2,1);%NUMCON2Ϊ����Լ��
    Lam=[Lam1];%;Lam2 %Model%
    aa=(af*ddq-am*an)/(1-am);%Ԥ��n��n+1�м�ʱ�̵ļ��ٶ�aa
    q=q+h^2*Beta*aa;%Ԥ����
    dq=dq+h*Gam*aa;%Ԥ����
    ddq=zeros(NUMGEN,1);
    
    dif1=1;
    cont1=0;
    while dif1>=1e-5
        %-------------------������
%         Force=zeros(NUMGEN,1);
%         Vec_T=q(LM_S(NE_S,[4 5 6]))-q(LM_S(NE_S,[1 2 3]));
%         Vec_N=[-Vec_T(2);Vec_T(1);0]/norm(Vec_T);
%         Force(LM_S(NE_S,[4 5 6]))=Force_Extr*Vec_N;%ʩ������
%         Force(LM_S(NE_S,[1 2 3]))=-Force_Extr*Vec_N;%ʩ������
        %----------------���������
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
%     %Լ������չ��ȡһ�׽���
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
%     %Լ������ֱ�Ӳ�ȡţ�ٵ�������
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
%             dif2=0;%ֻ����һ��
%         end
%         cont2=cont2+1;
%     end
%     dq=dq+1/h*(q_-q);
%     q=q_;
%     [Index cont1 cont2-1 dif1 dif2 t]
% %     norm(q1-q2)%q1��Լ������һ�����Ի���Լ��ͶӰ���Ľ��%q2������Լ��ͶӰ��ֻ����һ�εĽ��%��֤����Լ��ͶӰ������д��ȷ��
%     %%
    aa=aa+ddq*(1-af)/(1-am); % aa׼ȷֵ����n��n+1�м�ĳһʱ�̵ļ��ٶȣ�
    an=aa; % ��n��n+1�м�ʱ�̼��ٶȸ���n+1��n+2�м�ʱ��׼���´ε���
    
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
