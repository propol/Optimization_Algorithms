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

%Same reasons with quadratic_Hessian_2.m
syms y1 y2 y3;
assume(y1, 'real');
assumeAlso(y1 < 0 | y1 > 0);
assume(y2, 'real');
assumeAlso(y2 < 0 | y2 > 0);
assume(y3, 'real');
assumeAlso(y3 < 0 | y3 > 0);

%For every solution do the following..
for i = 1:sizeX(1)
    
    flag_min = false;
    flag_max = false;
    
    %Calculate HF_star on the solution of GradF=0 that is being
    %investigated
    HF_star = subs(HF,{x1,x2,x3}, {solutions(i,1), solutions(i,2), solutions(i,3)});
    %the chol() method returns the sign of the Hessian matrix
    %(positive/negative definite) in the p variable contained in [~,p]
    [~,p] = chol(HF_star);
    
    %make calculations to find the quadratic form of the Hessian matrix at
    %the solution being investigated
    x_matrix = [x1; x2; x3];

    HF_star_new = HF_star * x_matrix;
    
    x_matrix_T = x_matrix.';

    %the quadratic form
    quadratic_HF = x_matrix_T * HF_star_new;
    %replacing x1,x2,x3 with y1,y2,y3 for the reasons explained above
    Q_HF = subs(quadratic_HF,{x1,x2,x3}, {y1,y2,y3});
    simple_QHF = simplify(Q_HF);
    
    %Same reasons with quadratic_Hessian_2.m
    %Check if the Hessian matrix is positive definite or negative definite(
    %through the sign of the quadratic form or from variable p)
    %or neither to make assumptions about the local min/max
    if p == 0 || isAlways(Q_HF > 0, 'Unknown', 'false')
        flag_min = true;
        fprintf('[%d, %d, %d] is a local minimizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
    elseif isAlways(simple_QHF < 0, 'Unknown', 'false') == 1
        flag_max = true;
        fprintf('[%d, %d, %d] is a local maximizer. \n', solutions(i,1), solutions(i,2), solutions(i,3));
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