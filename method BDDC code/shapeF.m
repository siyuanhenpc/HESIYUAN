function m=shapeF(Xi,Yi)


s1=( 1-Xi )*(1-Yi);
s2=( Xi )*(1-Yi);
s3=( Xi )*(Yi);
s4=( 1-Xi )*(Yi);
m=[s1*eye(2),s2*eye(2),s3*eye(2),s4*eye(2)];


return
%-----------------------------------

