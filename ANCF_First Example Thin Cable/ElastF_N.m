function [ElasticF ElasticFq]=ElastF_N(q,q0,num,Coeff,Coeff1)
global VE1 VE2 VA VC VO VSx VSxx Init_curvature Init_J0 Init_Green GAUSS
K11=VE1{num};
K22=VE2{num};

% %-----------------------------------------------E*A 重新计算这一项
% for d=1:3
%     for m=1:3
%         EE1(3*(d-1)+m,:)=reshape(e(:,m)*e(:,d)',1,[ ]);
%     end
% end
% EE2=reshape(e*e',1,[ ]);
% 
% F1=-EE1*K11/2;
% F2=-EE2*K22/2;
% 
% FF1=reshape(F1,3,[ ]);
% FQ1=zeros(24,24);
% for n=1:8
%     FQ1((n-1)*3+1:3*n,:)=FF1(:,24*(n-1)+1:24*n);
% end
% 
% F3=zeros(9,16);
% F3([1 5 9],:)=[F2;F2;F2];
% FF2=reshape(F3,3,[ ]);
% FQ2=zeros(12,12);
% for n=1:4
%     FQ2((n-1)*3+1:3*n,:)=FF2(:,24*(n-1)+1:24*n);
% end
% 
% FQ=FQ1+FQ2+K2;
% 
% %-----------------------------Elastic Force
% ElasticForce=(FQ1/2+K2)*q;




qq=q*q';
qq0=q0*q0';

ee=reshape(qq,[],1);
ee0=reshape(qq0,[],1);

step1=-2*ee'*K11;
step2=-(ee'-ee0')*K22;
%-----------------------------------------------
ElasticFq1=reshape(step2,12,12);
ElasticF1=ElasticFq1*q;
ElasticFq1=ElasticFq1+reshape(step1,12,12);


%-------------------------------------------------E*I

[~,w]=grule(GAUSS);

ElasticF2=zeros(12,1);
ElasticFq2=zeros(12,12);

ElasticF4=zeros(12,1);
ElasticFq4=zeros(12,12);

qq=reshape(q,3,4);
midd4=zeros(12,12);
for k=1:GAUSS
    A=VA{num,k};
    C=VC{num,k};
    O=VO{num,k};

    k0=Init_curvature(k,num);
    det_J0=Init_J0(k,num);
    M0=Init_Green(k,num);
    
    R=qq*A;
    T=qq*C;
    UV=qq*O;

    M=sum( diag((R*qq')) );
    B=sum( diag((T*qq')) );
    N=sum( diag((UV*qq')) )/2;
    NM=N/M;

    mid=2*C -2*NM*O   +2*NM*NM*A;
    midd1=reshape(mid,1,16);
    midd2([1,5,9],:)=[midd1;midd1;midd1];
    midd3=reshape(midd2,3,[]);
    for n=1:4
        midd4((n-1)*3+1:3*n,:)=midd3(:,12*(n-1)+1:12*n);
    end
    
    mid1=reshape(qq*mid,12,1);
    
    mid2=M*O-2*N*A;
    mid3=reshape(qq*mid2,12,1);
    mid4=2/M^3*mid3*mid3';
    
    if k0==0
        %--初始曲率为零
        ElasticF2=ElasticF2-w(k)*det_J0^(-3)*mid1;
        ElasticFq2=ElasticFq2-w(k)*det_J0^(-3)*(midd4-mid4);
    else
        %--初始曲率不为零
        Sx=VSx{num,k};
        Sxx=VSxx{num,k};
        rx=qq*Sx;
        rxx=qq*Sxx;
        k_k=norm(cross(rx,rxx))/norm(rx);
        ElasticF2=ElasticF2-w(k)*(k_k-k0)/k_k*det_J0^(-3)*mid1;
        
        ElasticFq2=ElasticFq2-w(k)*det_J0^(-3)*( (k_k-k0)/k_k*(midd4-mid4) +k0/2/k_k^3*mid1*mid1'  );
    end

    %----------------------------------------------------------EA
    RR=reshape(R,12,1);

    midd1=reshape(A,1,16);
    midd2=zeros(9,16);
    midd2([1,5,9],:)=[midd1;midd1;midd1];
    midd3=reshape(midd2,3,[]);
    for n=1:4
        midd4((n-1)*3+1:3*n,:)=midd3(:,12*(n-1)+1:12*n);
    end
    
    ElasticF4=ElasticF4+w(k)*(M-M0)*(RR)/det_J0^3;
    ElasticFq4=ElasticFq4+w(k)*( (M-M0)*midd4+2*RR*RR' )/det_J0^3;
    
end
ElasticF4=-ElasticF4*Coeff1;
ElasticFq4=-ElasticFq4*Coeff1;


ElasticF= ElasticF1;%+ Coeff*ElasticF2
ElasticFq=ElasticFq1;%+Coeff*ElasticFq2
end