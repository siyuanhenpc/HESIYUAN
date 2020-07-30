function [Sxx Syy Sxy]=DDshapeF(Xi,Yi,Esize)

EPLx=Esize(1);
EPLy=Esize(2);
%------------------------------------- Sxx
s1xx=0;
s2xx=0;
s3xx=0;
s4xx=0;
%------------------------------------- Syy
s1yy=0;
s2yy=0;
s3yy=0;
s4yy=0;
%------------------------------------- Syy
s1xy=1;
s2xy=-1;
s3xy=1;
s4xy=-1;

Sxx=[s1xx*eye(2) s2xx*eye(2) s3xx*eye(2) s4xx*eye(2)]/EPLx/EPLx;
Syy=[s1yy*eye(2) s2yy*eye(2) s3yy*eye(2) s4yy*eye(2)]/EPLy/EPLy;
Sxy=[s1xy*eye(2) s2xy*eye(2) s3xy*eye(2) s4xy*eye(2)]/EPLx/EPLy;
return
%-----------------------------------

