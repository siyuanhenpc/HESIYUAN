function [LM DOF_NNOFN]=LMF_S(NUMGEN, NDOFN, NNODE, NE, LOC, NN)
%--------------�е�Ԫ�ڵ������ɵ�Ԫ���ɶȱ��

IDD=1:NUMGEN;
ID=reshape(IDD,NDOFN,[]);
LM=zeros(NE,NDOFN*NNODE);
for k=1:NE
    LM(k,:)=reshape(ID(:,LOC(k,:)),1,[]);
end


%------------�ڵ����ɶȱ��
DOF_NNOFN=zeros(NN,NDOFN);
for k=1:NN
    DOF_NNOFN(k,:)=reshape(ID(:,k),1,[]);
end
end