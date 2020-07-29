% V=q0';
TOT=size(V,1);
cla
for m=1:1:TOT%
    for n=1:NE
        q=V(m,1:NUMGEN)';
        e=q( LM(n,:) );
        L=BEleInf(n,1);
        j=1;
        a1=[];
        b1=[];
        c1=[];
        for i=0:0.1:1
            k=shapeF(i,L)*e;
            a1(j,1)=k(1,1);
            b1(j,1)=k(2,1);
            c1(j,1)=k(3,1);
            j=j+1;
        end
        XX1=a1;
        YY1=b1;
        ZZ1=c1;
        plot3(XX1,YY1,ZZ1,'color','r','linewidth',2); hold on
%         plot3(e(1),e(2),e(3),'color','b','marker','.','markersize',15); hold on
%         plot3(e(7),e(8),e(9),'color','b','marker','.','markersize',15);
%         hold on
    end
    hold off;
    title('3D ANCF Beam');
    xlabel('x-Axial');
    ylabel('y-Axial');
    zlabel('Z-Axial');
%     axis equal
%     axis([0 2 -1 1 -2 1]);
    axis([0 30 -1 1 -1 1]);
%     axis equal
    view([0 1 0]);
%     grid on
%     drawnow
    pause(0.01);
end