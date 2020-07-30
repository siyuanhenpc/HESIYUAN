function [ min_mod ] = minmod( a,b )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
min_mod=zeros(3,1);
for i=1:3
    if a(i)*b(i)<=0
        min_mod(i) = 0;
    else
        if abs(a(i))<abs(b(i))
            min_mod(i) = a(i);
        else
            min_mod(i) = b(i);
        end
    end
end

end

