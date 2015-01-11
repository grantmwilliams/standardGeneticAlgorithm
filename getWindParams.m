function [theta,windSpeed,closestPoint] = getWindParams(weibul)
% Defines Location Nearest to Wind Direction
A1=round([2047,2047/2]);
A2=round([2047,3/4 * 2047]);
A3=round([2047,2047]);
A4=round([2047 * 3/4, 2047]);
A5=round([2047/2,2047]);
A6=round([2047/4, 2047]); 
A7=round([0,2047]);
A8=round([0,3/4 * 2047]);
A9=round([0,2047/2]);
A10=round([0,2047/4]);
A11=round([0,0]);
A12=round([2047/4, 0]);
A13=round([2047/2, 0]);
A14=round([3/4 * 2047,0]);
A15=round([2047,0]);
A16=round([2047,2047/4]);
A17=round([2047,2047/2]);


% Get Wind Direction and Closest Point
thetaProb = round((rand()*100)*10)/10;

if (0 < thetaProb) && (thetaProb <= 1.5)
    theta = 0; closestPoint=A1;
    
elseif (1.5 < thetaProb) && (thetaProb <= 5.3)
    theta = 22.5; closestPoint=A2;
    
elseif (5.3 < thetaProb) && (thetaProb <= 9.8)
    theta=45;   closestPoint=A3;
   
elseif (9.8 < thetaProb) && (thetaProb <=16.2)
    theta=67.5; closestPoint=A4;
    
elseif (16.2 < thetaProb) && (thetaProb <= 23.7)
    theta=90; closestPoint=A5;
   
elseif (23.7 < thetaProb) && (thetaProb <= 32)
    theta=112.5; closestPoint=A6;
    
elseif (32 < thetaProb) && (thetaProb <= 36.1)
    theta=135; closestPoint=A7;
    
elseif (36.1 < thetaProb) && (thetaProb <= 38.2)
    theta=157.5; closestPoint=A8;
   
elseif (38.2 < thetaProb) && (thetaProb <= 39.8)
    theta=180; closestPoint=A9;
    
elseif (39.8 < thetaProb) && (thetaProb <= 41.8)
    theta=202.5; closestPoint=A10;
    
elseif (41.8 < thetaProb) && (thetaProb <= 45.7)
    theta=225; closestPoint=A11;
    
elseif (45.7 < thetaProb) && (thetaProb <= 59.2)
    theta=247.5; closestPoint=A12;
   
elseif (59.2 < thetaProb) && (thetaProb <= 78)
    theta=270; closestPoint=A13;
    
elseif (78 < thetaProb) && (thetaProb <= 90.1)
    theta=292.5; closestPoint=A14;
    
elseif (90.1 < thetaProb) && (thetaProb <= 95.4)
    theta=315; closestPoint=A15;
    
elseif (95.4 < thetaProb) && (thetaProb <= 98.6)
    theta=337.5; closestPoint=A16;
   
else
    theta=360; closestPoint=A17;
    
end


% Get Wind Speed

if weibul == 0
windSpeed = wblrnd(13,2);
else
windSpeed = 14;
end
end

