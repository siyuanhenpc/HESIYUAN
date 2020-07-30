function []=ElementInformation()

global NE_X NE_Y
global NE_all NE NN NDOFN NNODE NUMGEN_all NUMGEN MX MY M  EleInf GaussN
     
NE_X=7;
NE_Y=4;
NE_all=NE_X*NE_Y;%%--------------单元总数
NN=40;%------------节点总数
NDOFN=2;%--------节点自由度
NNODE=4;%-----------单元节点数
NUMGEN_all=NN*NDOFN;%%---------总自由度

MX=2;%-------水平方向划分数
MY=1;%-------竖直方向划分数
M=MX*MY;%%--------总划分数
% MNE=NE/M;%%%--------各区域单元数
% MNN_X=NE_X/MY+1;%%-----子区域水平方向节点数
% MNN_Y=NE_Y/MX+1;%%-----子区域竖直方向节点数
NE=cell(M,1);
NE{1}=16;
NE{2}=12;
NUMGEN=cell(M,1);
NUMGEN{1}=50;%--------区域1自由度
NUMGEN{2}=40;%--------区域2自由度

GaussN=5;

% NUM=2;
% for I=1:NE_X
%     for J=1:NE_Y
%         LOC(NE_Y*(I-1)+J,:)=[ NUM,NUM+NE_Y+1,NUM+NE_Y,NUM-1 ];
%         NUM=NUM+1;
%     end
%     NUM=NUM+1;
% end

%--------------------平板尺寸
PLx=1;
PLy=1;
%--------------------element  parameter
EPLx=PLx/NE_X;
EPLy=PLy/NE_Y;
PCoeff=EPLx*EPLy/4;
E=1e6;
Mu=0.0;
th=1;
%------------------EleInf
EleInf=zeros(NE_all,6);
for i=1:NE_X
    for j=1:NE_Y
        k=(i-1)*NE_Y+j;
        EleInf(k,:)=[EPLx,EPLy,th,PCoeff,E,Mu];
    end
end

end