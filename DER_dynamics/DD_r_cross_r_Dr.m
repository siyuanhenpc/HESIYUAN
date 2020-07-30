function [d_cross_d_r1,d_cross_d_r2,d_cross_d_r3] = DD_r_cross_r_Dr(a,b,c)
%   生成cross(r_k_1k,r_k1_k)对广义坐标r_1k,r_k,r_k1偏导后得到的反对称矩阵
%   此处显示详细说明
d_cross_d_r1=zeros(3,3);
d_cross_d_r1(1,2)=-a(3);
d_cross_d_r1(2,1)=a(3);
d_cross_d_r1(1,3)=a(2);
d_cross_d_r1(3,1)=-a(2);
d_cross_d_r1(2,3)=-a(1);
d_cross_d_r1(3,2)=a(1);

d_cross_d_r2=zeros(3,3);
d_cross_d_r2(1,2)=-b(3);
d_cross_d_r2(2,1)=b(3);
d_cross_d_r2(1,3)=b(2);
d_cross_d_r2(3,1)=-b(2);
d_cross_d_r2(2,3)=-b(1);
d_cross_d_r2(3,2)=b(1);

d_cross_d_r3=zeros(3,3);
d_cross_d_r3(1,2)=-c(3);
d_cross_d_r3(2,1)=c(3);
d_cross_d_r3(1,3)=c(2);
d_cross_d_r3(3,1)=-c(2);
d_cross_d_r3(2,3)=-c(1);
d_cross_d_r3(3,2)=c(1);
end

