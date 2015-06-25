%% Standard Genetic Algorithm -- Traveling Salesman Problem
clear;close all;clc;

%% Parameters
popSize = 100;                              % Population Size
cities = 10;                                % Genome Size
mutRate = .01;                              % Mutation Rate
S = 2;                                      % Tournament Size
limit = 100;                                % Number of Generations
best = Inf;                                 % Initialize Best

%% Initialize Population
[~,Pop] = sort(rand(popSize,cities),2);     % Initial Population

for Gen = 1:limit
    
    %% Fitness
 
    F = var(diff(Pop,[],2),[],2);           % Measurement of Fitness
    
    
    d = pdist(X,'euclidiean');              % Distance between 2 cities
    %% Print Stats
    fprintf('Gen: %d    Mean Fitness: %d    Best Fitness: %d\n',Gen,round(mean(F)),round(max(F)));
    
    %% Tournament Selection
    T = round(rand(2*popSize,S)*(popSize-1)+1);     % Tournaments
    [~,idx] = max(F(T),[],2);                       % Index of Winners
    W = T(sub2ind(size(T),(1:2*popSize)',idx));     % Winners
    
    %% Single-Point Preservation Crossover
    Pop2 = Pop(W(1:2:end),:);                       % Pop2 Winners 1
    P2A  = Pop(W(2:2:end),:);                       % Pop2 Winners 2
    Lidx = sub2ind(size(Pop),[1:popSize]',round(rand(popSize,1)*(cities-1)+1));
    vLidx = P2A(Lidx)*ones(1,cities);
    [r,c]=find(Pop2==vLidx);
    [~,Ord]=sort(r);
    r = r(Ord); c = c(Ord);
    Lidx2 = sub2ind(size(Pop),r,c);
    Pop2(Lidx2) = Pop2(Lidx);
    Pop2(Lidx) = P2A(Lidx);
    
    %% Mutation (Permutation)
    idx = rand(popSize,1)<mutRate;
    Loc1 = sub2ind(size(Pop2),1:popSize,round(rand(1,popSize)*(cities-1)+1));
    Loc2 = sub2ind(size(Pop2),1:popSize,round(rand(1,popSize)*(cities-1)+1));
    
    Loc2(idx == 0) = Loc1(idx == 0);
    [Pop2(Loc1), Pop2(Loc2)] = deal(Pop2(Loc2), Pop2(Loc1));
    
    
    %% Reset Population
    Pop = Pop2;
    
end

%% Prints Best Stats
% [BF,BG] = max(F);
% fprintf('Best Fitness: %d\n', BF);
% disp('Best Genome: ');
% disp(Pop(BG,:));
