function [mid] = CT_lamda_chafen_2jie(q,Lam2,LM_S,EleInf_S,NUMGEN)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
q0=q;
delta=1e-6;
mid=zeros(NUMGEN,1);
for i=1:NUMGEN
    q(i)=q(i)+delta/2;
    EE1 = CT_lamda_chafen(q,Lam2,LM_S,EleInf_S);
    q0(i)=q0(i)-delta/2;
    EE0 = CT_lamda_chafen(q0,Lam2,LM_S,EleInf_S);
    mid(i,1)=(EE1-EE0)/delta;
    q(i)=q(i)-delta/2;
    q0(i)=q0(i)+delta/2;
end

end

