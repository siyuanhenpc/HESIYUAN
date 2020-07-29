% E=EleInf_B(1,2);
% I=EleInf_B(1,4);
filename='无弯曲刚度绳索抖动ANCF 少单元';

% NUMGEN=960;
% TOT=size(V_IGA,1);
% 
% sgmt = 100;
% Lth = zeros(TOT,1);
% Gp = 100;[Xi,w] = grule(Gp); Xi = (Xi + 1)./2; w = w./2;
% SS = zeros(Gp,TOT);
% weight = crv1.coefs(4,:);
% 
% for i=1:1:TOT
%     cla;
%     q=V_IGA(i,1:NUMGEN);
%     
%     ee = reshape(q,3,[]);
%     
%     lth = 0;
%     for j=1:Gp
%         xi = Xi(j);
%         [N,dN,~] = dbasis(crv1.order,xi,crv1.number,crv1.knots);%crv1.order,crv1.number,crv1.knots
%         sum = weight*N'; dsum = weight*dN';
%         dN = weight.*dN/sum - N.*dsum/(sum^2);
%         dr = ee*dN'; arc_lth = sqrt( dr(1)^2+dr(2)^2+dr(3)^2 );
%         SS(j,i) = arc_lth;
%         tmp = w(j)*arc_lth;
%         lth = lth + tmp;
%     end
%     Lth(i) = lth;
%     
%     
%     ptloc = PtLoc(1, sgmt, NE, BLOC, q, crv1, crv1.order  );
%     figure(1);
%     plot3( ptloc(1,:),ptloc(2,:),ptloc(3,:),'g-','LineWidth',1 ); hold on;
%     
% %     for j=1:sgmt+1
% %         xx = ptloc(1,j,1); yy = ptloc(2,j,1); zz = ptloc(3,j,1);
% %         plot3(xx,yy,zz,'o', 'MarkerSize',5);
% %     end
%     
% %     view(0,0); axis equal; axis([-1.3 1.3 -Inf Inf -1.25 0.1]); 
% %     pause(0.05);
% end

NE_S=319;
NE_ANCF=4;%(NE_S+1)*3/6-1
NE_IGA=319;
NUMGEN=960;
%   画出绳索全部分点形成的图形
%   此处显示详细说明
pic_num=1;
h=1e-4;%注意两个算法步长一致

for num=1:100:size(V_ANCF,1)%计算的时间总长一致
%     cla;
%     q=V_IGA(num,1:NUMGEN);
%     
%     ee = reshape(q,3,[]);
%     
%     lth = 0;
%     for j=1:Gp
%         xi = Xi(j);
%         [N,dN,~] = dbasis(crv1.order,xi,crv1.number,crv1.knots);%crv1.order,crv1.number,crv1.knots
%         sum = weight*N'; dsum = weight*dN';
%         dN = weight.*dN/sum - N.*dsum/(sum^2);
%         dr = ee*dN'; arc_lth = sqrt( dr(1)^2+dr(2)^2+dr(3)^2 );
%         SS(j,i) = arc_lth;
%         tmp = w(j)*arc_lth;
%         lth = lth + tmp;
%     end
%     Lth(i) = lth;
%     ptloc = PtLoc(1, sgmt, NE, BLOC, q, crv1, crv1.order  );
%     
%     q_DER=V_DER(num,:)';
    q_ANCF=V_ANCF(num,:)';
%     q_IGA=V_IGA(num,:)';
    figure(1);
%     plot3(q_DER(end-2),q_DER(end-1),q_DER(end),'r*','MarkerFaceColor','r'); hold on
    plot3(q_ANCF(LM_ANCF(NE_ANCF,7)),q_ANCF(LM_ANCF(NE_ANCF,8)),q_ANCF(LM_ANCF(NE_ANCF,9)),'b*','MarkerFaceColor','b'); hold on
%     plot3(q_IGA(LM_IGA(NE_IGA,4)),q_IGA(LM_IGA(NE_IGA,5)),q_IGA(LM_IGA(NE_IGA,6)),'g*','MarkerFaceColor','g'); hold on
%     legend('DER','ANCF');%,'IGA'
%     for i=1:NE_S
%         plot3( q_DER(LM_S_DER(i,[1 4])),q_DER(LM_S_DER(i,[2 5])),q_DER(LM_S_DER(i,[3 6])),'r-','LineWidth',1.0 ) ; hold on
%     end
    for i=1:NE_ANCF
        plot3( q_ANCF(LM_ANCF(i,[1 7])),q_ANCF(LM_ANCF(i,[2 8])),q_ANCF(LM_ANCF(i,[3 9])),'b-','LineWidth',1.0 ) ; hold on
    end
%     for i=1:NE_IGA
%         plot3( q_IGA(LM_IGA(i,[1 4])),q_IGA(LM_IGA(i,[2 5])),q_IGA(LM_IGA(i,[3 6])),'g-','LineWidth',1.0 ) ; hold on
%     end
    hold off;
    view([0,-1,0]);
%     axis equal;
    axis([0 30 0 2 -1 1]);
    legend(['t = ',num2str(num*h,3),'s '],'location','southoutside');
    title(filename);%,num2str(2*pi*E*I)
%     view(0,90);
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    
    if pic_num == 1
        imwrite(I,map,[filename,'.gif'],'gif','Loopcount',inf,'DelayTime',h);
    else
        imwrite(I,map,[filename,'.gif'],'gif','WriteMode','append','DelayTime',h);
    end
    pic_num = pic_num + 1;
    
    pause(0.0001)
    %     ylabel('挠度/m');
    % legend('加载后');%'加载前'
%     title(['力矩M= 2*pi*EI/L ','N*m 时挠曲线']);%,num2str(2*pi*E*I)
%     hold off;
end