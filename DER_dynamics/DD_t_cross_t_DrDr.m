function [kalph_t_cross_t_1k_1k,kalph_t_cross_t_1k_k,kalph_t_cross_t_1k_k1,kalph_t_cross_t_k_k,kalph_t_cross_t_k_k1,kalph_t_cross_t_k1_k1,kalph_t_cross_t_r1k,kalph_t_cross_t_rk,kalph_t_cross_t_rk1,l_norm_r_r_dr1k_dr1k,l_norm_r_r_drk_drk,l_norm_r_r_drk1_drk1,l_norm_r_r_drk_dr1k,l_norm_r_r_drk1_dr1k,l_norm_r_r_drk1_drk] = DD_t_cross_t_DrDr(d_cross_r_d_r1k,d_cross_r_d_rk,d_cross_r_d_rk1,l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1,r_k_1k,r_k1_k,r_1k_k1,Kappa)
%   生成(t_k-1_叉积t_k)*kalph关于9个自由度的二阶导数3x3
%   此处显示详细说明

t_1k=r_k_1k/norm(r_k_1k);
t_k=r_k1_k/norm(r_k1_k);
cross_r_r=cross(r_k_1k,r_k1_k)';
%%
r_k1_1k=r_k1_k+r_k_1k;
[d_cross_r_d_r1,d_cross_r_d_r2,d_cross_r_d_r3] = DD_r_cross_r_Dr(r_k1_k,-r_k1_1k,r_k_1k);
%d_cross_r_d_r1*Kappa/norm(r_k1_k)/norm(r_k_1k)+cross(r_k_1k,r_k1_k)*(l_norm_r_r_dr1k*Kappa)
%d_cross_r_d_r2*Kappa/norm(r_k1_k)/norm(r_k_1k)+cross(r_k_1k,r_k1_k)*(l_norm_r_r_drk*Kappa)
%d_cross_r_d_r3*Kappa/norm(r_k1_k)/norm(r_k_1k)+cross(r_k_1k,r_k1_k)*(l_norm_r_r_drk1*Kappa)
kalph_t_cross_t_r1k=Kappa'*d_cross_r_d_r1/norm(r_k1_k)/norm(r_k_1k)+Kappa'*cross(r_k_1k,r_k1_k)*l_norm_r_r_dr1k;%
kalph_t_cross_t_rk=Kappa'*d_cross_r_d_r2/norm(r_k1_k)/norm(r_k_1k)+Kappa'*cross(r_k_1k,r_k1_k)*l_norm_r_r_drk;%
kalph_t_cross_t_rk1=Kappa'*d_cross_r_d_r3/norm(r_k1_k)/norm(r_k_1k)+Kappa'*cross(r_k_1k,r_k1_k)*l_norm_r_r_drk1;%
%correct
kalph_t_cross_t_r1k=kalph_t_cross_t_r1k';
kalph_t_cross_t_rk=kalph_t_cross_t_rk';
kalph_t_cross_t_rk1=kalph_t_cross_t_rk1';
%correct
l_norm_r_r_dr1k_dr1k= (  t_1k/norm(r_k_1k)*l_norm_r_r_dr1k + (t_1k*t_1k'*2-eye(3))/norm(r_k_1k)^2/norm(r_k_1k)/norm(r_k1_k) );%3x3
l_norm_r_r_drk_drk= ( (-t_1k/norm(r_k_1k)+t_k/norm(r_k1_k))*l_norm_r_r_drk + ( (t_1k*t_1k'*2-eye(3))/norm(r_k_1k)^2+(t_k*t_k'*2-eye(3))/norm(r_k1_k)^2 )/norm(r_k_1k)/norm(r_k1_k));%3x3
l_norm_r_r_drk1_drk1=( (-t_k)/norm(r_k1_k)*l_norm_r_r_drk1 - (-t_k*t_k'*2+eye(3))/norm(r_k1_k)^2/norm(r_k_1k)/norm(r_k1_k) );%3x3
% l_norm_r_r_drk_dr1k=(  (-t_1k/norm(r_k_1k)+t_k/norm(r_k1_k))*l_norm_r_r_dr1k - (t_1k*t_1k'*2-eye(3))/norm(r_k_1k)^2/norm(r_k_1k)/norm(r_k1_k)  );%3x3 
% l_norm_r_r_drk1_dr1k=(  (-t_k)/norm(r_k1_k)*l_norm_r_r_dr1k );%3x3 
% l_norm_r_r_drk1_drk=(  (-t_k)/norm(r_k1_k)*l_norm_r_r_drk - (t_k*t_k'*2-eye(3))/norm(r_k1_k)^2/norm(r_k_1k)/norm(r_k1_k)  );%3x3
% correct

d_cross_r_d_r1k_l_norm_r_r_dr1k=-(d_cross_r_d_r1k*Kappa)*l_norm_r_r_dr1k;%(3x3x3x1)x1x3 负号怎么来的？
d_cross_r_d_rk_l_norm_r_r_drk=-(d_cross_r_d_rk*Kappa)*l_norm_r_r_drk;%(3x3x3x1)x1x3 负号怎么来的？
d_cross_r_d_rk1_l_norm_r_r_drk1=-(d_cross_r_d_rk1*Kappa)*l_norm_r_r_drk1;%(3x3x3x1)x1x3 负号怎么来的？
l_norm_r_r_dr1k_dr1k_cross=(cross_r_r*Kappa)*l_norm_r_r_dr1k_dr1k;%(1x3x3x1)x3x3
l_norm_r_r_drk_drk_cross=(cross_r_r*Kappa)*l_norm_r_r_drk_drk;%(1x3x3x1)x3x3
l_norm_r_r_drk1_drk1_cross=(cross_r_r*Kappa)*l_norm_r_r_drk1_drk1;%(1x3x3x1)x3x3

kalph_t_cross_t_1k_1k = d_cross_r_d_r1k_l_norm_r_r_dr1k + d_cross_r_d_r1k_l_norm_r_r_dr1k' + l_norm_r_r_dr1k_dr1k_cross;%3x3
kalph_t_cross_t_k_k = d_cross_r_d_rk_l_norm_r_r_drk + d_cross_r_d_rk_l_norm_r_r_drk' + l_norm_r_r_drk_drk_cross;%3x3
kalph_t_cross_t_k1_k1 = d_cross_r_d_rk1_l_norm_r_r_drk1 + d_cross_r_d_rk1_l_norm_r_r_drk1' + l_norm_r_r_drk1_drk1_cross;%3x3
%correct
%%

Kappa_cross_r_1k_k=[0 Kappa(3) -Kappa(2);-Kappa(3) 0 Kappa(1);Kappa(2) -Kappa(1) 0];
Kappa_cross_r_1k_k1=[0 -Kappa(3) Kappa(2);Kappa(3) 0 -Kappa(1);-Kappa(2) Kappa(1) 0];
Kappa_cross_r_k_k1=[0 Kappa(3) -Kappa(2);-Kappa(3) 0 Kappa(1);Kappa(2) -Kappa(1) 0];

l_norm_r_r_drk_dr1k=(  (-t_1k/norm(r_k_1k)+t_k/norm(r_k1_k))*l_norm_r_r_dr1k - (t_1k*t_1k'*2-eye(3))/norm(r_k_1k)^2/norm(r_k_1k)/norm(r_k1_k)  );%3x3 
l_norm_r_r_drk1_dr1k=(  (-t_k)/norm(r_k1_k)*l_norm_r_r_dr1k );%3x3 
l_norm_r_r_drk1_drk=(  (-t_k)/norm(r_k1_k)*l_norm_r_r_drk - (t_k*t_k'*2-eye(3))/norm(r_k1_k)^2/norm(r_k_1k)/norm(r_k1_k)  );%3x3

d_cross_r_d_rk_l_norm_r_r_dr1k=-d_cross_r_d_rk*Kappa*l_norm_r_r_dr1k;%(3x3x3x1)x1x3 负号怎么来的？
d_cross_r_d_r1k_l_norm_r_r_drk=-d_cross_r_d_r1k*Kappa*l_norm_r_r_drk;
d_cross_r_d_rk1_l_norm_r_r_dr1k=-d_cross_r_d_rk1*Kappa*l_norm_r_r_dr1k;%(3x3x3x1)x1x3 负号怎么来的？
d_cross_r_d_r1k_l_norm_r_r_drk1=-d_cross_r_d_r1k*Kappa*l_norm_r_r_drk1;
d_cross_r_d_rk1_l_norm_r_r_drk=-d_cross_r_d_rk1*Kappa*l_norm_r_r_drk;%(3x3x3x1)x1x3 负号怎么来的？
d_cross_r_d_rk_l_norm_r_r_drk1=-d_cross_r_d_rk*Kappa*l_norm_r_r_drk1;
l_norm_r_r_dr1k_drk_cross=(cross_r_r*Kappa)*l_norm_r_r_drk_dr1k;%(1x3x3x1)x3x3 %(3x1x1x3)x3x3Kappa*cross_r_r
l_norm_r_r_dr1k_drk1_cross=(cross_r_r*Kappa)*l_norm_r_r_drk1_dr1k;%(1x3x3x1)x3x3 %(3x1x1x3)x3x3Kappa*cross_r_r
l_norm_r_r_drk_drk1_cross=(cross_r_r*Kappa)*l_norm_r_r_drk1_drk;%(1x3x3x1)x3x3 %(3x1x1x3)x3x3Kappa*cross_r_r

kalph_t_cross_t_1k_k = Kappa_cross_r_1k_k/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk_l_norm_r_r_dr1k' + d_cross_r_d_r1k_l_norm_r_r_drk + l_norm_r_r_dr1k_drk_cross';%3x9 第二四项转置？？？
kalph_t_cross_t_1k_k1 = Kappa_cross_r_1k_k1/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk1_l_norm_r_r_dr1k' + d_cross_r_d_r1k_l_norm_r_r_drk1 + l_norm_r_r_dr1k_drk1_cross';%3x9 第二四项转置？？？
kalph_t_cross_t_k_k1 = Kappa_cross_r_k_k1/norm(r_k_1k)/norm(r_k1_k) + d_cross_r_d_rk1_l_norm_r_r_drk' + d_cross_r_d_rk_l_norm_r_r_drk1 + l_norm_r_r_drk_drk1_cross';%3x9 第二四项转置？？？
%correct

end

