function [ElasticF, ElasticFq]=ElastFQ_B(Kappa_0,e,EleInf_1)

%下面认为设定e来测试几何刚度
% e=[0.02;0.00;0.00;0.04;0.01;0.00;0.06;0.04;0.00];

Length0=EleInf_1(1);
E=EleInf_1(2);
I=EleInf_1(4);
T1=(e(4:6)-e(1:3))/norm(e(4:6)-e(1:3));%
T2=(e(7:9)-e(4:6))/norm(e(7:9)-e(4:6));%

% Length=norm(e(4:6)-e(1:3));

Kappa=(2*skewF(T1)*T2)/(1+T1'*T2)/Length0-Kappa_0;%;%----是逐点的

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

%%
r_k1_k=e(7:9)-e(4:6);
r_k_1k=e(4:6)-e(1:3);
r_k1_1k=e(7:9)-e(1:3);
r_1k_k1=-r_k1_1k;
% r_k_k1=-r_k1_k;
d_dotproduct_dr=[r_k_1k-r_k1_1k,r_k1_k-r_k_1k,r_k1_1k-r_k1_k];
para=[r_k1_k,-r_k1_1k,r_k_1k];

t_k=r_k1_k/norm(r_k1_k);%
t_1k=r_k_1k/norm(r_k_1k);%
v=1/(1+t_1k'*t_k);

[d_cross_r_d_r1k,d_cross_r_d_rk,d_cross_r_d_rk1] = DD_r_cross_r_Dr(para(:,1),para(:,2),para(:,3));
[l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1] = d_norm_r_r_dr(T1,T2,r_k_1k,r_k1_k);
% 
% 
%
d_t_cross_t_dr1k=d_cross_r_d_r1k/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_dr1k;
d_t_cross_t_drk=d_cross_r_d_rk/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_drk;
d_t_cross_t_drk1=d_cross_r_d_rk1/(norm(r_k1_k)*norm(r_k_1k))+cross(r_k_1k,r_k1_k)*l_norm_r_r_drk1;
d_t_point_t_dr1k=d_dotproduct_dr(:,1)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_dr1k;
d_t_point_t_drk=d_dotproduct_dr(:,2)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_drk;
d_t_point_t_drk1=d_dotproduct_dr(:,3)'/(norm(r_k1_k)*norm(r_k_1k))+r_k_1k'*r_k1_k*l_norm_r_r_drk1;

Mid1_=2*v*(  d_t_cross_t_dr1k  )-2*cross(t_1k,t_k)*v^2*(  d_t_point_t_dr1k  );%3x3%)%/Length0;%
Mid2_=2*v*(  d_t_cross_t_drk  )-2*cross(t_1k,t_k)*v^2*(  d_t_point_t_drk  );%3x3%%/Length0;%
Mid3_=2*v*(  d_t_cross_t_drk1 )-2*cross(t_1k,t_k)*v^2*(  d_t_point_t_drk1  );%3x3%%/Length0;%

Mid1=[Mid1_/Length0 Mid2_/Length0 Mid3_/Length0];

ElasticF=Length0*E*I*Mid1'*Kappa;%(1x3)x(3x9)
ElasticFq1=E*I*(Mid1'*Mid1);%(9x3)x(3x9)

%correct

%%
Kappa_=(2*skewF(T1)*T2)/(1+T1'*T2);

% %----这里计算一个Kappa*Kappa对9个广义坐标的二阶数值导数
% % Kappa=(2*skewF(T1)*T2)/(1+T1'*T2)/Length0;%;%----是逐点的
% ee=e;
% eee=e;
% eps=1e-10;
% Mid_10=zeros(9,9);
% for i=1:9
%     ee(i)=ee(i)+eps;
%     [Mid1_1] = d_kalph_d_r_chafen(ee,Length0,-Kappa_*v,d_t_point_t_dr1k,d_t_point_t_drk,d_t_point_t_drk1);%计算kappa的一阶差分用于生成二阶差分
%     eee(i)=eee(i)-eps;
%     [Mid1_0] = d_kalph_d_r_chafen(eee,Length0,-Kappa_*v,d_t_point_t_dr1k,d_t_point_t_drk,d_t_point_t_drk1);%计算kappa的一阶差分用于生成二阶差分
%     Mid_10(i,:)=Kappa'*(Mid1_1-Mid1_0)/(2*eps);%
%     ee(i)=ee(i)-eps;
%     eee(i)=eee(i)+eps;
% end

%%
% ee=e;%验证kalph_t_cross_t_r
% eps=1e-07;
% Mid_100=zeros(1,9);
% for i=1:9
%     ee(i)=ee(i)+eps;
%     T1_F=(ee(4:6)-ee(1:3))/norm(ee(4:6)-ee(1:3));%
%     T2_F=(ee(7:9)-ee(4:6))/norm(ee(7:9)-ee(4:6));%
%     Kappa_v_F=skewF(T1_F)*T2_F  ;%/Length0 %2*(-v)* /(1+T1_F'*T2_F)
%     Mid100(:,i)=Kappa'*(Kappa_v_F-skewF(T1)*T2)/eps;
%     ee(i)=ee(i)-eps;
% end

% ee=e;%验证kalph_t_cross_t_dr_dr
% eee=e;
% eps=1e-07;
% Mid_101=zeros(9,9);
% for i=1:9
%     ee(i)=ee(i)+1/2*eps;
%     [Mid1_1] = d_t_cross_t_dr_chafen(ee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     eee(i)=eee(i)-1/2*eps;
%     [Mid1_2] = d_t_cross_t_dr_chafen(eee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     Mid_101(i,:)=Kappa'*(Mid1_1-Mid1_2)/eps;
%     ee(i)=ee(i)-1/2*eps;
%     eee(i)=eee(i)+1/2*eps;
% end
%%
% cross_r_r=cross(r_k_1k,r_k1_k)';
% ee=e;%验证1/norm()norm()的二阶导数
% eee=e;
% eps=1e-07;
% Mid_101=zeros(9,9);
% for i=1:9
%     ee(i)=ee(i)+1/2*eps;
%     [Mid1_1] = d_l_norm_r_r_dr_dr_chafen(ee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     eee(i)=eee(i)-1/2*eps;
%     [Mid1_2] = d_l_norm_r_r_dr_dr_chafen(eee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     Mid_101(i,:)=(Mid1_1-Mid1_2)/eps;%Kappa'*
%     ee(i)=ee(i)-1/2*eps;
%     eee(i)=eee(i)+1/2*eps;
% end

[kalph_t_cross_t_1k_1k,kalph_t_cross_t_1k_k,kalph_t_cross_t_1k_k1,kalph_t_cross_t_k_k,kalph_t_cross_t_k_k1,kalph_t_cross_t_k1_k1,...
 kalph_t_cross_t_r1k,kalph_t_cross_t_rk,kalph_t_cross_t_rk1,...
 l_norm_r_r_dr1k_dr1k,l_norm_r_r_drk_drk,l_norm_r_r_drk1_drk1,l_norm_r_r_drk_dr1k,l_norm_r_r_drk1_dr1k,l_norm_r_r_drk1_drk]=DD_t_cross_t_DrDr(d_cross_r_d_r1k,d_cross_r_d_rk,d_cross_r_d_rk1,l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1,r_k_1k,r_k1_k,r_1k_k1,Kappa);
%%
% ee=e;%验证t_1k*t_k的二阶导数
% eee=e;
% eps=1e-06;
% Mid_101=zeros(9,9);
% for i=1:9
%     ee(i)=ee(i)+1/2*eps;
%     [Mid1_1] = d_t_point_t_dr_dr_chafen(ee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     eee(i)=eee(i)-1/2*eps;
%     [Mid1_2] = d_t_point_t_dr_dr_chafen(eee,Length0);%计算t_cross_t的一阶差分用于生成二阶差分
%     Mid_101(i,:)=(Mid1_1-Mid1_2)/eps;%Kappa'*
%     ee(i)=ee(i)-1/2*eps;
%     eee(i)=eee(i)+1/2*eps;
% end
% kalph_t_point_t_1k_1k_=Kappa'*Mid_101(1:3,1:3);
% kalph_t_point_t_k_k_=Kappa'*Mid_101(4:6,4:6);
% kalph_t_point_t_k1_k1_=Kappa'*Mid_101(7:9,7:9);
% kalph_t_point_t_k_1k=Kappa'*Mid_101(4:6,1:3);
% kalph_t_point_t_k1_1k=Kappa'*Mid_101(7:9,1:3);
% kalph_t_point_t_k1_k=Kappa'*Mid_101(7:9,4:6);

[t_point_t_1k_1k,t_point_t_k_k,t_point_t_k1_k1,t_point_t_k_1k,t_point_t_k1_1k,t_point_t_k1_k]=DD_t_point_t_DrDr(Kappa,r_k_1k,r_k1_k,l_norm_r_r_dr1k,l_norm_r_r_drk,l_norm_r_r_drk1,l_norm_r_r_dr1k_dr1k,l_norm_r_r_drk_drk,l_norm_r_r_drk1_drk1,l_norm_r_r_drk_dr1k,l_norm_r_r_drk1_dr1k,l_norm_r_r_drk1_drk);
t_point_t_1k_k=t_point_t_k_1k';
t_point_t_1k_k1=t_point_t_k1_1k';
t_point_t_k_k1=t_point_t_k1_k';
% correct
%%
% ee=e;%验证kappa*（kappa*（-v）的一阶导）
% eps=1e-07;
% Mid_100=zeros(1,9);
% for i=1:9
%     ee(i)=ee(i)+eps;
%     T1_F=(ee(4:6)-ee(1:3))/norm(ee(4:6)-ee(1:3));%
%     T2_F=(ee(7:9)-ee(4:6))/norm(ee(7:9)-ee(4:6));%
%     v_F=1/(1+T1_F'*T2_F);
%     Kappa_v_F=2*(-v_F)*skewF(T1_F)*T2_F/(1+T1_F'*T2_F)  ;%/Length0 
%     Mid100(:,i)=Kappa'*(Kappa_v_F-Kappa_*(-v))/eps;
%     ee(i)=ee(i)-eps;
% end

kalph_d_kappa_point_v_dr1k=( -2*v^2*kalph_t_cross_t_r1k + 2*(Kappa'*Kappa_)*v^2*d_t_point_t_dr1k' );%3x1%( -2*v^2*kalph_t_cross_t_r1k + (Kappa'*Kappa_)*v^2*d_t_point_t_dr1k )
kalph_d_kappa_point_v_drk=( -2*v^2*kalph_t_cross_t_rk + 2*(Kappa'*Kappa_)*v^2*d_t_point_t_drk' );%3x1%( -2*v^2*kalph_t_cross_t_rk + (Kappa'*Kappa_)*v^2*d_t_point_t_drk )
kalph_d_kappa_point_v_drk1=( -2*v^2*kalph_t_cross_t_rk1 + 2*(Kappa'*Kappa_)*v^2*d_t_point_t_drk1' );%3x1%( -2*v^2*kalph_t_cross_t_rk1 + (Kappa'*Kappa_)*v^2*d_t_point_t_drk1 )
%correct

% d_kappa_point_v_dr1k=( -2*v^2*d_t_cross_t_dr1k + (Kappa_)*v^2*d_t_point_t_dr1k );%3x1%
% d_kappa_point_v_drk=( -2*v^2*d_t_cross_t_dr1k + (Kappa_)*v^2*d_t_point_t_drk );%3x1%
% d_kappa_point_v_drk1=( -2*v^2*d_t_cross_t_dr1k + (Kappa_)*v^2*d_t_point_t_drk1 );%3x1%
%%
%
%
%
Mid_01_=(  2*v*kalph_t_cross_t_1k_1k - 2*v^2*kalph_t_cross_t_r1k*d_t_point_t_dr1k  )+(  kalph_d_kappa_point_v_dr1k*d_t_point_t_dr1k + Kappa'*(-Kappa_*v)*t_point_t_1k_1k  );%
Mid_02_=(  2*v*kalph_t_cross_t_k_k - 2*v^2*kalph_t_cross_t_rk*d_t_point_t_drk  )+(  kalph_d_kappa_point_v_drk*d_t_point_t_drk + Kappa'*(-Kappa_*v)*t_point_t_k_k  );%
Mid_03_=(  2*v*kalph_t_cross_t_k1_k1 - 2*v^2*kalph_t_cross_t_rk1*d_t_point_t_drk1 )+(  kalph_d_kappa_point_v_drk1*d_t_point_t_drk1 + Kappa'*(-Kappa_*v)*t_point_t_k1_k1  );%
%
%
%
Mid_1_=(  2*v*kalph_t_cross_t_1k_k - 2*v^2*kalph_t_cross_t_r1k*d_t_point_t_drk  )+(  kalph_d_kappa_point_v_dr1k*d_t_point_t_drk + Kappa'*(-Kappa_*v)*t_point_t_1k_k  );% 
Mid_2_=(  2*v*kalph_t_cross_t_1k_k1 - 2*v^2*kalph_t_cross_t_r1k*d_t_point_t_drk1  )+(  kalph_d_kappa_point_v_dr1k*d_t_point_t_drk1 + Kappa'*(-Kappa_*v)*t_point_t_1k_k1  );% 
Mid_3_=(  2*v*kalph_t_cross_t_k_k1 - 2*v^2*kalph_t_cross_t_rk*d_t_point_t_drk1  )+(  kalph_d_kappa_point_v_drk*d_t_point_t_drk1 + Kappa'*(-Kappa_*v)*t_point_t_k_k1  );% 
%%
% Mid_01_=Mid_01_/Length0;
% Mid_02_=Mid_02_/Length0;
% Mid_03_=Mid_03_/Length0;
% Mid_1_=Mid_1_/Length0;
% Mid_2_=Mid_2_/Length0;
% Mid_3_=Mid_3_/Length0;
Mid_1=[Mid_01_  Mid_1_   Mid_2_;
       Mid_1_'  Mid_02_  Mid_3_;
       Mid_2_'  Mid_3_'  Mid_03_]/Length0;
ElasticFq2=E*I*Mid_1;%
% ElasticFq2=Mid_1;


ElasticFq=Length0*(ElasticFq1+ElasticFq2);%


return


