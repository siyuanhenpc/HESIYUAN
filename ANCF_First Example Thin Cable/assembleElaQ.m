function [F Fq]=assembleElaQ(q,q0)
global NUMGEN NE LM BEleInf
Fq=zeros(NUMGEN,NUMGEN);
F=zeros(NUMGEN,1);

FD=zeros(NUMGEN,1);
FDq=zeros(NUMGEN,NUMGEN);
FDdq=zeros(NUMGEN,NUMGEN);
for k=1:NE
    lm=LM(k,:);
    e=q(lm);
    e0=q0(lm);
    Coeff=BEleInf(k,6);
    Coeff1=BEleInf(k,7);
%     e=[1:12]';
    [Fk Fqq]=ElastF_N(e,e0,k,Coeff,Coeff1);
%     [Fk Fqq]=ElastF_N_Old(e,k,Coeff);
    Fq(lm,lm)=Fq(lm,lm)+Fqq;
    F(lm)=F(lm)+Fk;
end

end