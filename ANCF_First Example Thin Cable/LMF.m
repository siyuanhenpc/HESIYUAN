function LM=LMF
%--------------有单元节点编号生成单元自由度编号
global NUMGEN NDOFN NNODE NE BLOC
IDD=1:NUMGEN;
ID=reshape(IDD,NDOFN,[]);
LM=zeros(NE,NDOFN*NNODE);
for k=1:NE
    LM(k,:)=reshape(ID(:,BLOC(k,:)),1,[]);
end
end