function m=fi(t,q)
global LM NE
q1=q(LM(NE,10:12));
% sin(2*pi*t);
% if t<=1
    m=[
        q(1)
        q(2)
        q(3) - cos(2*pi*t)/(2*pi) + 1/(2*pi)];
% else
%     m=[
%         q(1)
%         q(2)
%         q(3)];    
% end
%     q(4)
%     q(5)
%     q(6)-1 
%     q1(1)^2+q1(2)^2+q1(3)^2-1 
    
    
%     q(4)-1
%     q(5)
%     q(6)

return