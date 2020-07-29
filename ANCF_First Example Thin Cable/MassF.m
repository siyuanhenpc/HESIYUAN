function [Mass Gravity]=MassF(q0)
global NE NUMGEN LM BEleInf
Mass=zeros(NUMGEN,NUMGEN);
Gravity=zeros(NUMGEN,1);



for k=1:NE
    lm=LM(k,:);
    e0=q0(lm);
    L=BEleInf(k,1);
    A1=BEleInf(k,2);
    ro1=BEleInf(k,3);
    [M G]=MeII(e0,L,A1,ro1);
    Mass(lm,lm)=Mass(lm,lm)+M;
    Gravity(lm)=Gravity(lm)+G;
end

return