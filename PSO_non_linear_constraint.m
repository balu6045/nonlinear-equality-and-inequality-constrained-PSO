%% Jogendra Karthika Sri Sai Balaji Dulipala
% Last updated:- 19/4/2020
% contact details:- balajijogendra@gmail.com
% phone number:- 7893397808
%% Non-linear Inequality and equality constrained PSO
function [Xmin,Fmin,SUM_Constraints]=PSO_non_linear_constraint(objective_function,constraints,constraints_eq,LB,UB,nvars,Npop,max_it)
%% 
% Objective_function       function to be optimized
% nvars                    number of variables to be optimized
% npop                     number of populations
% LB                       Lower bounds of the problem
% UB                       Upper bounds of the problem
% max_it                   Maximum iterations
% constraints              Non-linear or linear inequality constraints
% constraints_eq           Non-linear or linear equality constraints
%%
format long
    w=5;
    c1=2;
    c2=2;
    alpha=0.75;
    
epss=1e-6;


for i=1:Npop
    pop(i).position=LB+(UB-LB).*rand(1,nvars);
    pop(i).cost=objective_function(pop(i).position);
    c = [constraints(pop(i).position);
         abs(constraints_eq(pop(i).position));];
    pop(i).const=sum(c(c>epss));
    pop(i).velocity=zeros(1,nvars);
end

%----------------Sort to selection the global best and local best for 1st iteration -----------------------
X_Minus=[];
aa=[pop.const];
COST_MINUS=[pop(aa<=epss).cost];
if ~isempty(COST_MINUS)
    X_Minus=pop(aa<=epss);
    [~,INDEX_M]=sort(COST_MINUS);
    X_Minus=X_Minus(INDEX_M);
end

X_PLUS=[];
SUM_C_PLUS=aa(aa>epss);
COST_PLUS=[pop(aa>epss).cost];
if ~isempty(SUM_C_PLUS)
    AD=unique(SUM_C_PLUS);
    if size(AD,2)==Npop
        X_PLUS=pop(aa>epss);
        [~,INDEX_P]=sort(SUM_C_PLUS);
    else
        X_PLUS=pop(aa>epss);
        [OR,INDEX]=sort(SUM_C_PLUS);
        COST_PLUS=COST_PLUS(INDEX);
        
        kk=1;
        N=0;
        
        for m=1:size(AD,2)
            B=length(find(AD(m)==OR));
            [~,IND]=sort(COST_PLUS(kk:N+B));
            INDEX_P(kk:N+B)=IND;
            kk=B+1;
            N=N+B;
        end
    end
    X_PLUS=X_PLUS(INDEX_P);
end

pop=[X_Minus;X_PLUS];
%------------- Forming the global best ------------------------------------------------
global_best=pop(1);
%%
%----------- Main Loop of PSO ---------------------------------------------
disp('******************** Particle Swarm Optimization (PSO)********************');
disp('*Iterations  Function Values  Sum_Const ****************************');
disp('********************************************************************');
FF=zeros(max_it,1);

for i=1:max_it
   if i==1
       local_best=global_best;
   end
    %---------- Moving particals to the local and global best positions---------------------------------------
    for j=1:Npop
        pop(j).velocity = w.*pop(j).velocity+c1.*rand(1).*(global_best.position-pop(j).position)+c2.*rand(1).*(local_best.position-pop(j).position);
        pop(j).position = pop(j).velocity+pop(j).position;
        pop(j).position=min(pop(j).position,UB);
        pop(j).position=max(pop(j).position,LB);
        
        
        pop(j).cost=objective_function(pop(j).position);
        c=[constraints(pop(j).position);
            abs(constraints_eq(pop(j).position));];
        pop(j).const=sum(c(c>epss));
    end
    
    
    local_best=global_best;
    w=w*alpha;
    
   for j=1:Npop  
        if (global_best.const<=epss && pop(j).const<=epss && pop(j).cost<global_best.cost)||(global_best.const>epss && pop(j).const<=epss)
            
            global_best=pop(j);
         
        elseif global_best.const>epss && pop(j).const>epss && global_best.const>pop(j).const
            
            global_best=pop(j);
            
        end
   end
disp(['Iteration: ',num2str(i),'   Fmin= ',num2str(global_best.cost),'  Sum_Const= ',num2str(global_best.const)]);
FF(i)=objective_function(global_best.position);
cq=[constraints(global_best.position);
            abs(constraints_eq(global_best.position));];
FF2(i)=sum(cq(cq>epss));
end
%% Results and Plot

figure
subplot(2,1,1)
plot(FF,'LineWidth',2);
ylabel('Function Value of Global best');
xlabel('Number of Iterations');
subplot(2,1,2)
plot(FF2,'LineWidth',2);
ylabel('Total constraint violations of Global best');
xlabel('Number of Iterations');


Xmin=global_best.position;
Fmin=objective_function(Xmin);
SUM_Constraints=global_best.const;
end

