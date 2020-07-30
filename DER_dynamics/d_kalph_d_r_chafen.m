function [Mid1_1] = d_kalph_d_r_chafen(e,Length0,Kappa_fu_v,d_t_point_t_dr1k_,d_t_point_t_drk_,d_t_point_t_drk1_)
%   计算KALPH的一阶差分
%   此处显示详细说明
T1=(e(4:6)-e(1:3))/norm(e(4:6)-e(1:3));%
T2=(e(7:9)-e(4:6))/norm(e(7:9)-e(4:6));%
% Kappa=(2*skewF(T1)*T2)/(1+T1'*T2)/Length0;%;%----是逐点的
% 
% %----这里计算一个Kappa的数值导数
% ee=e;
% eps=1e-8;
% Mid10=zeros(3,9);
% for i=1:9
%     ee(i)=ee(i)+eps;
%     T1_F=(ee(4:6)-ee(1:3))/norm(ee(4:6)-ee(1:3));%
%     T2_F=(ee(7:9)-ee(4:6))/norm(ee(7:9)-ee(4:6));%
%     Kappa_F=2*skewF(T1_F)*T2_F/(1+T1_F'*T2_F)/Length0  ;%
% %     Kappa_F=(2*skewF(T1)*T2)/(1+T1_F'*T2_F)/Length0;    
%     Mid10(:,i)=(Kappa_F-Kappa)/eps;
%     ee(i)=ee(i)-eps;
% end
% Mid1_1=Mid10;
r_k1_k=e(7:9)-e(4:6);
r_k_1k=e(4:6)-e(1:3);
r_k1_1k=e(7:9)-e(1:3);
d_dotproduct_dr=[r_k_1k-r_k1_1k,r_k1_k-r_k_1k,r_k1_1k-r_k1_k];
para=[r_k1_k,-r_k1_1k,r_k_1k];

t_k=r_k1_k/norm(r_k1_k);%
t_1k=r_k_1k/norm(r_k_1k);%
v=1/(1+t_1k'*t_k);

[d_cross_r_d_r1k,d_cross_r_d_rk,d_cross_r_d_rk1] = DD_r_cross_r_Dr(para(:,1),para(:,2),para(:,3));
[l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1] = d_norm_r_r_dr(T1,T2,r_k_1k,r_k1_k);

d_t_cross_t_dr1k=d_cross_r_d_r1k/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_dr1k;
d_t_cross_t_drk=d_cross_r_d_rk/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_drk;
d_t_cross_t_drk1=d_cross_r_d_rk1/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_drk1;
d_t_point_t_dr1k=d_dotproduct_dr(:,1)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_dr1k;
d_t_point_t_drk=d_dotproduct_dr(:,2)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_drk;
d_t_point_t_drk1=d_dotproduct_dr(:,3)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_drk1;
% 2*cross(t_1k,t_k)*v^2 
% Kappa_fu_v
%   
Mid1_=2*v*(  d_t_cross_t_dr1k  ) - (  2*cross(t_1k,t_k)*v^2*d_t_point_t_dr1k  );%3x3%)%/Length0;%
Mid2_=2*v*(  d_t_cross_t_drk  ) - (  2*cross(t_1k,t_k)*v^2*d_t_point_t_drk  );%3x3%%/Length0;%
Mid3_=2*v*(  d_t_cross_t_drk1  ) - (  2*cross(t_1k,t_k)*v^2*d_t_point_t_drk1  );%3x3%%/Length0;%

Mid1_1=[Mid1_/Length0 Mid2_/Length0 Mid3_/Length0];

end

