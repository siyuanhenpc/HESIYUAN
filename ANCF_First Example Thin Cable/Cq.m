function m=Cq(q)
global NUMGEN LM NE
q1=LM(NE,10:12);
q2=q(LM(NE,10:12));
m=zeros(1,NUMGEN);
% m(1:6,1:6)=eye(6);
% m(1,q1)=[ 2*q2(1),2*q2(2),2*q2(3) ];


m=[eye(3) zeros(3,NUMGEN-3)];

%     zeros(3) eye(3) zeros(3,NUMGEN-6)

return