function Moment_NE=Concentrate_Moment(q,M)

F=cross(M,[q(10),q(11),q(12)]);
F=F/norm(F);

F=F/norm([q(10),q(11),q(12)])*norm(M);%
%----Examine
cross([q(10),q(11),q(12)],F);


Moment_NE=[zeros(1,9) F]';
end