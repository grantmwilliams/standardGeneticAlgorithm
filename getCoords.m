function coords = getCoords(Nt,Pop)


Pop1 = Pop(1:end, 1:end/2);
Pop2= Pop(1:end, end/2+1:end);

% Sub Function for Binary to Decimal Conversion
temp1 = 0; temp2=0;
d = zeros(1, length(Pop));
e = zeros(1,length(Pop));

for j = 1:Nt
    A = Pop1(j, 1:end);
for i =1: length(A)
    temp1 = A(i)*2^(length(A)-i) + temp1;
end
d(j) = temp1;
temp1 = 0;
end

for jj = 1:Nt
    B = Pop2(jj, 1:end);
for ii =1:length(B)
    temp2 = B(ii)*2^(length(B)-ii) + temp2;
end
e(jj) = temp2;
temp2=0;
end



%-----------------
   e = e';
   d = d';

%----------------------

coords = [d,e];


end
