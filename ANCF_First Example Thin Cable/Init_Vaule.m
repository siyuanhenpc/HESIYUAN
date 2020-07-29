function [Init_curvature Init_J0 Init_Green]=Init_Vaule(q0) 
global NE LM BEleInf GAUSS


[x,w]=grule(GAUSS);
Init_curvature=zeros(GAUSS,NE);
Init_J0=zeros(GAUSS,NE);
for num=1:NE
    e0=q0(LM(num,:));
    l_e=BEleInf(num,1);
    for k=1:GAUSS
        Xi=(x(k)+1)/2;
        %------------------------------------- Sx
        s1x=(-6*Xi+6*Xi^2);
        s2x=(1-4*Xi+3*Xi^2)*l_e;
        s3x=(6*Xi-6*Xi^2);
        s4x=(-2*Xi+3*Xi^2)*l_e;
        Sx=[s1x*eye(3),s2x*eye(3),s3x*eye(3),s4x*eye(3)];
        
        det_J=norm(Sx*e0);
        Init_J0(k,num)=det_J;
        rx=Sx*e0;
        
        %------------------------------------ Sxx
        s1xx=(-6+12*Xi);
        s2xx=(-4+6*Xi)*l_e;
        s3xx=(6-12*Xi);
        s4xx=(-2+6*Xi)*l_e;
        Sxx=[s1xx*eye(3),s2xx*eye(3),s3xx*eye(3),s4xx*eye(3)];
        rxx=Sxx*e0;
        
        Init_curvature(k,num)=norm(cross(rx,rxx))/norm(rx);
        
        Init_Green(k,num)=rx'*rx;
    end
end
end