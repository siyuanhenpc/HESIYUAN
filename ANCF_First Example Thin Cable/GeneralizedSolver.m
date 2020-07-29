tm1=clock;
CPUt=cputime;
global NUMGEN
rou=0.8;
am=(2*rou-1)/(rou+1);
af=rou/(rou+1);
Gam=1/2-am+af;
Beta=(1-am+af)^2/4;

NUMCON=3;

t0=0;
q0=CI;
dq0=CIv;
ddq0=zeros(NUMGEN,1);
an=zeros(NUMGEN,1);

V=[q0',dq0'];
T=[t0];
V_ANCF=[q0',dq0'];

Tfin=1.0;
h=1e-4;
pasos=1;
SimBeta =(1-am)/(h^2*Beta*(1-af));
SimGam=Gam/(h*Beta);
Moment_T=[];
Init_Q=q0;
while t0<=Tfin
    %-------------------------begin integration--------------
    t=t0+h;
    q=q0+h*dq0+h^2*((0.5-Beta)*an);
    dq=dq0+h*(1-Gam)*an;
    Lam=zeros(NUMCON,1);
    aa=(af*ddq0-am*an)/(1-am);
    q=q+h^2*Beta*aa;
    dq=dq+h*Gam*aa;
    ddq=zeros(NUMGEN,1);

    dif=1;
    cont=0;
    while dif>=1e-5
        [Elasticforce Fq]=assembleElaQ(q,Init_Q);
        CQ=Cq(q);
        v1=(h^2*Beta)*(Mass*ddq-Elasticforce)+CQ'*Lam;%-Gravity不加重力 %-----
        v4=fi(t,q);
        v=[v1;v4]; %
        dif=norm(v);
        J=[(h^2*Beta)*(Mass*SimBeta-Fq) CQ'
            CQ zeros(NUMCON,NUMCON)];
        Deta=-J\v;
        q=q+Deta(1:NUMGEN,1);
        dq=dq+SimGam*Deta(1:NUMGEN,1);
        ddq=ddq+SimBeta*Deta(1:NUMGEN,1);
        Lam=Lam+Deta(NUMGEN+1:NUMGEN+NUMCON,1);
        cont=cont+1;
    end
    aa=aa+ddq*(1-af)/(1-am);
    an=aa;
    %------------------ Update the Variable------------------
    ddq0=ddq;
    dq0=dq;
    q0=q;
    Y=[q;dq];
    Y0=Y;
    t0=t;
    if mod(pasos,50)==0
        [cont t]
        V=[V;Y'];
        T=[T;t];
    end
    V_ANCF=[V_ANCF;Y'];%方便以后一起画图
    %----------------------store the simulation results----------
    pasos=pasos+1;
end
ETim=etime(clock,tm1);
tiempoCPUT=cputime-CPUt;
% profile viewer