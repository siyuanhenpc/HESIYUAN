clear;
clc;
format long;

CFL=0.1;
M=200;
L=1.0;
density_L=1.0;
pressure_L=1.0;
velocity_L=0.0;
density_R=0.1;
pressure_R=0.125;
velocity_R=0.0;

gamma=1.4;%绝热指数
u_start=zeros(3,M+4);
u_end=zeros(3,M+4);
mid=(M+4)/2;
for i=1:M+4
    if i<=mid
        u_start(:,i)=[density_L;density_L*velocity_L;1/2*density_L*velocity_L^2+1/(gamma-1)*pressure_L];
    else
        u_start(:,i)=[density_R;density_R*velocity_R;1/2*density_R*velocity_R^2+1/(gamma-1)*pressure_R];
    end
end
%------------方波传播测试代码------------
% u_start(2,mid-4:mid+5)=density_L*1.0;
% u_start(3,mid-4:mid+5)=1/2*density_L+1/(gamma-1)*pressure_L;
%----------------------------------------

u_end(:,3:M+2)=u_start(:,3:M+2)+ones(3,M);%人为设置u_end与u_start的差值进入迭代
u_end(:,1:2)=u_start(:,1:2);
u_end(:,M+3:M+4)=u_start(:,M+3:M+4);
time = 0;%记录达到平衡态所需物理时间
flag = 0;%记录迭代步数
pic_num = 1;
% while  any(any(abs(u_end(:,3:M+2)-u_start(:,3:M+2))>=1e-4))
while time<=2.0
    [ u,P,Den,time,u_end,u_start,flag,mass ] = main( CFL,M,L,gamma,u_end,u_start,time,flag,density_L,density_R,pressure_L,pressure_R );
    mass
    time
    %------------------------------绘图--------------------------------
    x=-L/2:L/(M-1):L/2;
    axis([-L/2 L/2 0 1]);

    figure(1);
    plot(x,Den,'b-','LineWidth',1.5);
    legend(['t = ',num2str(time,3),'s 密度分布']);
    
    fmat(:,flag)=getframe;
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);

    if pic_num == 1
    imwrite(I,map,'test3.gif','gif','Loopcount',inf,'DelayTime',0.2);
    else
    imwrite(I,map,'test3.gif','gif','WriteMode','append','DelayTime',0.2);
    end
    pic_num = pic_num + 1;

    % figure(2);
    % plot(x,u,'b--','LineWidth',1.5);hold on;
    % plot(x,P,'g-.','LineWidth',1.5);hold on;
    % plot(x,Den,'r-','LineWidth',1.5);hold off
    % legend(['t = ',num2str(time,3),'s 速度分布'],['t = ',num2str(time,3),'s 压力分布'],['t = ',num2str(time,3),'s 密度分布']);
    
    %------------------------------------------------------------------
end




