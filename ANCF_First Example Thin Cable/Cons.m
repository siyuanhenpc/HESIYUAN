function Cons
global BEleInf Init_J0 NE VE1 VE2 VA VC VO VSx VSxx GAUSS
VE1=cell(NE,1);
VE2=cell(NE,1);
VE3=cell(NE,1);

VA=cell(NE,GAUSS);
VC=cell(NE,GAUSS);
VO=cell(NE,GAUSS);
VX=cell(NE,GAUSS);

[x,w]=grule(GAUSS);

for num=1:NE
    l_e=BEleInf(num,1);
    K1=zeros(144,144);
    K2=zeros(144,144);
    K3=zeros(12,12);
    KKK=cell(12,12,12,12);
    for a=1:12
        for b=1:12 
            for c=1:12 
                for d=1:12
                    KKK{a,b,c,d}=0;
                end
            end
        end
    end
    for k=1:GAUSS
        Xi=(x(k)+1)/2;
        %------------------------------------- Sx
        s1x=(-6*Xi+6*Xi^2);
        s2x=(1-4*Xi+3*Xi^2)*l_e;
        s3x=(6*Xi-6*Xi^2);
        s4x=(-2*Xi+3*Xi^2)*l_e;
        Sx=[s1x*eye(3),s2x*eye(3),s3x*eye(3),s4x*eye(3)];
        
        det_J0=Init_J0(k,num);
        H=Sx/det_J0;
        
        Hbar=H'*H;
        %-----------------Hbar(r,s) Hbar(t,w)
        for r=1:12
            for s=1:12
                for t=1:12
                    for v=1:12
                        mid=w(k)*Hbar(r,s)*Hbar(t,v);
                        K1(12*(r-1)+t,12*(s-1)+v)=K1(12*(r-1)+t,12*(s-1)+v)+mid;
                        K2(12*(r-1)+s,12*(t-1)+v)=K2(12*(r-1)+s,12*(t-1)+v)+mid;
                    end
                end
            end
        end
        %------------------------------------ Sxx

        s1xx=(-6+12*Xi);
        s2xx=(-4+6*Xi)*l_e;
        s3xx=(6-12*Xi);
        s4xx=(-2+6*Xi)*l_e;
        Sxx=[s1xx*eye(3),s2xx*eye(3),s3xx*eye(3),s4xx*eye(3)];
        %--------------------Y T
        T=[s1x s2x s3x s4x];
        Y=[s1xx,s2xx,s3xx,s4xx];
%         T=Sx;
%         Y=Sxx;
        VSx{num,k}=T';
        VSxx{num,k}=Y';
        VA{num,k}=T'*T;
        VC{num,k}=Y'*Y;
        VO{num,k}=T'*Y+(T'*Y)';
    end
    VE1{num}=0.5*BEleInf(num,1)*BEleInf(num,4)*BEleInf(num,2)/2*K1;
    VE2{num}=0.5*BEleInf(num,1)*BEleInf(num,4)*BEleInf(num,2)/2*K2;
end

end