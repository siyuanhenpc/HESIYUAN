function [delta_f_plus,delta_f_minus] = delta_f_cal(u_start,gamma,M,lamda1)
%   计算各节点处流通量跳跃值
%   此处显示详细说明
delta_u = u_start(:,2:M+4)-u_start(:,1:M+3);
D_average=(u_start(1,2:M+4)./u_start(1,1:M+3)).^0.5;
u_average=( lamda1(1,1:M+3)+D_average.*lamda1(1,2:M+4) )./( ones(1,M+3)+D_average );
h=gamma*(u_start(3,:)-1/2*lamda1.^2);
h_average=( h(1:M+3)+D_average.*h(2:M+4) )./( ones(1,M+3)+D_average );
a_average=( (gamma-1)*(h_average-1/2*u_average.^2) ).^0.5;

delta_f_plus = zeros(3,M+2);
delta_f_minus = zeros(3,M+2);
for i=1:3
    delta_f_plus(i,:)=a_average(1:M+2).*delta_u(i,1:M+2);
    delta_f_minus(i,:)=a_average(2:M+3).*delta_u(i,2:M+3);
end

end

