function []=LMF(~)%NUMGEN, NDOFN, NNODE, NE , M , NN
%--------------�е�Ԫ�ڵ������ɵ�Ԫ���ɶȱ��

%LM=zeros(NE,NDOFN*NNODE);
%for k=1:NE
%    LM(k,:)=reshape(ID(:,LOC(k,:)),1,[]);
%end
global M NN NDOFN 
global LM LM1 LM2 LM_L LM_c  LM_Area_c_L  LM_Area_I_L  LM_Area_b_L  LM_Area_i_L LM_Area_r_L
%LM=LMF0;
%�����������ɶȱ�ţ�ȫ�֣�&������Ԫ���֣�
%  1  6  12 (12) 19  25
%  2  7  13  17  20  26
%  3  8  14 (14) 21  27
% (3) 9 (14)(14) 22 (27)
%  4  10 15  18  23  28
%  5  11 16 (16) 24  29

% LM1=[ 3, 4, 13,14, 11,12,1, 2;
%       13,14,25,26, 23,24,11,12;
% 	  5, 6, 15,16, 13,14,3, 4;
% 	  15,16,27,28, 25,26,13,14];
% LM2=[ 7, 8, 19,20, 17,18,5, 6;
%       19,20,29,30, 27,28,17,18;
%       9, 10,21,22, 19,20,7, 8;
%       21,22,31,32, 29,30,19,20];


%ȫ�����ɶȱ�ţ�ȫ��λ�ã�
global NNODE NE_all NE NE_X NE_Y
LM=zeros(NE_all,NNODE*NDOFN);
NUM=2;
for I=1:NE_X
    for J=1:NE_Y
        LM(NE_Y*(I-1)+J,:)=[ 2*NUM-1,2*NUM,2*(NUM+NE_Y+1)-1,2*(NUM+NE_Y+1),2*(NUM+NE_Y)-1,2*(NUM+NE_Y),2*(NUM-1)-1,2*(NUM-1) ];
        NUM=NUM+1;
    end
    NUM=NUM+1;
end
LM1=LM(1:NE{1},:);
LM2=LM((NE{1}+1):(NE{1}+NE{2}),:);

%�����������ɶȱ�ţ��ֲ�λ�ã�&������Ԫ���֣�
%-----------1  4  7
%-----------2  5  8
%-----------3  6  9
LM_L=cell(4,1);
LM_L{1}=LM1;
LM_L{2}=LM(1:NE{2},:);


%�ǵ����ɶ���
LM_c=[41,42,49,50];
%�ǵ����ɶȱ��(ȫ��)
LM_Area_c=cell(M,1);
LM_Area_c{1}=[];
LM_Area_c{2}=[];
%�ǵ����ɶȱ��(Local)
LM_Area_c_L=cell(M,1);
LM_Area_c_L{1}=[ 31,32,39,40];         %ע��ֲ����Ӧ����ȥ��Լ���߽�֮���������е�����±��
LM_Area_c_L{2}=[ 1,2,9,10];

%�߽�ǽǵ����ɶȱ�ţ�ȫ�֣�
LM_Area_b=cell(M,1);
LM_Area_b{1}=[];
LM_Area_b{2}=[];
%�߽�ǽǵ����ɶȱ�ţ�Local��
LM_Area_b_L=cell(M,1);
LM_Area_b_L{1}=[ 33 34 35 36 37 38 ];    %ע��ֲ����Ӧ����ȥ��Լ���߽�֮���������е�����±��
LM_Area_b_L{2}=[ 3,4,5,6,7,8 ];

%�ڲ����ɶȱ�ţ�ȫ�֣�
LM_Area_i=cell(M,1);
LM_Area_i{1}=[];
LM_Area_i{2}=[];
%�ڲ����ɶȱ�ţ�Local��
LM_Area_i_L=cell(M,1);
LM_Area_i_L{1}=1:30;%ע��ֲ����Ӧ����ȥ��Լ���߽�֮���������е�����±��
LM_Area_i_L{2}=11:40;

%�ڲ�+�ǽǵ�߽����ɶȱ�ţ�Local�����������̶����ɶȣ�
LM_Area_r_L=cell(M,1);
LM_Area_r_L{1}=sort([LM_Area_i_L{1},LM_Area_b_L{1}]);
LM_Area_r_L{2}=sort([LM_Area_i_L{2},LM_Area_b_L{2}]);

%�������ɶȱ�ţ�Local��
LM_Area_I_L=cell(M,1);
LM_Area_I_L{1}=sort([LM_Area_c_L{1},LM_Area_b_L{1}]);    %ע��ֲ����Ӧ����ȥ��Լ���߽�֮���������е�����±��
LM_Area_I_L{2}=sort([LM_Area_c_L{2},LM_Area_b_L{2}]);

%------------�ڵ����ɶȱ��
% IDD=1:NUMGEN;
% IDD=1:(MNN*NDOFN);
% ID=reshape(IDD,NDOFN,[]);
% DOF_NNOFN=zeros(NN,NDOFN);
% for k=1:NN
%     DOF_NNOFN(k,:)=reshape(ID(:,k),1,[]);
% end
end