function [m G]=MeII(e0,L,A1,ro1,BEleInf)
global Guass_Mass
[x,w]=grule(Guass_Mass);

sum=zeros(12,12);
sum1=zeros(12,1);

for r=1:Guass_Mass
    X=(x(r)+1)/2;
    %-----------------------------------
    %------------------------------------- Sx
    Xi=X;
    l_e=L;
    s1x=(-6*Xi+6*Xi^2);
    s2x=(1-4*Xi+3*Xi^2)*l_e;
    s3x=(6*Xi-6*Xi^2);
    s4x=(-2*Xi+3*Xi^2)*l_e;
    Sx=[s1x*eye(3),s2x*eye(3),s3x*eye(3),s4x*eye(3)];
    
    det_J=norm(Sx*e0);
    
    sum=sum+w(r)*(shapeF(X,L)'*shapeF(X,L))*det_J;
    sum1=sum1+w(r)*shapeF(X,L)'*[0;0;-9.81]*det_J;
end
m=ro1*0.5*A1*sum;
G=ro1*0.5*A1*sum1;
return