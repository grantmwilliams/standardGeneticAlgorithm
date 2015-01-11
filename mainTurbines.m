% Main Script Wind Turbine Genetic Algorithm
%
%
% 
% 
%
% Grant Williams

clear
clc
close all
tic

% Variables
Nt=500;             % Number of Turbines
genomeLength=11;    % Length of Single Genome
G=genomeLength*2;   % Length of total Genome
mutRate=.025;       % Chance for Mutation
S=4;                % Tournament Size
maxGen=100;         % Maximum Number of Generations
F=0;                % Initial fitness = 0;
Ct = 0.8;           % Thrust Coefficient
k = 0.075;          % Spreading Constant
R = 38.5;           % Radius of blades
lambda = 140.86;    % Part of linear power function
nu = -500;          % Part of linear power function
vin = 3.5;          % Cut in wind speed
vrated = 14;        % Rated wind speedtg
prated =1500;       % Rated power (kilowatts)
best=0;             % Initial total power
vout =25;           % Cut out speed
plotting = 1;       % 1 for plotting 2 for csv output 0 for no plot 3 for png output
% Genetic Algorithm Parameters
selectionType = 2;  % 0 for tourney 1 for truncation and 2 for roulette
crossoverType = 0;  % 0 uniform, 1 for 1 point, 2 for two point
weibul = 1;         % For 0 use weibul distribution 1 for constant wind
% Coefficients for wakes
a = 1- sqrt(1-Ct);
b = k/R;



% Initial Turbine Locations
Pop=round(rand(Nt,G));

for Gen=1:maxGen
    
    
% Fitness Check
coords = getCoords(Nt,Pop);
[theta,windSpeed,closestPoint] = getWindParams(weibul);
[vel_def] = getVelDef(closestPoint,Nt,coords,theta,a,b,R,k,windSpeed);
[F,totalPower] = fitnessFunction(Nt,vel_def,windSpeed,vin,vrated, ...
    lambda, nu, prated,vout);

if totalPower > best
    lastBest = best;
    best = totalPower;
    bestCoords = coords;
else
end
   
%**************************************************************************

% Print Stats on Fitness

if plotting == 1
elseif plotting == 2 || plotting == 3 || plotting == 0
fprintf('Gen: %d    Current: %d    Best Power: %d\n', ...
Gen,round(totalPower), best);
end
%**************************************************************************
if plotting == 1

% Plot Locations
plot(coords(:,1),coords(:,2),'ro',bestCoords(:,1),bestCoords(:,2), 'b.')
title(sprintf('Generation: %i Current: %d Best: %d',Gen,totalPower,best));
axis([0 2000 0 2000])
drawnow;


elseif plotting == 2
    
% outputs Data as CSV file    
x1 = coords(:,1); y1 = coords(:,2);
bx1 = bestCoords(:,1); bx2 = bestCoords(:,2);
Data = horzcat(x1,y1,bx1,bx2);
fname = sprintf('Data%d.dat',Gen);
csvwrite(fname,Data);

elseif plotting == 3
fname = sprintf('Plot%d.png',Gen);


figure(1); % Creates the figure with handle 1
plot(coords(:,1),coords(:,2),'ro',bestCoords(:,1),bestCoords(:,2), 'b.')
title(sprintf('Generation: %i Current: %d Best: %d',Gen,totalPower,best));
axis([0 2000 0 2000])
saveas(1, fname, 'png')

else
end

%**************************************************************************

if selectionType == 0
% Tournament Selection
T = round(rand(2*Nt,S)*(Nt-1)+1);       % Tournaments
[~,idx] = max(F(T),[],2);               % Index to Determine Winners
W = T(sub2ind(size(T),(1:2*Nt)',idx));  % Winners

%--------------------------------------------------------------------------
elseif selectionType ==1

% 50% Truncation Selection
[~,V]= sort(F);
V = V(Nt/2+1:end);
W = V(round(rand(2*Nt,1)*(Nt/2-1)+1))';
else
    
%--------------------------------------------------------------------------    

% Roulette Selection
[~,W] = min(ones(Nt,1)*rand(1,2*Nt)>((cumsum(F)*ones(1,2*Nt)/sum(F))),[],1);

end

%**************************************************************************

if crossoverType == 0
xPop = Pop(:,1:G/2);
yPop = Pop(:,G/2+1:end);
xidx = logical(round(rand(size(xPop))));   % Index of Genome for x Winner 2
yidx = logical(round(rand(size(yPop))));   % Index of Genome for y Winner 2

% For x genome
xPop2 = xPop(W(1:2:end),:);                % Set Pop2 = xPop Winners1    
xP2A = xPop(W(2:2:end),:);                % Assemble xPop2 Winners 2
xPop2(xidx) = xP2A(xidx);                % Combine x Winners 1 and 2

% For y genome
yPop2 = yPop(W(1:2:end),:);                % Set Pop2 = yPop Winners1    
yP2A = yPop(W(2:2:end),:);                % Assemble yPop2 Winners 2
yPop2(yidx) = yP2A(yidx);                % Combine y Winners 1 and 2

% Reassemble Populations
Pop2 = horzcat(xPop2,yPop2);
P2A = horzcat(xP2A,yP2A);

%--------------------------------------------------------------------------    
    
elseif crossoverType ==1

xPop = Pop(:,1:G/2);
yPop = Pop(:,G/2+1:end);
    
Pop2 = Pop(W(1:2:end),:);                   % Set Pop2 = Pop Winners 1
P2A  = Pop(W(2:2:end),:);                   % Assemble Pop2 Winners 2

% Split Pop2 for x and y genomes
xPop2 = Pop2(:,1:G/2);
yPop2 = Pop2(:,G/2 + 1:end);

% Split P2A for x and y genomes
xP2A = P2A(:,1:G/2);
yP2A = P2A(:,G/2+2:end);

% For x genome
xPop2 = xPop(W(1:2:end),:);                 % Set xPop2 = Pop x Winners 1
xP2A = xPop(W(2:2:end),:);                  % Assemble Pop2 x Winners 2
Ref = ones(Nt,1)*(1:G/2);                   % Reference Matrix
xidx=(round(rand(Nt,1)*(G/2-1)+1)*ones(1,G/2))>Ref; % Logical Index
xPop2(xidx)=xP2A(xidx);                     % Recombine x Winners

% For y genome
yPop2 = yPop(W(1:2:end),:);                 % Set yPop2 = Pop y Winners 1
yP2A = yPop(W(2:2:end),:);                  % Assemble Pop 2 y Winners 2
Ref = ones(Nt,1)*(1:G/2);                   % Reference Matrix
yidx=(round(rand(Nt,1)*(G/2-1)+1)*ones(1,G/2))>Ref; % Logical Index
yPop2(yidx)=yP2A(yidx);                     % Recombine y Winners

% Reassemble Pop2 and P2A from components
Pop2 = horzcat(xPop2,yPop2);
P2A = horzcat(xP2A,yP2A);

%--------------------------------------------------------------------------    

else
% Two-Point Crossover
Pop2 = Pop(W(1:2:end),:);                   % Set Pop2 = Pop Winners 1
P2A  = Pop(W(2:2:end),:);                   % Assemble Pop2 Winners 2

% Split Pop2 for x and y genomes
xPop2 = Pop2(:,1:G/2);
yPop2 = Pop2(:,G/2 + 1:end);

% Split P2A for x and y genomes
xP2A = P2A(:,1:G/2);
yP2A = P2A(:,G/2+2:end);

% For x genome
Ref  = ones(Nt,1)*(1:G/2);                     % Reference Matrix
CP   = sort(round(rand(Nt,2)*(G/2-1)+1),2);    % Crossover Points
xidx  = CP(:,1)*ones(1,G/2)<Ref & CP(:,2)*ones(1,G/2)>Ref;   % Logical Index
xPop2(xidx) = xP2A(xidx);                       % Recombine Winners


% For y genome
Ref  = ones(Nt,1)*(1:G/2);                     % Reference Matrix
CP   = sort(round(rand(Nt,2)*(G/2-1)+1),2);    % Crossover Points
yidx  = CP(:,1)*ones(1,G/2)<Ref & CP(:,2)*ones(1,G/2)>Ref;   % Logical Index
yPop2(yidx) = yP2A(yidx);                       % Recombine Winners

Pop2 = horzcat(xPop2,yPop2);
P2A = horzcat(xP2A,yP2A);
end

%**************************************************************************

% Mutation
idx = rand(size(Pop2))<mutRate;             % Index of Mutations
Pop2(idx) = Pop2(idx)*-1+1;                 % Flip Bits

%**************************************************************************

% Reset
Pop = Pop2;
end

if plotting == 1
% Plot Location of Best Turbines
figure(2)
plot(bestCoords(:,1),bestCoords(:,2), 'b.')
axis([0 2000 0 2000])
else
end


disp('Best Power Output: ');
disp(best);
percentageError = best / (Nt*prated) * 100;
disp(percentageError);
toc
