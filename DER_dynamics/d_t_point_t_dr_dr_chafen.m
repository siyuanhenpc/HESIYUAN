function [Mid_100] = d_t_point_t_dr_dr_chafen(e,Length0)
%   计算t(k-1)*t(k)的一阶差分
%   此处显示详细说明
T1=(e(4:6)-e(1:3))/norm(e(4:6)-e(1:3));%
T2=(e(7:9)-e(4:6))/norm(e(7:9)-e(4:6));%

T1_point_T2=T1'*T2;
ee=e;
eps=1e-07;
Mid_100=zeros(1,9);
for i=1:9
    ee(i)=ee(i)+eps;
    T1_F=(ee(4:6)-ee(1:3))/norm(ee(4:6)-ee(1:3));%
    T2_F=(ee(7:9)-ee(4:6))/norm(ee(7:9)-ee(4:6));%
    T1_point_T2_F=T1_F'*T2_F;%/Length0 %2*(-v)* /(1+T1_F'*T2_F)
    Mid_100(1,i)=(T1_point_T2_F-T1_point_T2)/eps;
    ee(i)=ee(i)-eps;
end

end

