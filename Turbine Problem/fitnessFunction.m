function [F,totalPower] = fitnessFunction(Nt,vel_def,windSpeed,vin,... 
    vrated,lambda, nu, prated,vout)
F=zeros(Nt,1);

%parfor here
for i = 1:Nt
    v = windSpeed - vel_def(i);
    
    if v < vin
        F(i) = 0;
    elseif (vin<=v) && (v <= vrated)
    F(i) = lambda * v + nu;
    elseif (vout > v) && (v > vrated)
            F(i) = prated;
    else
        F(i)=0;
    end
end
totalPower = sum(F);
end


