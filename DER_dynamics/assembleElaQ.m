function [F, Fq]=assembleElaQ(Kappa_0,q,NUMGEN,NE_S,LM_S,EleInf_S,NE_B,LM_B,EleInf_B)

Fq=zeros(NUMGEN,NUMGEN);
F=zeros(NUMGEN,1);

for k=1:NE_S
    lm=LM_S(k,:);
    e=q(lm);
    [Fk_S, Fqq_S]=ElastFQ_S(e,EleInf_S(k,:));    
    
%     eps=1e-06;
%     ee=[1 2 3 4 5 6]';
%     [Fk_S, Fqq_S]=ElastFQ_S(ee,EleInf_S(k,:));
%     Fqq_S_NUM=zeros(6);
%     for ii=1:6
%         ee(ii)=ee(ii)+eps;
%         [Fk_S_False, Fqq_S]=ElastFQ_S(ee,EleInf_S(k,:));
%         Fqq_S_NUM(:,ii)=(Fk_S_False-Fk_S)/eps;
%         ee(ii)=ee(ii)-eps;
%     end
    
    Fq(lm,lm)=Fq(lm,lm)+Fqq_S;
    F(lm)=F(lm)+Fk_S;
end

for k=1:NE_B
    lm=LM_B(k,:);
    e=q(lm);
    [Fk_B, Fqq_B]=ElastFQ_B(Kappa_0(3*k-2:3*k,1),e,EleInf_B(k,:));
    Fq(lm,lm)=Fq(lm,lm)+Fqq_B;
    F(lm)=F(lm)+Fk_B;
    
%     eps=1e-06;
%     ee=[1 2 3 0.4 0.5 0.6 7 8 9]';
%     [Fk_B, Fqq_B]=ElastFQ_B(ee,EleInf_B(k,:));
%     Fqq_B_NUM=zeros(9);
%     for ii=1:9
%         ee(ii)=ee(ii)+eps;
%         [Fk_B_False, Fqq_B]=ElastFQ_B(ee,EleInf_B(k,:));
%         Fqq_B_NUM(:,ii)=(Fk_B_False-Fk_B)/eps;
%         ee(ii)=ee(ii)-eps;
%     end
    
end


end