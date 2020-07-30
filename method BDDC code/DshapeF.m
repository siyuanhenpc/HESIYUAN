function [Sx Sy]=DshapeF(Xi,Yi,Esize)

EPLx=Esize(1);
EPLy=Esize(2);
%------------------------------------- Sx
s1x=Yi - 1;
s2x=1 - Yi;
s3x= Yi;
s4x= -Yi;
%------------------------------------- Sy
s1y=Xi - 1;
s2y=-Xi;
s3y=Xi;
s4y=1-Xi;

Sx=[s1x*eye(2) s2x*eye(2) s3x*eye(2) s4x*eye(2)]/EPLx;
Sy=[s1y*eye(2) s2y*eye(2) s3y*eye(2) s4y*eye(2)]/EPLy;

return
%-----------------------------------

