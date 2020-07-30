% function [] = Animation(q,LM_S,EleInf_B,F,NE_S)
% E=EleInf_B(1,2);
% I=EleInf_B(1,4);
filename='绳索抖动';
%   画出绳索全部分点形成的图形
%   此处显示详细说明
pic_num=1;
L_rod=0;
for num=1:(0.01/h):size(V,1)
    q=V(floor(num),:)';
    for i=1:NE_S
        
        plot3( q(LM_S(i,[1 4])),q(LM_S(i,[2 5])),q(LM_S(i,[3 6])),'r-','LineWidth',1.0 ) ; hold on
    end
    plot3(q(1),q(2),q(3),'y*','MarkerFaceColor','y');
    plot3(q(end-2),q(end-1),q(end),'y*','MarkerFaceColor','y');
    hold off;

%     axis equal;

    view([0,-1,0]);
    axis([0 30 -0.2 0.2 -1 1]);
    
%     %%XZ平面发射_观测窗
%     view([0,1,0]);
%     q_0=reshape(q,3,NE_S+1)';
%     xlim([min(q_0(:,1))-2 max(q_0(:,1))+2]);
%     zlim([min(q_0(:,3))-2 max(q_0(:,3))+2]);
%     %%YZ平面发射_观测窗
%     view([1,0,0]);
%     q_0=reshape(q,3,NE_S+1)';
%     ylim([min(q_0(:,2))-2 max(q_0(:,2))+2]);
%     zlim([min(q_0(:,3))-2 max(q_0(:,3))+2]);
    
    legend(['t = ',num2str(num*h,3),'s '],'location','southoutside');
    title(filename);%,num2str(2*pi*E*I)
%     view(0,90);
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    
    if pic_num == 1
        imwrite(I,map,[filename,'.gif'],'gif','Loopcount',inf,'DelayTime',1*h);
    else
        imwrite(I,map,[filename,'.gif'],'gif','WriteMode','append','DelayTime',1*h);
    end
    pic_num = pic_num + 1;
    L_rod=[L_rod;abs(q(end-1)-q(2))];
    pause(0.00001)
    %     ylabel('挠度/m');
    % legend('加载后');%'加载前'
%     title(['力矩M= 2*pi*EI/L ','N*m 时挠曲线']);%,num2str(2*pi*E*I)
%     hold off;
end
% % Node_num=size(Nodelink,1);
% %
% % r_old=r(1:3*Node_num_old,1);
% % xpt1=r_old(1:3:3*Node_num_old-2,1);
% % ypt1=r_old(2:3:3*Node_num_old-1,1);
% % zpt1=r_old(3:3:3*Node_num_old,1);
% %
% % s=1;%辅助
% % for i=1:Node_num
% %     [~,a1,~]=find(Nodelink(s,:));
% %     if i==1
% %         nn=[1 a1];
% %         s=a1;
% %     else
% %         a2=setdiff(a1,nn) ;
% %         s=a2;
% %         nn=[nn a2];
% %     end
% % end
% %
% % r_fuzhu=reshape(r',3,Node_num)';
% % xpt=r_fuzhu(nn,1);
% % ypt=r_fuzhu(nn,2);
% % zpt=r_fuzhu(nn,3);
% %
% % figure(1);
% % %     hf1=figure(1);
% % %     set(hf1,'visible','off');
% % plot3(xpt1,ypt1,zpt1,'yo','MarkerFaceColor','y');
% % axis(display_region);
% % hold on;
% % plot3(xpt,ypt,zpt,'b-','LineWidth',1.5);
% % %     legend(['t = ',num2str(t,3),'s '],'location','north');
% view([0 -1 0]);
% xpt0=0.0:0.1:1.0;
% xpt0_=0.0:0.1:1.0;
% ypt0=F(end)/E/I*(1.0*xpt0_.^2/2-xpt0_.^3/6);
% zpt0=zeros(1,size(xpt0,2));
% plot3(xpt0,zpt0,ypt0,'r-','LineWidth',1.5);
% hold off;
%
% zlabel(['挠度/m']);
% legend('数值解','解析解');
% title(['集中力F= ',num2str(F(end)),'N 时挠曲线']);
% %     fmat(:,j)=getframe;
% %     F=getframe(gcf);
% %     I=frame2im(F);
% %     [I,map]=rgb2ind(I,256);
% %
% %     if pic_num == 1
% %     imwrite(I,map,[filename,'.gif'],'gif','Loopcount',inf,'DelayTime',h*1000);
% %     else
% %     imwrite(I,map,[filename,'.gif'],'gif','WriteMode','append','DelayTime',h*1000);
% %     end
% %     pic_num = pic_num + 1;
% end

