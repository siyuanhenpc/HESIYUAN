function [mid] = CT_lamda_chafen(q,Lam2,LM_S,EleInf_S)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
NE_S=size(LM_S,1);
mid=0;
for i=1:NE_S
    delata_q=q(LM_S(i,1:3))-q(LM_S(i,4:6));
    mid=mid+Lam2(i)*(norm(delata_q)^2-1^2);%EleInf_S(i,1)
end

end

