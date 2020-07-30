function [norm_t_cross_t_dr1k_dr1k,norm_t_cross_t_drk_drk,norm_t_cross_t_drk1_drk1,norm_t_cross_t_dr1k_drk,norm_t_cross_t_dr1k_drk1,norm_t_cross_t_drk_drk1,norm_t_cross_t_dr1k,norm_t_cross_t_drk,norm_t_cross_t_drk1] = DD_norm_t_cross_t_DrDr(d_cross_r_d_r1,d_cross_r_d_r2,d_cross_r_d_r3,Mid1_,Mid2_,Mid3_,Kappa,v,t_1k_,t_k)
%   生成norm(t_k-1_叉积t_k)关于9个自由度的二阶导数9x9
%   此处显示详细说明

%%
norm_t_cross_t_dr1k=1/norm(Kappa)*Kappa.*Mid1_/v/2;
norm_t_cross_t_drk=1/norm(Kappa)*Kappa.*Mid2_/v/2;
norm_t_cross_t_drk1=1/norm(Kappa)*Kappa.*Mid3_/v/2;

%%

l_norm_r_r_dr1k_dr1k= ( t_1k/norm(r_k_1k)*l_norm_r_r_dr1k + t_1k*t_1k'/norm(r_k_1k)^2/norm(r_k_1k)/norm(r_k1_k) );%reshape(,9,1)
l_norm_r_r_drk_drk= ( (-t_1k/norm(r_k_1k)+t_k/norm(r_k1_k))*l_norm_r_r_drk + (t_1k*t_k'/norm(r_k_1k)^2+t_k*t_k'/norm(r_k1_k)^2)/norm(r_k_1k)/norm(r_k1_k) );%reshape(,9,1)
l_norm_r_r_drk1_drk1=( -t_k/norm(r_k1_k)*l_norm_r_r_drk1 - t_k*t_k'/norm(r_k1_k)^2/norm(r_k_1k)/norm(r_k1_k) );%reshape(,9,1)

d_cross_r_d_r1k_l_norm_r_r_dr1k=[d_cross_r_d_r1k*l_norm_r_r_dr1k(1)  d_cross_r_d_r1k*l_norm_r_r_dr1k(2)  d_cross_r_d_r1k*l_norm_r_r_dr1k(3)];
d_cross_r_d_rk_l_norm_r_r_drk=[d_cross_r_d_rk*l_norm_r_r_dr1k(1)  d_cross_r_d_rk*l_norm_r_r_dr1k(2)  d_cross_r_d_rk*l_norm_r_r_dr1k(3)];
d_cross_r_d_rk1_l_norm_r_r_drk1=[d_cross_r_d_rk1*l_norm_r_r_dr1k(1)  d_cross_r_d_rk1*l_norm_r_r_dr1k(2)  d_cross_r_d_rk1*l_norm_r_r_dr1k(3)];
l_norm_r_r_dr1k_dr1k_cross=[l_norm_r_r_dr1k_dr1k*cross_r_r(1) l_norm_r_r_dr1k_dr1k*cross_r_r(2) l_norm_r_r_dr1k_dr1k*cross_r_r(3)];
l_norm_r_r_drk_drk_cross=[l_norm_r_r_drk_drk*cross_r_r(1) l_norm_r_r_drk_drk*cross_r_r(2) l_norm_r_r_drk_drk*cross_r_r(3)];
l_norm_r_r_drk1_drk1_cross=[l_norm_r_r_drk1_drk1*cross_r_r(1) l_norm_r_r_drk1_drk1*cross_r_r(2) l_norm_r_r_drk1_drk1*cross_r_r(3)];

t_cross_t_1k_1k = d_cross_r_d_r1k_l_norm_r_r_dr1k + d_cross_r_d_r1k_l_norm_r_r_dr1k + l_norm_r_r_dr1k_dr1k_cross;%3x9
t_cross_t_k_k = d_cross_r_d_rk_l_norm_r_r_drk + d_cross_r_d_rk_l_norm_r_r_drk + l_norm_r_r_drk_drk_cross;%3x9
t_cross_t_k1_k1 = d_cross_r_d_rk1_l_norm_r_r_drk1 + d_cross_r_d_rk1_l_norm_r_r_drk1 + l_norm_r_r_drk1_drk1_cross;%3x9

%%

cross_r_1k_k=[0  0  0  0  0 -1  0  1  0;
              0  0  1  0  0  0  -1 0  0;
              0 -1  0  1  0  0  0  0  0];
cross_r_1k_k1=[0  0  0  0  0 -1  0  1 0;
               0  0 -1  0  0  0  -1 0 0;
               0  1  0  1  0  0  0  0 0];
cross_r_k_k1=[0  0  0  0  0  1  0 -1  0;
              0  0  1  0  0  0  1  0  0;
              0 -1  0  -1 0  0  0  0  0];
l_norm_r_r_dr1k_drk=( -t_1k*t_1k'/norm(r_k_1k)^2/norm(r_k_1k)/norm(r_k1_k) + (-t_1k/norm(r_k_1k)+t_k/norm(r_k1_k))*l_norm_r_r_dr1k );%reshape(,9,1) 
l_norm_r_r_dr1k_drk1=( -t_k/norm(r_k1_k)*l_norm_r_r_dr1k );%reshape(,9,1) 
l_norm_r_r_drk_drk1=( -t_k*t_k'/norm(r_k1_k)^2/norm(r_k_1k)/norm(r_k1_k) + (-t_k)/norm(r_k1_k)*l_norm_r_r_drk );%reshape(,9,1)

d_cross_r_d_rk_l_norm_r_r_dr1k=[d_cross_r_d_rk*l_norm_r_r_dr1k(1)  d_cross_r_d_rk*l_norm_r_r_dr1k(2)  d_cross_r_d_rk*l_norm_r_r_dr1k(3)];
d_cross_r_d_rk1_l_norm_r_r_dr1k=[d_cross_r_d_rk1*l_norm_r_r_dr1k(1)  d_cross_r_d_rk1*l_norm_r_r_dr1k(2)  d_cross_r_d_rk1*l_norm_r_r_dr1k(3)];
d_cross_r_d_rk1_l_norm_r_r_drk=[d_cross_r_d_rk1*l_norm_r_r_drk(1)  d_cross_r_d_rk1*l_norm_r_r_drk(2)  d_cross_r_d_rk1*l_norm_r_r_drk(3)];
l_norm_r_r_dr1k_drk_cross=[l_norm_r_r_dr1k_drk*cross_r_r(1) l_norm_r_r_dr1k_drk*cross_r_r(2) l_norm_r_r_dr1k_drk*cross_r_r(3)];
l_norm_r_r_dr1k_drk1_cross=[l_norm_r_r_dr1k_drk1*cross_r_r(1) l_norm_r_r_dr1k_drk1*cross_r_r(2) l_norm_r_r_dr1k_drk1*cross_r_r(3)];
l_norm_r_r_drk_drk1_cross=[l_norm_r_r_drk_drk1*cross_r_r(1) l_norm_r_r_drk_drk1*cross_r_r(2) l_norm_r_r_drk_drk1*cross_r_r(3)];

t_cross_t_1k_k = cross_r_1k_k/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk_l_norm_r_r_dr1k + d_cross_r_d_rk_l_norm_r_r_dr1k + l_norm_r_r_dr1k_drk_cross;%3x9
t_cross_t_1k_k1 = cross_r_1k_k1/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk1_l_norm_r_r_dr1k + d_cross_r_d_rk1_l_norm_r_r_dr1k + l_norm_r_r_dr1k_drk1_cross;%3x9
t_cross_t_k_k1 = cross_r_k_k1/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk1_l_norm_r_r_drk + d_cross_r_d_rk1_l_norm_r_r_drk + l_norm_r_r_drk_drk1_cross;%3x9

%%
norm_t_cross_t_dr1k_dr1k;
norm_t_cross_t_drk_drk;
norm_t_cross_t_drk1_drk1;
norm_t_cross_t_dr1k_drk;
norm_t_cross_t_dr1k_drk1;
norm_t_cross_t_drk_drk1;
end

