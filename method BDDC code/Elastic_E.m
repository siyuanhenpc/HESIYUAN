function [Fk,Fqq]=Elastic_E(e0,EleInf)
% global q0 LM NUMGEN NE EleInf F Fq e0
Esize=EleInf(1:2);
th=EleInf(3);
PCoeff=EleInf(4);
E=EleInf(5);
Mu=EleInf(6);
D1=E/(1-Mu^2);
D_MATRIX=E/(1-Mu^2)*[1 Mu 0;Mu 1 0;0 0 (1-Mu)/2];    %----D矩阵
GaussN=5;

if GaussN==5                                         %----高斯点的数目
    x(1)=-0.906179845938664;
    x(2)=-0.538469310105683;
    x(3)=0.000000000000000;
    x(4)=0.538469310105683;
    x(5)=0.906179845938664;
    y(1)=-0.906179845938664;
    y(2)=-0.538469310105683; 
    y(3)=0.000000000000000;
    y(4)=0.538469310105683;
    y(5)=0.906179845938664;
elseif GaussN==3
    x(1)=-0.774596669241483;
    x(2)=0.000000000000000;
    x(3)=0.774596669241483;
    y(1)=-0.774596669241483;
    y(2)=0.000000000000000;
    y(3)=0.774596669241483;
end
w(1)=0.236926885056189;
w(2)=0.478628670499366;
w(3)=0.568888888888889;
w(4)=0.478628670499366;
w(5)=0.236926885056189;
%   以下是积分点上的计算-------
Fqq=zeros(8,8);            %%%%每个单元刚度阵
Fk=zeros(8,1);             %%%%每个单元上广义力
for r=1:GaussN
    for s=1:GaussN
        Xi=(x(r)+1)/2;   %%%%
        Yi=(y(s)+1)/2;   %%%%
     
        S=shapeF(Xi,Yi);                            %%调用shapeF
        [Sx Sy]=DshapeF(Xi,Yi,Esize);               %%调用DshapeF
        %----直接计算刚度矩阵
        Real_P=S*e0;
        xx=Real_P(1);
        yy=Real_P(2);
        %             Ana_Sxx=(-2)*yy*(1-yy);
        %             Ana_Syy=(-2)*xx*(1-xx);
        %             Ana_Sxy=(1-2*yy)*(1-2*xx);
        Ana_Sxx=yy*sin(yy)*(yy - 1)*(2*sin(xx) - 2*cos(xx) - xx^2*sin(xx) + 4*xx*cos(xx) + xx*sin(xx));
        Ana_Syy=xx*sin(xx)*(xx - 1)*(2*sin(yy) - 2*cos(yy) - yy^2*sin(yy) + 4*yy*cos(yy) + yy*sin(yy));
        Ana_Sxy=(sin(xx) - xx^2*cos(xx) + xx*cos(xx) - 2*xx*sin(xx))*(sin(yy) - yy^2*cos(yy) + yy*cos(yy) - 2*yy*sin(yy));
        Sigma_x_x=D1*(Ana_Sxx+Mu*Ana_Sxy);
        Sigma_y_y=D1*(Mu*Ana_Sxy+Ana_Syy);
        Tau_yx_y=D1*(1-Mu)/2*(Ana_Syy+Ana_Sxy);
        Tau_xy_x=D1*(1-Mu)/2*(Ana_Sxy+Ana_Sxx);
        
        f_x=+Sigma_x_x+Tau_yx_y;
        f_y=+Sigma_y_y+Tau_xy_x;
        
        %             f_x=100000;
        %             f_y=200000;    ？
        Fk=Fk+th*w(r)*w(s)*S'*[f_x;f_y];
        
        B_MATRIX=zeros(3,8);
        B_MATRIX(1,:)=Sx(1,:);
        B_MATRIX(2,:)=Sy(2,:);
        B_MATRIX(3,:)=Sx(2,:)+Sy(1,:);
        
        
        Fqq=Fqq+th*w(r)*w(s)*(B_MATRIX'*D_MATRIX*B_MATRIX);
    end
end
Fqq=Fqq*PCoeff;
Fk=Fk*PCoeff;
%-----
end