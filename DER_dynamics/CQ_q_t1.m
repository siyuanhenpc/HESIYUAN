function m = CQ_q_t1(t,q,LM_S,NUMGEN,EleInf_S)
%   约束方程先点积降低阶数再求广义坐标导数
%   此处显示详细说明

NE_S=size(LM_S,1);
m=zeros(NUMGEN,NE_S);
for i=1:NE_S
    m(3*i-2:3*i+3,i)=[2*(q(LM_S(i,1:3))-q(LM_S(i,4:6))) ; -2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)))];
end

% NE_S=size(LM_S,1);
% q=q_lamda(1:NUMGEN,1);
% Lam2=q_lamda(NUMGEN+1:end,1);
% m1=zeros(NUMGEN,1);
% m1_=zeros(3*NE_S,1);
% for i=1:NE_S
%     m1_(3*i-2:3*i)=2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)));%*Lam2(i)
% end
% m1=[m1_;0;0;0]-[0;0;0;m1_];
% m=m1;
% m2=zeros(NE_S,1);
% for i=1:NE_S
%     m2(i)=norm(q(LM_S(i,1:3))-q(LM_S(i,4:6)))^2-EleInf_S(i,1)^2;
% end
% 
% m=[m1;m2];

end

