function [CQC,CQR]=Pre_CQF()
%--------CQC
global MX MY NDOFN
CQC=cell(4,1);
nc_=1;             %全部c个数（从自由的部分挑选）
CQC{1}=zeros(1*NDOFN,nc_*NDOFN);        %第一个1是每个区域角点个数（去掉约束）
CQC{2}=zeros(1*NDOFN,nc_*NDOFN);
CQC{3}=zeros(1*NDOFN,nc_*NDOFN);
CQC{4}=zeros(1*NDOFN,nc_*NDOFN);

CQC{1}(1:2,1:2)=eye(1*NDOFN);
CQC{2}(1:2,1:2)=eye(1*NDOFN);
CQC{3}(1:2,1:2)=eye(1*NDOFN);
CQC{4}(1:2,1:2)=eye(1*NDOFN);

%--------CQR
global MNN_X MNN_Y  
CQR=cell(4,1);                 %站在bool矩阵的角度理解eye：从每个区域的“非约束+非角点”自由度挑出每个区域的边界点（局部位置）
                               %站在约束矩阵CQ的角度理解+-：力和反作用力大小相等方向相反
ni_=(MNN_X-2)*(MNN_Y-2);        %单个区域内部点个数i(从自由的部分挑选)
nr_=ni_+2;            %单个区域i+b个数（从自由的部分挑选）
CQR{1}=zeros(2*NDOFN,nr_*NDOFN);
CQR{2}=zeros(2*NDOFN,nr_*NDOFN);
CQR{3}=zeros(2*NDOFN,nr_*NDOFN);
CQR{4}=zeros(2*NDOFN,nr_*NDOFN);

CQR{1}(1:2,3:4)=eye(NDOFN,NDOFN);  %逐点写
CQR{1}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{2}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{2}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{3}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{3}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{4}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{4}(3:4,3:4)=-eye(NDOFN,NDOFN);

return