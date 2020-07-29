function [ f_plus,f_minus,lamda_plus,lamda_minus,a,lamda1 ] = f_cal( u_start,gamma,M )
%   计算节点处的流通量值
%   此处显示详细说明
lamda1 = u_start(2,:)./u_start(1,:);
p_divide_rho = (gamma-1)*(u_start(3,:)./u_start(1,:)-1/2*lamda1.^2);
a = sqrt(gamma*p_divide_rho);
lamda2 = lamda1-a;
lamda3 = lamda1+a;
lamda1_plus = (lamda1+(lamda1.^2+(1e-8)*ones(1,M+4)).^0.5)/2;
lamda2_plus = (lamda2+(lamda2.^2+(1e-8)*ones(1,M+4)).^0.5)/2;
lamda3_plus = (lamda3+(lamda3.^2+(1e-8)*ones(1,M+4)).^0.5)/2;
lamda1_minus = (lamda1-(lamda1.^2+1e-8*ones(1,M+4)).^0.5)/2;
lamda2_minus = (lamda2-(lamda2.^2+1e-8*ones(1,M+4)).^0.5)/2;
lamda3_minus = (lamda3-(lamda3.^2+1e-8*ones(1,M+4)).^0.5)/2;

f_plus(1,:)=u_start(1,:)/(2*gamma).*( 2*(gamma-1)*lamda1_plus+lamda2_plus+lamda3_plus );
f_plus(2,:)=u_start(1,:)/(2*gamma).*( 2*(gamma-1)*lamda1.*lamda1_plus+lamda2.*lamda2_plus+lamda3.*lamda3_plus );
h = gamma/(gamma-1)*p_divide_rho;
au = (lamda3.^2-lamda2.^2);
f_plus(3,:)=u_start(1,:)/(2*gamma).*( (gamma-1)*lamda1.^2.*lamda1_plus+(h-1/4*au).*lamda2_plus+(h+1/4*au).*lamda3_plus );
f_plus=f_plus(:,2:M+2);

f_minus(1,:)=u_start(1,:)/(2*gamma).*( 2*(gamma-1)*lamda1_minus+lamda2_minus+lamda3_minus );
f_minus(2,:)=u_start(1,:)/(2*gamma).*( 2*(gamma-1)*lamda1.*lamda1_minus+lamda2.*lamda2_minus+lamda3.*lamda3_minus );
f_minus(3,:)=u_start(1,:)/(2*gamma).*( (gamma-1)*lamda1.^2.*lamda1_minus+(h-1/4*au).*lamda2_minus+(h+1/4*au).*lamda3_minus );
f_minus=f_minus(:,3:M+3);

lamda_plus=[lamda1_plus(3:M+2);lamda2_plus(3:M+2);lamda3_plus(3:M+2)];
lamda_minus=[lamda1_minus(3:M+2);lamda2_minus(3:M+2);lamda3_minus(3:M+2)];

end

