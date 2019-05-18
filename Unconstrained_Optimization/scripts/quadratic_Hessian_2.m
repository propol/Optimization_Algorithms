syms x1 x2;
assume(x1, 'real');
assume(x2, 'real');
tic

f = x1^2 - 2*x1*x2^2 + x2^4 - x2^5; %obj function (c)
%f = 8*x1^2 + 3*x1*x2 + 7*x2^2 - 25*x1 +31*x2 - 29; %obj function (a)
%f = x1^2 + x1*x2 + 1.5*x2^2 - 2*log(x1) - log(x2); %obj function (b)

%Calculate the Gradient of the objective function
GradF = sym(zeros(2,1));
GradF = [diff(f, x1); diff(f,x2)];

%Calculate the Hessian Matrix of the objective function
HF = sym(zeros(2,2));
HF = hessian(f,[x1,x2]);

%Solve GradF = 0 to find possible local minimizers/maximizers
X = solve([diff(f, x1) == 0, diff(f, x2) == 0], [x1,x2]);
sizeX = size(X.x1);

%Store the solutions of GradF = 0
solutions = sym(zeros(sizeX(1),2));
for i = 1:sizeX(1)
    solutions(i,1) = X.x1(i);
    solutions(i,2) = X.x2(i);  
end

%I made new symbolic variables to take the place of x1 and x2, because of
%an error during the compilation when I tried to use the same x1 x2 with the new
%assumptions (seen in assumeAlso() method). According to theory of the
%method of the sign of the quadratic form of the Hessian matrix, the
%variables must not be equal to 0, in order to do the first comparison
%(first if clause further down the code).
syms y1 y2;
assume(y1, 'real');
assumeAlso(y1 < 0 | y1 > 0);
assume(y2, 'real');
assumeAlso(y2 < 0 | y2 > 0);

%For every solution do the following..
for i = 1:sizeX(1)
    
    flag_min = false;
    flag_max = false;
    
    %Calculate HF_star on the solution of GradF=0 that is being
    %investigated
    HF_star = subs(HF,{x1,x2}, {solutions(i,1), solutions(i,2)});
    
    %the chol() method returns the sign of the Hessian matrix
    %(positive/negative definite) in the p variable contained in [~,p]
    [~,p] = chol(HF_star);
    
    %make calculations to find the quadratic form of the Hessian matrix at
    %the solution being investigated
    x_matrix = [x1; x2];

    HF_star_new = HF_star * x_matrix;
    
    x_matrix_T = x_matrix.';

    %the quadratic form
    quadratic_HF = x_matrix_T * HF_star_new;
    
    %replacing x1,x2 with y1,y2 for the reasons explained above
    Q_HF = subs(quadratic_HF,{x1,x2}, {y1,y2});
    %doing some more calculations to simplify the quadratic form
    simple_QHF = simplify(Q_HF);
    
    %if p == 0 means that the Hessian matrix is positive definite and so we
    %have a local min. It is the same result as if the quadratic form is always
    %positive for y1,y2 !=0. As I have explained though, the isAlways()
    %function for some reason didn't return the correct result some times so I
    %had to add p too, in the if clause to make sure I find the local
    %mins.
    %However the isAlways() function returned the correct result for the
    %local max so I didn't have to put the p variable there.
    %Check if the Hessian matrix is positive definite or negative definite(
    %through the sign of the quadratic form or from variable p)
    %or neither to make assumptions about the local min/max
    if p == 0 || isAlways(Q_HF > 0, 'Unknown', 'false')
        flag_min = true;
        fprintf('[%d, %d] is a local minimizer. \n', solutions(i,1), solutions(i,2));
    elseif isAlways(simple_QHF < 0, 'Unknown', 'false') == 1
        flag_max = true;
        fprintf('[%d, %d] is a local maximizer. \n', solutions(i,1), solutions(i,2));
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