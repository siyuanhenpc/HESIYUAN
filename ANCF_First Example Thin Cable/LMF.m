function LM=LMF
%--------------�е�Ԫ�ڵ������ɵ�Ԫ���ɶȱ��
global NUMGEN NDOFN NNODE NE BLOC
IDD=1:NUMGEN;
ID=reshape(IDD,NDOFN,[]);
LM=zeros(NE,NDOFN*NNODE);
for k=1:NE
    LM(k,:)=reshape(ID(:,BLOC(k,:)),1,[]);
end
end