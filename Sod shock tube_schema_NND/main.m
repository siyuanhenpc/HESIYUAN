function [ u,P,Den,time,u_end,u_start,flag,mass ] = main( CFL,M,L,gamma,u_end,u_start,time,flag, density_L,density_R,pressure_L,pressure_R )
%   求解一维sod_shock_tube问题，单原子理想气体，在中心处等分，error小于等于10-4时得到流动定常解
%   CFL 克朗数 M 节点数（不包括边界处的二层虚拟网格） L管道长度
%   density_L,pressure_L,velocity_L为左半部分气体初态  density_R,pressure_R,velocity_R为右半部分气体初态



 if time ~= 0
    u_start = u_end;
%        %-----------------cycle B.C.-------------------
%        u_start(:,1:2)=u_start(:,M-1:M);
%        u_start(:,M+1:M+2)=u_start(:,3:4);
%        %----------------------------------------------
%        %---------blocked in both ends & Inelastic collision on wall-B.C.----------
%        for i=1:2
%            u_start(:,i)=[u_start(1,3);0;u_start(3,3)];%left wall的虚拟网格同密度无速度但提供压强
%            u_start(:,M+5-i)=[u_start(1,M+2);0;u_start(3,M+2)];%right wall的B.C.同上
%        end
%        u_start(3,3)=u_start(3,3)-1/2*u_start(2,3)^2/u_start(1,3);%左壁面节点总能量扣除动压，视为非弹性碰撞吸收动能
%        u_start(2,3)=0;%左壁面节点无速度
%        u_start(3,M+2)=u_start(3,M+2)-1/2*u_start(2,M+2)^2/u_start(1,M+2);%右壁面同上
%        u_start(2,M+2)=0;%右壁面同上
%        %--------------------------------------------------------------------------
       %---------blocked in both ends & elastic collision on wall B.C----------
       for i=1:2
%            u_start(:,i)=[u_start(1,3);0;u_start(3,3)];%left wall的虚拟网格同密度无速度但提供压强
%            u_start(:,M+5-i)=[u_start(1,M+2);0;u_start(3,M+2)];%right wall的B.C.同上
           u_start(:,i)=[density_L;0;1/(gamma-1)*pressure_L];%left wall的虚拟网格密度恒定有内外差无速度但压强有内外差
           u_start(:,M+5-i)=[density_R;0;1/(gamma-1)*pressure_R];%right wall的B.C.同上
       end
       u_start(2,3)=-u_start(2,3);%左壁面节点速度反向，发生弹性碰撞
       u_start(2,M+2)=-u_start(2,3);%右壁面同上
       %--------------------------------------------------------------------------
end
    [ f_plus,f_minus,lamda_plus,lamda_minus,a,lamda1 ] = f_cal( u_start,gamma,M );%输出四个3×M+1的矩阵,最后是一个1×M+4的向量
    [ delta_f_plus,delta_f_minus ] = delta_f_cal( u_start,gamma,M,lamda1 );%输出二个3×M+1的矩阵
%     a_max=max(abs(a));%a是管中各点声速，用于代入CFL数调整步长
    lamda_max = max(max([lamda_plus,-lamda_minus]));%各点处速度场，用于代入CFL数调整补偿
    for j=1:M
        ff_up = f_plus(:,1+j)+1/2*minmod( delta_f_plus(:,1+j),delta_f_plus(:,2+j) )+f_minus(:,1+j)-1/2*minmod( delta_f_minus(:,1+j),delta_f_minus(:,2+j) );
        ff_down = f_plus(:,j)+1/2*minmod( delta_f_plus(:,j),delta_f_plus(:,1+j) )+f_minus(:,j)-1/2*minmod( delta_f_minus(:,j),delta_f_minus(:,1+j) );
        u_end(:,2+j) = u_start(:,2+j)-CFL/lamda_max*( ff_up-ff_down );
%------------方波传播测试代码-----------       
%         u_end(:,1) = u_start(:,3);
%         u_end(:,2) = u_start(:,3);
%         u_end(:,M+3) = u_start(:,M+2);
%         u_end(:,M+4) = u_start(:,M+2);
%---------------------------------------
    end
%     plot(lamda1(1,:))%输出当前时间步的速度场，测试用
%     plot(u_end(1,500:1500))%输出当前时间步的密度场，测试用
%--------test for B.C. based on conservation of mass---------
    mass = 0;
    for j=1:M
        mass=mass+u_end(1,2+j);
    end
    mass = mass+u_end(2,3)-u_end(2,M+2);
%------------------------------------------------------------
    dx = L/(M-1);
%     dt = CFL/a_max*dx;%a是管中各点声速，用于代入CFL数调整步长
    dt = CFL/lamda_max*dx;
    time = time + dt;
    flag=flag+1;


%------------------------速度压强密度计算，绘图准备-----------------------
u=u_end(2,3:M+2)./u_end(1,3:M+2);
P=(gamma-1)*(u_end(3,3:M+2)-1/2*u_end(1,3:M+2).*u.^2);
Den=u_end(1,3:M+2);

end

