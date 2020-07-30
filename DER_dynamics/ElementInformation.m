function [NE_S, NE_B, NN, NDOFN, NNODE_S, NNODE_B, NUMGEN, LOC_S, LOC_B, EleInf_S, EleInf_B]=ElementInformation(NUM_Point)

NE_S=NUM_Point-1;%%--------------单元总数
NE_B=NUM_Point-2;%NUM_Point-2-(2*30-1)%%--------------单元总数
NN=NUM_Point;%------------节点总数
NDOFN=3;%--------节点自由度
NNODE_S=2;%-----------单元节点数
NNODE_B=3;%-----------单元节点数
NUMGEN=NN*NDOFN;%---------总自由度



LOC_S=zeros(NE_S,2); %--------------%拉伸单元节点编号
NUM=1;
for I=1:NE_S
    LOC_S(I,:)=[ NUM,NUM+1 ];
    NUM=NUM+1;
end

LOC_B=zeros(NE_B,3);%Model%--------------%弯曲单元节点编号
NUM=1;
for I=1:NE_B
    LOC_B(I,:)=[ NUM,NUM+1,NUM+2 ];
    NUM=NUM+1;
end

%---------------------
Lx=30;
E=2e+11;%
A=pi*(3e-4)^2;%认为梁界面近似为圆面
I=A^2/4/pi;


%------------------EleInf
EleInf_S=zeros(NE_S,4);
EPLx_S=Lx/NE_S;
for i=1:NE_S
    EleInf_S(i,:)=[EPLx_S,E,A,0];
end

%%
EleInf_B=zeros(NE_B,4);
for i=1:NE_B
    if i==1%
        EPLx_B=1.5*Lx/NE_S;
    elseif i==NE_B%
        EPLx_B=1.5*Lx/NE_S;
    else
        EPLx_B=Lx/NE_S;
    end
    
    EleInf_B(i,:)=[EPLx_B,E,0,I];
end



end