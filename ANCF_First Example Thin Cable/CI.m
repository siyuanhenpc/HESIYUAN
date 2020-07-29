function v=CI

v=[];
% for i=0:1:20
%     q=[0.5-0.5*cos(i/20*pi) 0 0.5*sin(i/20*pi) cos(pi/2-i/20*pi) 0 sin(pi/2-i/20*pi) ]';
% %     q=[0.5-0.5*cos(i/180*pi) 0 0.5*sin(i/180*pi) cos(pi/2-i/180*pi) 0 sin(pi/2-i/180*pi) ]';
%     v=[v;q];
% end

global BEleInf NN NUMGEN
v=zeros(NUMGEN,1);
for i=1:NN
    v(6*i-5:6*i,1)=[  (i-1)*BEleInf(1,1)  0 0   1 0 0]';
end


return