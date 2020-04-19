clc   %clears the command window
clear all   % clears the previous work space
close all    % closes the privous graphical objects(figures)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  constrained function with equality and inequality contraints
fun=@(x)(((x(1)-10)^2)+5*((x(2)-12)^2)+(x(3)^4)+5*((x(4)-12)^2)+10*(x(5)^6)+7*(x(6)^2)+(x(7)^4)-4*x(6)*x(7)-10*x(6)-8*x(7));
%%
constraints=@(x)[2*(x(1)^2)+3*(x(2)^4)+(x(3))+4*(x(4)^2)+5*(x(5))-127;
                 7*(x(1))+3*(x(2))+10*(x(3)^2)+(x(4))-(x(5))-282;
                 23*(x(1))+(x(2)^2)+6*(x(6)^2)-8*(x(7))-196;];
             
% 2*(x(1)^2)+3*(x(2)^4)+(x(3))+4*(x(4)^2)+5*(x(5))-127<=0;
% 7*(x(1))+3*(x(2))+10*(x(3)^2)+(x(4))-(x(5))-282<=0;
% 23*(x(1))+(x(2)^2)+6*(x(6)^2)-8*(x(7))-196<=0;
%%
constraints_eq=@(x)[4*(x(1)^2)+(x(2)^2)-3*(x(1)*x(2))+2*(x(3)^2)+5*(x(6))-11*(x(7));];
% 4*(x(1)^2)+(x(2)^2)-3*(x(1)*x(2))+2*(x(3)^2)+5*(x(6))-11*(x(7))=0
%%
nvars=7; % number of variables to be optimized
LB=[-10 -10 -10 -10 -10 -10 -10];
UB=[10 10 10 10 10 10 10];
Npop=200;
max_iter=5000;
[Xmin,Fmin]=PSO_non_linear_constraint(fun,constraints,constraints_eq,LB,UB,nvars,Npop,max_iter);



