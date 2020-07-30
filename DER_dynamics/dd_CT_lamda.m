function ddCT_lamda= d_CQ_q_t1(t,q_lamda,LM_S,NUMGEN,EleInf_S)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

NE_S=size(LM_S,1);
q=q_lamda(1:NUMGEN,1);
Lam2=q_lamda(NUMGEN+1:end,1);

% q=[0;0;0;1;0;0;2;0;0];
% %下面计算Mid0由数值差分得到的结果
% q0=q;
% delta=1e-6;
% Mid0_chafen=zeros(NUMGEN,NUMGEN);
% for i=1:NUMGEN
%     q(i)=q(i)+delta/2;
%     FF1 = CT_lamda_chafen_2jie(q,Lam2,LM_S,EleInf_S,NUMGEN);
%     q0(i)=q0(i)-delta/2;
%     FF0 = CT_lamda_chafen_2jie(q0,Lam2,LM_S,EleInf_S,NUMGEN);
%     Mid0_chafen(:,i)=(FF1-FF0)/delta;
%     q(i)=q(i)-delta/2;
%     q0(i)=q0(i)+delta/2;
% end

Mid0=zeros(NUMGEN,NUMGEN);
for i=1:NE_S
    lm=LM_S(i,:);
    r_r=q(LM_S(i,1:3))-q(LM_S(i,4:6));
    mid00=2*[ Lam2(i)*eye(3) -Lam2(i)*eye(3);
             -Lam2(i)*eye(3)  Lam2(i)*eye(3) ]/norm(r_r);
    
    mid01=-2*Lam2(i)*[ (r_r*r_r') -(r_r*r_r');
                      -(r_r*r_r')  (r_r*r_r') ]/norm(r_r)^3;
    Mid0(lm,lm)=Mid0(lm,lm)+mid00+mid01;
end

Mid1=zeros(NE_S,NUMGEN);
mid1=zeros(NE_S,3*NE_S);
for i=1:NE_S
    mid1(i,3*i-2:3*i)=2*(q(LM_S(i,1:3))-q(LM_S(i,4:6)))'/norm(q(LM_S(i,1:3))-q(LM_S(i,4:6)));
end
Mid1(1:NE_S,1:3*NE_S)=mid1;
Mid1(1:NE_S,NUMGEN-3*NE_S+1:NUMGEN)=Mid1(1:NE_S,NUMGEN-3*NE_S+1:NUMGEN)-mid1;

Mid2=zeros(NE_S,NE_S);

ddCT_lamda=[Mid0 Mid1'
            Mid1 Mid2];
end

