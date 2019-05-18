syms x1 x2;
assume(x1, 'real');
assume(x2, 'real');
tic

f = x1^2 - 2*x1*x2^2 + x2^4 - x2^5; %obj function (c)
%f = 8*x1^2 + 3*x1*x2 + 7*x2^2 - 25*x1 +31*x2 - 29; %obj function (a)
%f = x1^2 + x1*x2 + 1.5*x2^2 - 2*log(x1) - log(x2); %obj function (b)

%Calculate the Gradient of the objective function
GradF = sym(zeros(2,1));
GradF = [diff(f, x1); diff(f, x2)];

%Calculate the Hessian Matrix of the objective function
HF = sym(zeros(2,2));
HF = hessian(f,[x1,x2]);                                                                                

%Solve GradF = 0 to find possible local minimizers/maximizers
X = solve([diff(f, x1) == 0, diff(f, x2) == 0], [x1, x2]);
sizeX = size(X.x1);

%Store the solutions of GradF = 0
solutions = sym(zeros(sizeX(1),2));
for i = 1:sizeX(1)
    solutions(i,1) = X.x1(i);
    solutions(i,2) = X.x2(i);
end

%For every solution do the following..
for i = 1:sizeX(1)
    
    flag_min = false;
    flag_max = false;
    
    %Calculate HF_star on the solution of GradF=0 that is being
    %investigated
    HF_star = subs(HF,{x1,x2}, {solutions(i,1), solutions(i,2)});
    
    %Calculate the eigenvalues of HF_star
    eig_star=eig(HF_star);
    
    %Check the sign of the eigenvalues calculated to make an assumption as
    %whether the point investigated is local min/max or nothing at all
    if eig_star(1) > 0 && eig_star(2) > 0
        flag_min = true;
        fprintf('[%d, %d] is a local minimizer. \n', solutions(i,1), solutions(i,2));
    elseif eig_star(1) < 0 && eig_star(2) < 0 
        flag_max = true;
        fprintf('[%d, %d] is a local maximizer. \n', solutions(i,1), solutions(i,2));
    elseif eig_star(1) == 0 || eig_star(2) == 0
        fprintf('Eigenvalue is found to be 0. This method cannot be used. \n')
    else
        fprintf('[%d, %d] is not a local minimizer/maximizer. \n', solutions(i,1), solutions(i,2));
    end
    
    %if a local min was found, check if it is also a global min
    if flag_min == true
        f_min = subs(f, {x1,x2}, {solutions(i,1), solutions(i,2)});
        
        if isAlways( f >= f_min, 'Unknown', 'false' ) == 0
            fprintf('[%d, %d] is not a global minimizer. \n', solutions(i,1), solutions(i,2));
        else
            fprintf('[%d, %d] is a global minimizer. \n', solutions(i,1), solutions(i,2));
        end 
    %if a local max was found, check if it is also a global max
    elseif flag_max == true
        f_max = subs(f, {x1,x2}, {solutions(i,1), solutions(i,2)});
        
        if isAlways( f <= f_max, 'Unknown', 'false' ) == 0
            fprintf('[%d, %d] is not a global maximizer. \n', solutions(i,1), solutions(i,2));
        else
            fprintf('[%d, %d] is a global maximizer. \n', solutions(i,1), solutions(i,2));
        end
    end
end

timeElapsed = toc;
fprintf('The elapsed time was: %f \n', timeElapsed);