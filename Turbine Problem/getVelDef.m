function [vel_def] = getVelDef(closestPoint,Nt,coords,theta,a,b,R,k, ...
    windSpeed)
% Gets Velocity Deficit at Each Turbine


% Gets Correct Order to Calculate Wakes
%--------------------------------------------------------------------

% Components of Closest Point
xClosest = closestPoint(1,1);
yClosest = closestPoint(1,2);
    

di = zeros(1,Nt);
distanceT=zeros(1,Nt);
xj=zeros(1,Nt);
yj=zeros(1,Nt);
for j = 1:Nt


   % Assign xj and yj coordinates of current turbine
   xj(j) = coords(j,1);
   yj(j) = coords(j,2);
   
   
   % Check Distance between turbine J and our closestPoint
   di(j)= abs((xClosest-xj(j))*cos(theta) + (yClosest-yj(j))*sin(theta));

distanceT(j) = di(j);
di=0;
end

distanceT = distanceT';

% Sorts the cities by distance from perimeter and stores index as well
[~,index] = sort(distanceT, 1);


% Wake Model based off nearestTurbine
%--------------------------------------------------------------------

vel_def = zeros(Nt-1,1);
%parfor here
parfor i = 2:Nt

% For each turbine 1 to total number of turbines get turbine i
ind = index(i);
xi = coords(ind,1);
yi = coords(ind,2);

% Loop starts turbine j=1 and ends at turbine closest to i (but upstream)
vel_defi = zeros(i-1,1);
for j = 1: i-1


ind2 = index(j);
xj = coords(ind2,1);
yj = coords(ind2,2);

% Check to see if turbine i is in the wake of turbine j
Bij = acosd(((xi-xj)*cos(theta)+(yi-yj)*sin(theta)+ R/k) / ...
    sqrt((xi-xj + R/k * cos(theta))^2 + (yi-yj + R/k * sin(theta))^2));

alpha = atand(k);

% If Bij < Alpha, then turbine i is in the wake of turbine j
if Bij < alpha
    
    dij = abs((xi-xj)*cos(theta) + (yi-yj)*sin(theta));
%     if dij < 4*R
%         vel_defi(j) = windSpeed;
%     else
    vel_defi(j) = a / (1 + b * dij)^2;
    vel_defi(j) = vel_defi(j)^2;
%     end
else
    vel_defi(j) = 0;
end % End if

 
end % Ends upstream turbines loop

vel_def(i) = sum(vel_defi);
vel_def(i) = sqrt(vel_def(i));

end % Ends loop for turbine i
 tempVeldef= [index,vel_def];
 sort(tempVeldef, 1);
 vel_def = tempVeldef(:,2);
% Export velocity deficits for power model
end



