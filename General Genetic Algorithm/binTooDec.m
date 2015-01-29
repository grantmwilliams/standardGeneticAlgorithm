function [cartPop] = binTooDec(Pop)
% Function to convert binary population into cartesian coordinates

temp1 = 0;

cartPop = zeros(1, length(Pop));

for j = 1:length(Pop)
    A = Pop(j, 1:end);
for i =1: length(A)
    temp1 = A(i)*2^(length(A)-i) + temp1;
end % End Inner Loop
cartPop(j) = temp1;
temp1 = 0;
end % End Outer Loop

cartPop = cartPop';

end % End Function

