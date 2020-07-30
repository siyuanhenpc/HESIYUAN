function [ElasticF, ElasticFq]=ElastFQ_S(e,EleInf_1)

% e=[0.02;0.00;0.00;0.04;0.01;0.00;0.06;0.04;0.00];
% e=[0.01;0.00;0.00;0.02;0.01;0.00;0.03;0.00;0.00];

Length0=EleInf_1(1);
E=EleInf_1(2);
A=EleInf_1(3);

Length=norm(e(4:6)-e(1:3));
   
eplision=(Length-Length0)/Length0;%应变_对于弹簧问题只有大小无方向
Mid=[-(Length^-1*(e(4:6)-e(1:3)))/Length0 ;
      (Length^-1*(e(4:6)-e(1:3)))/Length0];%


ElasticFq1=Mid*E*A*Mid';
ElasticFq2=eplision*E*A*Length0^-1*Length^-1*[ eye(3)  -eye(3) ;-eye(3)   eye(3)] + ...
           eplision*E*A*Length0^-1*(-1)*Length^-2*Length^-1*[-e(4:6)+e(1:3) ;e(4:6)-e(1:3)]*[-e(4:6)+e(1:3) ;e(4:6)-e(1:3)]';

ElasticFq=Length0*(ElasticFq1+ElasticFq2);

ElasticF=Length0*eplision*E*A*Mid;

%%无压缩
% if Length<Length0
%     ElasticF=zeros(6,1);
%     ElasticFq=zeros(6,6);
% else 
%     ElasticF=Length0*eplision*E*A*Mid;
% end

return


