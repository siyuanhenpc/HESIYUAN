function m = CT(t,q,LM_S,NUMGEN,EleInf_S)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
NE_S=size(LM_S,1);

m=zeros(NE_S,1);
for i=1:NE_S
    m(i)=norm(q(LM_S(i,1:3))-q(LM_S(i,4:6)))^2-EleInf_S(i,1)^2;
end

end

