function [Mid_100] = d_l_norm_r_r_dr_dr_chafen(e,Length0)
%   计算1/norm()norm()的一阶差分
%   此处显示详细说明
T1=(e(4:6)-e(1:3))/norm(e(4:6)-e(1:3));%
T2=(e(7:9)-e(4:6))/norm(e(7:9)-e(4:6));%
r_k_1k=e(4:6)-e(1:3);
r_k1_k=e(7:9)-e(4:6);

l_norm_r_r=1/norm(r_k_1k)/norm(r_k1_k);

ee=e;
eps=1e-07;
Mid_100=zeros(1,9);
for i=1:9
    ee(i)=ee(i)+eps;
    r_k_1k_F=(ee(4:6)-ee(1:3));%
    r_k1_k_F=(ee(7:9)-ee(4:6));%
    l_norm_r_r_F=1/norm(r_k_1k_F)/norm(r_k1_k_F);%/Length0 %2*(-v)* /(1+T1_F'*T2_F)
    Mid_100(1,i)=(l_norm_r_r_F-l_norm_r_r)/eps;
    ee(i)=ee(i)-eps;
end

end

