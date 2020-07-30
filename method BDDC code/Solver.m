clear;
clc;
format long
%-------------------------����Ԫ�������������
ElementInformation;
%����---------------------�ռ���ɢ
LMF;
%-------------------------�ڵ��ʼλ�ã���ģ���̣�
global q0
[q0,~]=CI;           %�ر�ע�����DP���������ԣ����б߽�ڵ�ĳ�λ����ȫһ��
global NUMGEN_all LM_L NUMCON
q0=reshape(q0',[NUMGEN_all,1]);

global LM1 LM2 NUMGEN NE
[F1,Fq1]=Cons(LM1,LM_L{1},NUMGEN{1},NE{1});   %%��һ�������¼���������ɶȵ�ȫ������Ϊ������q0������&�ڶ��������¼���������ɶȵľֲ�λ��Ϊ������װ�ն���
[F2,Fq2]=Cons(LM2,LM_L{2},NUMGEN{2},NE{2});


%------------------Լ�����ɶ�
% global NE_X NE_Y NUMCON
% NUMCON=2*( 2*(NE_Y+1)+2*(NE_X-1) );
% Freedom_Fixed=zeros(NUMCON,1);
%
% num=1;
% for i=1:NE_Y+1
%     Freedom_Fixed(num:num+1)=DOF_NNOFN(i,:);
%     num=num+2;
% end
%
% for i=1:NE_Y+1
%     Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*NE_X+i,:);
%     num=num+2;
% end
%
% for i=1:(NE_X-1)
%     Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*i+1,:);
%     num=num+2;
%     Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*(i+1),:);
%     num=num+2;
% end
%
% Freedom_Fixed=sort(Freedom_Fixed);
%
% Freedom_free=zeros(NUMGEN-NUMCON,1);
% num=0;
% for i=1:NUMGEN
%     Index=find('Freedom_Fixed'==i);
%     if size(Index,2)==0
%         num=num+1;
%         Freedom_free(num)=i;
%     end
% end
global M
Freedom_Fixed=cell(M,1);
Freedom_Fixed{1}=[1 2 3 4 5 6 7 8 9 10];     %Լ�����ɶȵľֲ�λ�ã�������
Freedom_Fixed{2}=[];

Freedom_free=cell(M,1);
for i=1:M
    num=0;
    for j=1:NUMGEN{i}         %�ֲ����ɶ���
        Index=find(Freedom_Fixed{i}==j);
        if  size(Index,2)==0
            num=num+1;
            Freedom_free{i}(num,1)=j;
        end
    end
end

Fq1=Fq1(Freedom_free{1},Freedom_free{1});
Fq2=Fq2(Freedom_free{2},Freedom_free{2});
% Fq3=Fq3(Freedom_free(3,:),Freedom_free(3,:));
% Fq4=Fq4(Freedom_free(4,:),Freedom_free(4,:));
F1=F1(Freedom_free{1},1);
F2=F2(Freedom_free{2},1);
% F3=F3(Freedom_free(3,:),1);
% F4=F4(Freedom_free(4,:),1);

%-------------------------Solver
% [CQC,CQR]=Pre_CQF();
[lamda,uc,ur,DETA_G]=Solve_BDDC(q0,Fq1,Fq2,F1,F2);
deta_q=zeros(NUMGEN,1);
global LM_c LM_Area_r
deta_q(LM_c,:)=uc;
for i=1:4
    deta_q(LM_Area_r(i,:))=ur{i};
end

deta_qq=deta_q([1:16,19:32,37:42,45:58],1);

%-------------------------������������������������ֱ�������������������
global LOC NE_X NE_Y
NUM=2;
for I=1:NE_X
    for J=1:NE_Y
        LOC(NE_Y*(I-1)+J,:)=[ NUM,NUM+NE_Y+1,NUM+NE_Y,NUM-1 ];
        NUM=NUM+1;
    end
    NUM=NUM+1;
end

global NDOFN NNODE NE_all  LM DOF_NNOFN
IDD=1:50;           %numgen
ID=reshape(IDD,NDOFN,[]);
LM=zeros(NE_all,NDOFN*NNODE);
for k=1:NE_all
    LM(k,:)=reshape(ID(:,LOC(k,:)),1,[]);
end
%------------�ڵ����ɶȱ��
DOF_NNOFN=zeros(25,NDOFN);
for k=1:25
    DOF_NNOFN(k,:)=reshape(ID(:,k),1,[]);
end

global EleInf
q=zeros(50,1);
num=0;
mid=0;
EPLx=EleInf(1,1);
EPLy=EleInf(1,2);
for i=1:NE_X+1        %X������+1
    for j=1:NE_Y+1    %Y������+1
        num=num+1;
        q(2*num-1:2*num,1)=[mid 1-(j-1)*EPLy ]';
    end
    mid=mid+EPLx;
end
Fq=zeros(50);   %NUMGEN          %K
F=zeros(50,1);  %NUMGEN          %P
for num=1:NE
    lm=LM(num,:);
    e0=q(LM(num,:));                   %-----num������λ��(x��y)����
    EleInf_1=EleInf(num,:);
    [Fk,Fqq]=Elastic_E(e0,EleInf_1);    %-----���ø��������̣�������������ɳ�ģ̬�ļ���
    Fq(lm,lm)=Fq(lm,lm)+Fqq;            %%%�ն���
    F(lm)=F(lm)+Fk;                     %%%��
end
%------Freedom_Fixed
NUMCON=2*( 2*(NE_Y+1)+2*(NE_X-1) );
Freedom_Fixed=zeros(NUMCON,1);
num=1;
for i=1:NE_Y+1
    Freedom_Fixed(num:num+1)=DOF_NNOFN(i,:);
    num=num+2;
end
for i=1:NE_Y+1
    Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*NE_X+i,:);
    num=num+2;
end
for i=1:(NE_X-1)
    Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*i+1,:);
    num=num+2;
    Freedom_Fixed(num:num+1)=DOF_NNOFN((NE_Y+1)*(i+1),:);
    num=num+2;
end
Freedom_Fixed=sort(Freedom_Fixed);
%-----------------------------------------
Freedom_free=zeros(50-NUMCON,1);

num=0;
for i=1:50      %NUMGEN
    Index=find(Freedom_Fixed(:,1)==i);
    if  size(Index,1)==0
        num=num+1;
        Freedom_free(num)=i;
    end
end
Phi_function=zeros(50,1);%NUMGEN
v=F(Freedom_free);
J=Fq(Freedom_free,Freedom_free);
Deta=-sparse(J)\v;
deta=zeros(50,1);
deta(Freedom_free,:)=Deta;
error=norm((deta_qq-deta))/norm(deta);
% a=[9;10];
% Deta_Cor=Deta(a,1);
% Deta_Cor-uc;
% Phi_function(Freedom_free)=Phi_function(Freedom_free)+Deta;

% Animation1(Position_Solve,Phi_function,LM,NE);
