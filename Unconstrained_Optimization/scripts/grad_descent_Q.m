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

% step size 

%alpha=0.09; %for the second objective f of the project1
alpha = 0.05; %for the third quadratic f of the project1


% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf; x = x0; niter = 0; dx = inf;

% define the objective function:
%Q = zeros(2,2); %Second objective function of project 1
%Q = [20, 5
%    5, 2];
%b = zeros(2,1);
%b = [14
%    6];
%c = 10;

Q = zeros(2,2); %Third objective function of project 1
Q = [20, 5
    5, 16];
b = zeros(2,1);
b = [14
    6];
c = 10;

syms x1 x2;
x_k = [x1
       x2];
f_fig=1/2*x_k'*Q*x_k - b'*x_k +c;
% plot objective function contours for visualization:
figure(1); clf; ezcontour(f_fig,[-5 5 -5 5],25); axis equal; hold on

x = x0;
% gradient descent algorithm:
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = Q*x - b;
    gnorm = norm(g);
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
    f=1/2*xnew'*Q*xnew - b'*xnew +c;
    fprintf('%3.0f\t %7.4f\t %7.4f\t %7.4f\t %7.4f\n',niter, xnew,f,gnorm);
    x = xnew;
    
end
xopt = x;
fopt = f;
niter = niter - 1;
