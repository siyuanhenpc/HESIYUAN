function [v vv]=CI()

global EleInf NE_X NE_Y NN

v=zeros(NN,1);
vv=zeros(NN,1);

num=0;
mid=0;
EPLx=EleInf(1,1);
EPLy=EleInf(1,2);
% for i=1:NE_X+1
%     for j=1:NE_Y+1
%         num=num+1;
%         v(2*num-1:2*num,1)=[mid 1-(j-1)*EPLy ]';
%         xx=mid;
%         yy=1-(j-1)*EPLy;
%         vv(2*num-1:2*num,1)=[xx*(1-xx)*yy*(1-yy)*sin(xx)*sin(yy)  xx*(1-xx)*yy*(1-yy)*sin(xx)*sin(yy)]';
%     end
%     mid=mid+EPLx;
% end
for i=1:NE_X+1
    for j=1:NE_Y+1
        num=num+1;
        v(num,1:2)=[mid 1-(j-1)*EPLy ];
        xx=mid;
        yy=1-(j-1)*EPLy;
        vv(2*num-1:2*num,1)=[xx*(1-xx)*yy*(1-yy)*sin(xx)*sin(yy)  xx*(1-xx)*yy*(1-yy)*sin(xx)*sin(yy)]';
    end
    mid=mid+EPLx;
end

% numInsertLine=[9,17,18,22];%插入点的新号，旧号见下
% v=[v(1:8,:);v(8,:);v(9:15,:);v(12,:);v(14,:);v(16:18,:);v(18,:);v(19:end,:)];

return