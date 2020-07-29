function [ u,P,Den,time,u_end,u_start,flag,mass ] = main( CFL,M,L,gamma,u_end,u_start,time,flag, density_L,density_R,pressure_L,pressure_R )
%   ���һάsod_shock_tube���⣬��ԭ���������壬�����Ĵ��ȷ֣�errorС�ڵ���10-4ʱ�õ�����������
%   CFL ������ M �ڵ������������߽紦�Ķ����������� L�ܵ�����
%   density_L,pressure_L,velocity_LΪ��벿�������̬  density_R,pressure_R,velocity_RΪ�Ұ벿�������̬



 if time ~= 0
    u_start = u_end;
%        %-----------------cycle B.C.-------------------
%        u_start(:,1:2)=u_start(:,M-1:M);
%        u_start(:,M+1:M+2)=u_start(:,3:4);
%        %----------------------------------------------
%        %---------blocked in both ends & Inelastic collision on wall-B.C.----------
%        for i=1:2
%            u_start(:,i)=[u_start(1,3);0;u_start(3,3)];%left wall����������ͬ�ܶ����ٶȵ��ṩѹǿ
%            u_start(:,M+5-i)=[u_start(1,M+2);0;u_start(3,M+2)];%right wall��B.C.ͬ��
%        end
%        u_start(3,3)=u_start(3,3)-1/2*u_start(2,3)^2/u_start(1,3);%�����ڵ��������۳���ѹ����Ϊ�ǵ�����ײ���ն���
%        u_start(2,3)=0;%�����ڵ����ٶ�
%        u_start(3,M+2)=u_start(3,M+2)-1/2*u_start(2,M+2)^2/u_start(1,M+2);%�ұ���ͬ��
%        u_start(2,M+2)=0;%�ұ���ͬ��
%        %--------------------------------------------------------------------------
       %---------blocked in both ends & elastic collision on wall B.C----------
       for i=1:2
%            u_start(:,i)=[u_start(1,3);0;u_start(3,3)];%left wall����������ͬ�ܶ����ٶȵ��ṩѹǿ
%            u_start(:,M+5-i)=[u_start(1,M+2);0;u_start(3,M+2)];%right wall��B.C.ͬ��
           u_start(:,i)=[density_L;0;1/(gamma-1)*pressure_L];%left wall�����������ܶȺ㶨����������ٶȵ�ѹǿ�������
           u_start(:,M+5-i)=[density_R;0;1/(gamma-1)*pressure_R];%right wall��B.C.ͬ��
       end
       u_start(2,3)=-u_start(2,3);%�����ڵ��ٶȷ��򣬷���������ײ
       u_start(2,M+2)=-u_start(2,3);%�ұ���ͬ��
       %--------------------------------------------------------------------------
end
    [ f_plus,f_minus,lamda_plus,lamda_minus,a,lamda1 ] = f_cal( u_start,gamma,M );%����ĸ�3��M+1�ľ���,�����һ��1��M+4������
    [ delta_f_plus,delta_f_minus ] = delta_f_cal( u_start,gamma,M,lamda1 );%�������3��M+1�ľ���
%     a_max=max(abs(a));%a�ǹ��и������٣����ڴ���CFL����������
    lamda_max = max(max([lamda_plus,-lamda_minus]));%���㴦�ٶȳ������ڴ���CFL����������
    for j=1:M
        ff_up = f_plus(:,1+j)+1/2*minmod( delta_f_plus(:,1+j),delta_f_plus(:,2+j) )+f_minus(:,1+j)-1/2*minmod( delta_f_minus(:,1+j),delta_f_minus(:,2+j) );
        ff_down = f_plus(:,j)+1/2*minmod( delta_f_plus(:,j),delta_f_plus(:,1+j) )+f_minus(:,j)-1/2*minmod( delta_f_minus(:,j),delta_f_minus(:,1+j) );
        u_end(:,2+j) = u_start(:,2+j)-CFL/lamda_max*( ff_up-ff_down );
%------------�����������Դ���-----------       
%         u_end(:,1) = u_start(:,3);
%         u_end(:,2) = u_start(:,3);
%         u_end(:,M+3) = u_start(:,M+2);
%         u_end(:,M+4) = u_start(:,M+2);
%---------------------------------------
    end
%     plot(lamda1(1,:))%�����ǰʱ�䲽���ٶȳ���������
%     plot(u_end(1,500:1500))%�����ǰʱ�䲽���ܶȳ���������
%--------test for B.C. based on conservation of mass---------
    mass = 0;
    for j=1:M
        mass=mass+u_end(1,2+j);
    end
    mass = mass+u_end(2,3)-u_end(2,M+2);
%------------------------------------------------------------
    dx = L/(M-1);
%     dt = CFL/a_max*dx;%a�ǹ��и������٣����ڴ���CFL����������
    dt = CFL/lamda_max*dx;
    time = time + dt;
    flag=flag+1;


%------------------------�ٶ�ѹǿ�ܶȼ��㣬��ͼ׼��-----------------------
u=u_end(2,3:M+2)./u_end(1,3:M+2);
P=(gamma-1)*(u_end(3,3:M+2)-1/2*u_end(1,3:M+2).*u.^2);
Den=u_end(1,3:M+2);

end

