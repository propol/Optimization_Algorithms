function [xopt,fopt,niter,gnorm,dx] = grad_descent(varargin)

if nargin==0
    % define starting point
    x0 = [0 -1]';
elseif nargin==1
    % if a single input argument is provided, it is a user-defined starting
    % point.
    x0 = varargin{1};
else
    error('Incorrect number of input arguments.')
end

% termination tolerance
tol = 1e-5;

% maximum number of allowed iterations
maxiter = 1000;

% minimum allowed perturbation
dxmin = 1e-6;



% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf; x = x0; niter = 0; dx = inf;

% define the objective function:
% Second objective function of project 1 (exercise 3):
%Q = zeros(2,2);
%Q = [20, 5
%    5, 2];
%b = zeros(2,1);
%b = [14
%    6];
%c = 10;

% Third objective function of project 1 (exercise 3):
Q = zeros(2,2);
Q = [20, 5
    5, 16];
b = zeros(2,1);
b = [14
    6];
c = 10;

% The first objective function given in project 1 (exercise 3):
% f = 5*x1.^2 + x2.^2 + 4*x1.*x2 - 14*x1 - 6*x2 + 20
% can be rewritten in a quadratic form with the following matrices:
%Q = zeros(2,2);
%Q = [10, 4
%    4, 2];
%b = zeros(2,1);
%b = [14
%    6];
%c = 20;


syms x1 x2;
x_k = [x1
       x2];
f_fig=1/2*x_k'*Q*x_k - b'*x_k +c; %the quadratic form of f
% plot objective function contours for visualization:
figure(1); clf; ezcontour(f_fig,[-5 5 -5 5],25); axis equal; hold on

x = x0;
% gradient descent algorithm:
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = Q*x - b;
    gnorm = norm(g);
    % new step:
    alpha = (norm(g)^2) / (g'*Q*g);
    % take step:
    xnew = x - alpha*g;
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end
    % plot current point
    plot([x(1) xnew(1)],[x(2) xnew(2)],'ko-')
    refresh
    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    f=1/2*xnew'*Q*xnew - b'*xnew +c; %the quadratic form of f
    fprintf('%3.0f\t %7.4f\t %7.4f\t %7.4f\t %7.4f\n',niter, xnew,f,gnorm);
    x = xnew;
    
end
xopt = x;
fopt = f;
niter = niter - 1;
