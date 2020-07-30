function []=ElementInformation()

global NE_X NE_Y
global NE_all NE NN NDOFN NNODE NUMGEN_all NUMGEN MX MY M  EleInf GaussN
     
NE_X=7;
NE_Y=4;
NE_all=NE_X*NE_Y;%%--------------��Ԫ����
NN=40;%------------�ڵ�����
NDOFN=2;%--------�ڵ����ɶ�
NNODE=4;%-----------��Ԫ�ڵ���
NUMGEN_all=NN*NDOFN;%%---------�����ɶ�

MX=2;%-------ˮƽ���򻮷���
MY=1;%-------��ֱ���򻮷���
M=MX*MY;%%--------�ܻ�����
% MNE=NE/M;%%%--------������Ԫ��
% MNN_X=NE_X/MY+1;%%-----������ˮƽ����ڵ���
% MNN_Y=NE_Y/MX+1;%%-----��������ֱ����ڵ���
NE=cell(M,1);
NE{1}=16;
NE{2}=12;
NUMGEN=cell(M,1);
NUMGEN{1}=50;%--------����1���ɶ�
NUMGEN{2}=40;%--------����2���ɶ�

GaussN=5;

% NUM=2;
% for I=1:NE_X
%     for J=1:NE_Y
%         LOC(NE_Y*(I-1)+J,:)=[ NUM,NUM+NE_Y+1,NUM+NE_Y,NUM-1 ];
%         NUM=NUM+1;
%     end
%     NUM=NUM+1;
% end

%--------------------ƽ��ߴ�
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