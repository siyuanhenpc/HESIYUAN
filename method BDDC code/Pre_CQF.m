function [CQC,CQR]=Pre_CQF()
%--------CQC
global MX MY NDOFN
CQC=cell(4,1);
nc_=1;             %ȫ��c�����������ɵĲ�����ѡ��
CQC{1}=zeros(1*NDOFN,nc_*NDOFN);        %��һ��1��ÿ������ǵ������ȥ��Լ����
CQC{2}=zeros(1*NDOFN,nc_*NDOFN);
CQC{3}=zeros(1*NDOFN,nc_*NDOFN);
CQC{4}=zeros(1*NDOFN,nc_*NDOFN);

CQC{1}(1:2,1:2)=eye(1*NDOFN);
CQC{2}(1:2,1:2)=eye(1*NDOFN);
CQC{3}(1:2,1:2)=eye(1*NDOFN);
CQC{4}(1:2,1:2)=eye(1*NDOFN);

%--------CQR
global MNN_X MNN_Y  
CQR=cell(4,1);                 %վ��bool����ĽǶ����eye����ÿ������ġ���Լ��+�ǽǵ㡱���ɶ�����ÿ������ı߽�㣨�ֲ�λ�ã�
                               %վ��Լ������CQ�ĽǶ����+-�����ͷ���������С��ȷ����෴
ni_=(MNN_X-2)*(MNN_Y-2);        %���������ڲ������i(�����ɵĲ�����ѡ)
nr_=ni_+2;            %��������i+b�����������ɵĲ�����ѡ��
CQR{1}=zeros(2*NDOFN,nr_*NDOFN);
CQR{2}=zeros(2*NDOFN,nr_*NDOFN);
CQR{3}=zeros(2*NDOFN,nr_*NDOFN);
CQR{4}=zeros(2*NDOFN,nr_*NDOFN);

CQR{1}(1:2,3:4)=eye(NDOFN,NDOFN);  %���д
CQR{1}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{2}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{2}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{3}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{3}(3:4,5:6)=eye(NDOFN,NDOFN);

CQR{4}(1:2,1:2)=-eye(NDOFN,NDOFN);
CQR{4}(3:4,3:4)=-eye(NDOFN,NDOFN);

return