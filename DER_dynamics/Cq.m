function [m]=Cq(q,NUMGEN)
global  LM_S LM_B NE_S NE_B EleInf_S

%һ�˶�����
m=zeros(3,NUMGEN);
m=[eye(3) zeros(3,NUMGEN-3)];

% %һ�˶���+��Ԫ���㳤��Լ��
% m=zeros(NE_S+3,NUMGEN);
% m(1:3,:)=[eye(3) zeros(3,NUMGEN-3)];
% for i=1:NE_S
%     m(i+3,3*i-2:3*i+3)=[2*(q(LM_S(i,1:3))-q(LM_S(i,4:6))) ; -2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)))]';
% end

% %��Ԫ���㳤��Լ��
% m=zeros(NE_S,NUMGEN);
% for i=1:NE_S
%     m(i,3*i-2:3*i+3)=[2*(q(LM_S(i,1:3))-q(LM_S(i,4:6))) ; -2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)))]';
% end


return