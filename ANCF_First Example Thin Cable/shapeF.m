function m=shapeF(Xi, l_e)

l=l_e;
% Computational Continuum.270.
%-------------Shape Function--------------------
s1=1-3*Xi^2+2*Xi^3;
s2=l*(Xi-2*Xi^2+Xi^3);
s3=3*Xi^2-2*Xi^3;
s4=l*(-Xi^2+Xi^3);

% Analysis of  Thin Beams and Cables Using the ANCF
% Xi=2*X/l-1;
% %-------------Shape Function--------------------
% s1=1/2-3/4*Xi+Xi^3/4;
% s2=l/8*(1-Xi-Xi^2+Xi^3);
% s3=1/2+3/4*Xi-Xi^3/4;
% s4=l/8*(-1-Xi+Xi^2+Xi^3);
%-----------------------------------
m=[s1*eye(3),s2*eye(3),s3*eye(3),s4*eye(3)];
return