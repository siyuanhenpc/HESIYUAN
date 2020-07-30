function []=LMF(~)%NUMGEN, NDOFN, NNODE, NE , M , NN
%--------------有单元节点编号生成单元自由度编号

%LM=zeros(NE,NDOFN*NNODE);
%for k=1:NE
%    LM(k,:)=reshape(ID(:,LOC(k,:)),1,[]);
%end
global M NN NDOFN 
global LM LM1 LM2 LM_L LM_c  LM_Area_c_L  LM_Area_I_L  LM_Area_b_L  LM_Area_i_L LM_Area_r_L
%LM=LMF0;
%各区域总自由度编号（全局）&（按单元划分）
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


%全部自由度编号（全局位置）
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

%各区域总自由度编号（局部位置）&（按单元划分）
%-----------1  4  7
%-----------2  5  8
%-----------3  6  9
LM_L=cell(4,1);
LM_L{1}=LM1;
LM_L{2}=LM(1:NE{2},:);


%角点自由度总
LM_c=[41,42,49,50];
%角点自由度编号(全局)
LM_Area_c=cell(M,1);
LM_Area_c{1}=[];
LM_Area_c{2}=[];
%角点自由度编号(Local)
LM_Area_c_L=cell(M,1);
LM_Area_c_L{1}=[ 31,32,39,40];         %注意局部编号应该用去掉约束边界之后其余所有点的重新编号
LM_Area_c_L{2}=[ 1,2,9,10];

%边界非角点自由度编号（全局）
LM_Area_b=cell(M,1);
LM_Area_b{1}=[];
LM_Area_b{2}=[];
%边界非角点自由度编号（Local）
LM_Area_b_L=cell(M,1);
LM_Area_b_L{1}=[ 33 34 35 36 37 38 ];    %注意局部编号应该用去掉约束边界之后其余所有点的重新编号
LM_Area_b_L{2}=[ 3,4,5,6,7,8 ];

%内部自由度编号（全局）
LM_Area_i=cell(M,1);
LM_Area_i{1}=[];
LM_Area_i{2}=[];
%内部自由度编号（Local）
LM_Area_i_L=cell(M,1);
LM_Area_i_L{1}=1:30;%注意局部编号应该用去掉约束边界之后其余所有点的重新编号
LM_Area_i_L{2}=11:40;

%内部+非角点边界自由度编号（Local）（不包括固定自由度）
LM_Area_r_L=cell(M,1);
LM_Area_r_L{1}=sort([LM_Area_i_L{1},LM_Area_b_L{1}]);
LM_Area_r_L{2}=sort([LM_Area_i_L{2},LM_Area_b_L{2}]);

%界面自由度编号（Local）
LM_Area_I_L=cell(M,1);
LM_Area_I_L{1}=sort([LM_Area_c_L{1},LM_Area_b_L{1}]);    %注意局部编号应该用去掉约束边界之后其余所有点的重新编号
LM_Area_I_L{2}=sort([LM_Area_c_L{2},LM_Area_b_L{2}]);

%------------节点自由度编号
% IDD=1:NUMGEN;
% IDD=1:(MNN*NDOFN);
% ID=reshape(IDD,NDOFN,[]);
% DOF_NNOFN=zeros(NN,NDOFN);
% for k=1:NN
%     DOF_NNOFN(k,:)=reshape(ID(:,k),1,[]);
% end
end