%% Standard Genetic Algorithm
clear;close all;clc;

%% Parameters
popSize = 100;                             % Population Size
genome = 11;                                % Genome Size
mutRate = .01;                              % Mutation Rate
S = 2;                                      % Tournament Size
limit = 100;                                % Number of Generations
best = 0;                                   % Initialize Best
%% Initialize Population
Pop = round(rand(popSize,genome));

%% Begin Main Algorithm

for Gen = 1:limit
    
    %% Fitness
   
    %BintoDec function will convert to decimal for fitnesses requiring that
    %input type
    
    %Fitness function goes here
    F = sum(abs(diff(Pop,[],2)),2);         % Measure Fitness
    
    current = F(Gen);
    
    if best < current
        best = current;
        bestGenome = Pop(Gen,:);
    else
    end
   
    
    
    %% Print Stats
    fprintf('Gen: %d    Mean Fitness: %d    Best Fitness: %d\n', Gen, round(mean(F)), max(F));
    
    %% Tournament Selection
    T = round(rand(2*popSize,S)*(popSize-1)+1);     % Tournaments
    [~,idx] = max(F(T),[],2);                       % Index of Winners
    W = T(sub2ind(size(T),(1:2*popSize)',idx));     % Winners
    
    %% 2-Point Crossover
    Pop2 = Pop(W(1:2:end),:);                       % New Pop is Winners of old Pop
    P2A  = Pop(W(2:2:end),:);                       % Assemble Pop2 Winners 2
    Ref  = ones(popSize,1)*(1:genome);               % Ones Matrix
    CP   = sort(round(rand(popSize,2)*(genome-1)+1),2); % Crossover Points
    idx = CP(:,1)*ones(1,genome)<Ref&CP(:,2)*ones(1,genome)>Ref; % Index
    Pop2(idx)=P2A(idx);                             % Recombine Winners
    
    %% Mutation (bitflip)
    idx = rand(size(Pop2))<mutRate;                 % Index for Mutations
    Pop2(idx) = Pop2(idx)*-1+1;                     % Bit Flip Occurs
    
    %% Reset Poplulations
    Pop = Pop2;
    
end % End main loop

%% Prints Best Stats
fprintf('Best Fitness: %d\n', best);
disp('Best Genome: ');
disp(bestGenome);

test = binTooDec(Pop);
    
