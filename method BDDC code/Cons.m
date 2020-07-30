function [F,Fq]=Cons(LM,LM_L,NUMGEN,MNE)

Fq=zeros(NUMGEN,NUMGEN);
F=zeros(NUMGEN,1);

w(1)=0.236926885056189;
w(2)=0.478628670499366;
w(3)=0.568888888888889;
w(4)=0.478628670499366;
w(5)=0.236926885056189;

global EleInf q0
for num=1:MNE
    Esize=EleInf(num,1:2);
    th=EleInf(num,3);
    PCoeff=EleInf(num,4);
    E=EleInf(num,5);
    Mu=EleInf(num,6);
    D1=E/(1-Mu^2);
    D_MATRIX=E/(1-Mu^2)*[1 Mu 0;Mu,1 0;0 0 (1-Mu)/2];%D矩阵
    GaussN=5;

    e0=q0( LM(num,:) );
    lm1=LM_L(num,:);
    
    if GaussN==5
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
    %   以下是积分点上的计算-------
    Fqq=zeros(8,8);
    Fk=zeros(8,1);
    for r=1:GaussN
        for s=1:GaussN
            Xi=(x(r)+1)/2;
            Yi=(y(s)+1)/2;
            
            S=shapeF(Xi,Yi);
            [Sx Sy]=DshapeF(Xi,Yi,Esize);
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
            %             f_y=200000;
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
    %-----从单元组装该区域的刚度矩阵，lml是各单元自由度的各区域内局部位置
    Fq(lm1,lm1)=Fq(lm1,lm1)+Fqq;    %---K
    F(lm1)=F(lm1)+Fk;             %---F
end


%-------------------集中力的收敛性很是怪异 只有一阶 应该是应力集中导致的
% F=zeros(NUMGEN,1);
% NUM=NE-NE_Y+1;
% lm=LM(NUM,5:6);
% % q0(lm)
% F(lm)=[5000 10000];
%
% NUM=NE;
% lm=LM(NUM,3:4);
% % q0(lm)
% F(lm)=-[5000 10000];


%-------------------施加分布力 收敛性具有二阶
% F=zeros(NUMGEN,1);
% for num=NE-NE_Y+1:NE
%     Fk=zeros(8,1);
%     Esize=EleInf(num,1:2);
%     lm=LM(num,:);
%     for s=1:GaussN
%         Xi=1.0e0;
%         Yi=(y(s)+1)/2;
%         S=shapeF(Xi,Yi);
%         Fk=Fk+th*w(s)*S'*[10000;20000];
%     end
%     Fk=Fk*Esize(2)/2;
%     F(lm)=F(lm)+Fk;
% end


return

