function m=fi(t,q)
global LM_S LM_B NE_S NE_B EleInf_S

%一端抖动的
m=[
    q(1)
    q(2)
    q(3) - cos(2*pi*t)/(2*pi) + 1/(2*pi)];

%一端抖动1s的

% if t<=1
%     m=[
%         q(1)
%         q(2)
%         q(3) - cos(2*pi*t)/(2*pi) + 1/(2*pi)];
% else
%     m=[
%         q(1)
%         q(2)
%         q(3)];    
% end

% %一端抖动+单元满足长度约束
% m=zeros(3+NE_S,1);
% m(1:3)=[ q(1)
%          q(2)
%          q(3)-cos(2*pi*t)/(2*pi) + 1/(2*pi) ];
% for i=1:NE_S
%     m(3+i)=norm(q(LM_S(i,1:3))-q(LM_S(i,4:6)))^2-EleInf_S(i,1)^2;
% end

% %单元满足长度约束
% m=zeros(NE_S,1);
% for i=1:NE_S
%     m(i)=norm(q(LM_S(i,1:3))-q(LM_S(i,4:6)))^2-EleInf_S(i,1)^2;
% end



return