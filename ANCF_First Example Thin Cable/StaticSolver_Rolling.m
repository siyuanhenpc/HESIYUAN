clear all
clc
RunParameter;
q0=CI;
Init_Coor=q0;
q=q0;
Freedom_Fixed=zeros(4,1);
Freedom_Fixed(1:4)=[1 3 4 6]';
num=5;
for i=1:NE+1
    Freedom_Fixed(num:num+1)= [(i-1)*6+2 (i-1)*6+5]';
    num=num+2;
end
NUMCON=length(Freedom_Fixed);
% Freedom_Fixed=[1 2 3 NUMGEN-5 NUMGEN-4 NUMGEN-3]';
Freedom_free=zeros(NUMGEN-NUMCON,1);
num=0;
for i=1:NUMGEN
    Index=find(Freedom_Fixed==i);
    if size(Index,1)==0
        num=num+1;
        Freedom_free(num)=i;
    end
end


%-----------------------------Concentrate Force 施加过大的力矩 计算结果不准确
L=1;%0.5*pi;
EI=4*BEleInf(1,6);
V=q0';
Index=0;
ElasticForce1=zeros(NUMGEN,1);
Deta_Full=zeros(NUMGEN,1);
Fq0=zeros(NUMGEN);
cont1=0;
while Index<1-1e-08
    Index=Index+0.05;
%     M=[0 pi*EI/L*Index 0];%----------全局坐标，但是施加这样一个力矩，梁变形方向与力矩方向一直保持垂直
    dif=1;
    cont=1;
    while dif>=1e-10
        %----------Reduce beam element applly the concentrate Moment
        q1=q(LM(NE,:));
%         Moment_NE=Concentrate_Moment(q1,M);
%         Moment=zeros(NUMGEN,1);
%         Moment(LM(NE,:))=Moment_NE;
        %----------concentrate Force
        F_ext=zeros(NUMGEN,1);
        F_ext(LM(NE,end-5:end))=[0 0 (4e-7)*Index 0 0 0];

        [ElasticForce Fq]=assembleElaQ(q,Init_Coor);

        v1=-ElasticForce-F_ext;%-Moment

        v=v1(Freedom_free);
        
        FQ=Fq;
        J=FQ(Freedom_free,Freedom_free);

        Deta=J\v;
        dif=norm(Deta);
        q(Freedom_free)=q(Freedom_free)+Deta;
        Deta_Full=zeros(NUMGEN,1);
        Deta_Full(Freedom_free)=Deta;
        Fq0=Fq;
        cont=cont+1;
    end
    cont1=cont1+cont;
    V=[V;q'];
    [Index cont]
end
cont1
format long
Num_1=NN;
% q(6*Num_1-5:6*Num_1-3)-q0(6*Num_1-5:6*Num_1-3)
[ 0 0 0]'-q(6*Num_1-5:6*Num_1-3)
q(6*Num_1-2:6*Num_1);
tha=atan(ans(3)/ans(1));
180-tha/pi*180;
