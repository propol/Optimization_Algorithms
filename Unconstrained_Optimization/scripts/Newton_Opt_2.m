function [x_k] = Newton_Opt(max_iter,min_tol)


clear all;
close all;

% Initialization
max_iter=50;    % maximum number of iterations
min_tol=10^-6;  % tolerance
x_k1= zeros(2,1);
p_k= zeros(2,1);
alpha=1;

% Initial guess
x_k=[-1.2;1];

k=0; tol=10;

xvec1(k+1)=x_k(1,1);
xvec2(k+1)=x_k(2,1);

x=x_k(1,1); y=x_k(2,1);
f_k=F(x,y);
fvec(k+1)=f_k;

% Newton's algorithm
while (k<=max_iter) && (tol>=min_tol)
    x=x_k(1,1); y=x_k(2,1);
    p_k=-1*(HF(x,y)\GradF(x,y));
    x_k1=x_k+(alpha*p_k);
    f_k=F(x,y);
    df_k=norm(GradF(x,y),Inf);
    x=x_k1(1,1); y=x_k1(2,1);
    f_k1=F(x,y);
    df_k1=norm(GradF(x,y),Inf);
    tol=abs(df_k1);
    fprintf('%3.0f\t %7.4f\t %7.4f\t %7.4f\t %7.4f\n',k, x_k,f_k,df_k);
    x_k=x_k1;
    k=k+1;
    xvec1(k+1)=x_k(1,1);
    xvec2(k+1)=x_k(2,1);
    fvec(k+1)=f_k1;
end

figure;
plot(xvec1,xvec2,'bo-','LineWidth', 1.5)
set(gca, 'fontsize', 14, 'fontname', 'times');
xlabel('x_1')
ylabel('x_2')
grid;

figure;
plot3(xvec1,xvec2,fvec,'ro-','LineWidth', 2)
set(gca, 'fontsize', 14, 'fontname', 'times');
xlabel('x_1')
ylabel('x_2')
zlabel('f')
grid;

%The declaration of the objective function
function f= F(x,y)

f= 100*(y - x.^2)^2 + (1 - x)^2;

%The declaration of the Grad 
function g = GradF(x,y)

g= [400*x^3 - 400*x*y + 2*x - 2;
    200*(y - x^2)];

%The declaration of the Hessian Matrix
function h = HF(x,y)

h= [1200*x^2 - 400*y + 2, -400*x;
    -400*x, 200];