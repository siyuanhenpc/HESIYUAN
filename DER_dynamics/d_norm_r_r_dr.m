function [l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1] = d_norm_r_r_dr(T1,T2,r_k_1k,r_k1_k)
%   1/norm(r_k_1k)norm(r_k1_k)对广义坐标的导数
%   此处显示详细说明
l_norm_r_r_dr1k=-(-T1/norm(r_k_1k))'/(norm(r_k_1k)*norm(r_k1_k));
l_norm_r_r_drk=-(T1/norm(r_k_1k)-T2/norm(r_k1_k))'/(norm(r_k_1k)*norm(r_k1_k));
l_norm_r_r_drk1=-(T2/norm(r_k1_k))'/(norm(r_k_1k)*norm(r_k1_k));
end

