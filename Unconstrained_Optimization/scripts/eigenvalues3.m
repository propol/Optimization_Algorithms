syms x1 x2 x3;
assume(x1, 'real');
assume(x2, 'real');
assume(x3, 'real');
tic

f= x1^2 + 2*x2^2 + 5*x3^2 - 2*x1*x2 - 4*x2*x3 -2*x3; %obj function (d)

%Calculate the Gradient of the objective function
GradF = sym(zeros(3,1));
GradF = [diff(f, x1); diff(f, x2); diff(f, x3)];

%Calculate the Hessian Matrix of the objective function
HF = sym(zeros(3,3));
HF = hessian(f,[x1,x2,x3]);                                                                                

%Solve GradF = 0 to find possible local minimizers/maximizers
X = solve([diff(f, x1) == 0, diff(f, x2) == 0, diff(f, x3) == 0], [x1, x2, x3]);
sizeX = size(X.x1);

%Store the solutions of GradF = 0
solutions = sym(zeros(sizeX(1),3));
for i = 1:sizeX(1)
    solutions(i,1) = X.x1(i);
    solutions(i,2) = X.x2(i);
    solutions(i,3) = X.x3(i);
end


%For every solution do the following..
for i = 1:sizeX(1)
    
    flag_min = false;
    flag_max = false;
    
    %Calculate HF_star on the solution of GradF=0 that is being
    %investigated
    HF_star = subs(HF,{x1,x2,x3}, {solutions(i,1), solutions(i,2), solutions(i,3)});
    
    %Calculate the eigenvalues of HF_star
    eig_star=eig(HF_star);
    
    %Check the sign of the eigenvalues calculated to make an assumption as
    %whether the point investigated is local min/max or nothing at all
    %Here the method isAlways() is called, because when I tried to do the
    %comparisons without it, it wouldn't compile because of an error trying
    %to convert type sym to type logical. By using this method, I get the
    %wanted result
    if isAlways(eig_star(1) > 0) && isAlways(eig_star(2) > 0) && isAlways(eig_star(3) > 0)
        flag_min = true;
        fprintf('[%d, %d, %d] is a local minimizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
    elseif isAlways(eig_star(1) < 0) && isAlways(eig_star(2) < 0) && isAlways(eig_star(3) < 0)
        flag_max = true;
        fprintf('[%d, %d, %d] is a local maximizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
    elseif isAlways(eig_star(1) == 0) || isAlways(eig_star(2) == 0) || isAlways(eig_star(3) == 0)
        fprintf('Det value is found to be 0. This method cannot be used. \n')
    else
        fprintf('[%d, %d, %d] is not a local minimizer/maximizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
    end
    
    %if a local min was found, check if it is also a global min
    if flag_min == true
        f_min = subs(f, {x1,x2,x3}, {solutions(i,1), solutions(i,2), solutions(i,3)});
        
        if isAlways( f >= f_min, 'Unknown', 'false' ) == 0
            fprintf('[%d, %d, %d] is not a global minimizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
        else
            fprintf('[%d, %d, %d] is a global minimizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
        end 
    %if a local max was found, check if it is also a global max
    elseif flag_max == true
        f_max = subs(f, {x1,x2,x3}, {solutions(i,1), solutions(i,2),solutions(i,3)});
        
        if isAlways( f <= f_max, 'Unknown', 'false' ) == 0
            fprintf('[%d, %d, %d] is not a global maximizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
        else
            fprintf('[%d, %d, %d] is a global maximizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
        end
    end
end

timeElapsed = toc;
fprintf('The elapsed time was: %f \n', timeElapsed);
