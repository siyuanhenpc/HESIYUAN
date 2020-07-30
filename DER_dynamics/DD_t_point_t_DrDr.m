function [t_point_t_1k_1k,t_point_t_k_k,t_point_t_k1_k1,t_point_t_k_1k,t_point_t_k1_1k,t_point_t_k1_k] = DD_t_point_t_DrDr(Kappa,r_k_1k,r_k1_k,l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1,l_norm_r_r_dr1k_dr1k,l_norm_r_r_drk_drk,l_norm_r_r_drk1_drk1,l_norm_r_r_dr1k_drk,l_norm_r_r_dr1k_drk1,l_norm_r_r_drk_drk1)
%   生成t_k-1_点乘t_k关于9个自由度的二阶导数
%   此处显示详细说明
r_k_k1=-r_k1_k;

% %kalph_t_point_t_1k_1k,kalph_t_point_t_k_k,kalph_t_point_t_k1_k1,kalph_t_point_t_k_1k,kalph_t_point_t_k1_1k,kalph_t_point_t_k1_k,
% kalph_t_point_t_1k_1k= l_norm_r_r_dr1k'*(Kappa'*r_k_k1) + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_dr1k*Kappa+l_norm_r_r_dr1k*Kappa*r_k_k1;
% kalph_t_point_t_k_k= -2*Kappa/norm(r_k1_k)/norm(r_k_1k)+l_norm_r_r_drk'*(Kappa'*r_k1_k-Kappa'*r_k_1k) + r_k_1k'*r_k1_k*l_norm_r_r_drk_drk*Kappa+l_norm_r_r_drk*Kappa*(r_k1_k-r_k_1k);
% kalph_t_point_t_k1_k1= l_norm_r_r_drk1'*(Kappa'*r_k_1k) + r_k_1k'*r_k1_k*l_norm_r_r_drk1_drk1*Kappa+l_norm_r_r_drk1*Kappa*r_k_1k;
% kalph_t_point_t_k_1k= Kappa/norm(r_k1_k)/norm(r_k_1k)+l_norm_r_r_drk'*(Kappa'*r_k_k1) + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_drk*Kappa+l_norm_r_r_dr1k*Kappa*(r_k1_k-r_k_1k);
% kalph_t_point_t_k1_1k= -Kappa/norm(r_k1_k)/norm(r_k_1k)+l_norm_r_r_drk1'*(Kappa'*r_k_k1) + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_drk1*Kappa+l_norm_r_r_dr1k*Kappa*r_k_1k;
% kalph_t_point_t_k1_k= Kappa/norm(r_k1_k)/norm(r_k_1k)+l_norm_r_r_drk1'*(Kappa'*r_k1_k-Kappa'*r_k_1k) + r_k_1k'*r_k1_k*l_norm_r_r_drk_drk1*Kappa+l_norm_r_r_drk*Kappa*r_k_k1;

t_point_t_1k_1k= r_k_k1*l_norm_r_r_dr1k + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_dr1k+l_norm_r_r_dr1k'*r_k_k1';
t_point_t_k_k= -2/norm(r_k1_k)/norm(r_k_1k)*eye(3) + (r_k1_k-r_k_1k)*l_norm_r_r_drk + r_k_1k'*r_k1_k*l_norm_r_r_drk_drk+l_norm_r_r_drk'*(r_k1_k-r_k_1k)';
t_point_t_k1_k1= r_k_1k*l_norm_r_r_drk1 + r_k_1k'*r_k1_k*l_norm_r_r_drk1_drk1 + l_norm_r_r_drk1'*r_k_1k';
t_point_t_k_1k= 1/norm(r_k1_k)/norm(r_k_1k)*eye(3) + r_k_k1*l_norm_r_r_drk + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_drk + l_norm_r_r_dr1k'*(r_k1_k-r_k_1k)';
t_point_t_k1_1k= -1/norm(r_k1_k)/norm(r_k_1k)*eye(3) + r_k_k1*l_norm_r_r_drk1 + r_k_1k'*r_k1_k*l_norm_r_r_dr1k_drk1 + l_norm_r_r_dr1k'*r_k_1k';
t_point_t_k1_k= 1/norm(r_k1_k)/norm(r_k_1k)*eye(3) + (r_k1_k-r_k_1k)*l_norm_r_r_drk1 + r_k_1k'*r_k1_k*l_norm_r_r_drk_drk1 + l_norm_r_r_drk'*r_k_1k';

end

