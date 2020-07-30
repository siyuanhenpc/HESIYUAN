function m = d_CT(t,q,LM_S,NUMGEN,EleInf_S)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

NE_S=size(LM_S,1);

m=zeros(NUMGEN,NE_S);
for i=1:NE_S
    m(3*i-2:3*i+3,i)=[2*(q(LM_S(i,1:3))-q(LM_S(i,4:6))) ; -2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)))];
end

end

