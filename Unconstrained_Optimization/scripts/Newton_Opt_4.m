function [x_k] = Newton_Opt(max_iter,min_tol)

clear all;
close all;

% Initialization
max_iter=100;    % maximum number of iterations
min_tol=10^-6;  % tolerance
x_k1= zeros(4,1);
p_k= zeros(4,1);
alpha=1;

% Initial guess
%x_k=[1.1;1.2;1.3;1.4]; %easy start for Wood's f
%x_k=[-3;-1;-3;-1]; %hard start for Wood's f
x_k=[-3; -1; 0; 1]; %for Powell's f
k=0; tol=10;

xvec1(k+1)=x_k(1,1);
xvec2(k+1)=x_k(2,1);
xvec3(k+1)=x_k(3,1);
xvec4(k+1)=x_k(4,1);

x=x_k(1,1); y=x_k(2,1); w=x_k(3,1); z=x_k(4,1);
f_k=F(x,y,w,z);
fvec(k+1)=f_k;

% Newton's algorithm
while (k<=max_iter) && (tol>=min_tol)
    %x=x_k(1,1); y=x_k(2,1); w=x_k(3,1); z=x_k(4,1);
    
    p_k=-1*(HF(x,y,w,z)\GF(x,y,w,z));
    
    x_k1=x_k+(alpha*p_k);
    f_k=F(x,y,w,z);
    df_k=norm(GF(x,y,w,z), Inf);
    x=x_k1(1,1); y=x_k1(2,1); w=x_k1(3,1); z=x_k1(4,1);
    f_k1=F(x,y,w,z);
    df_k1=norm(GF(x,y,w,z),Inf);
    tol=abs(df_k1);

    fprintf('%3.0f\t %7.4f\t %7.4f\t %7.4f\t %7.4f\n',k, x_k,f_k,df_k);
    x_k=x_k1;
    k=k+1;
    xvec1(k+1)=x_k(1,1);
    xvec2(k+1)=x_k(2,1);
    xvec3(k+1)=x_k(3,1);
    xvec4(k+1)=x_k(4,1);
    fvec(k+1)=f_k1;
end

function f= F(x,y,w,z)
%Wood's function
%f= 100*(y - x.^2)^2 + (1 - x)^2 + 90*(z - w.^2)^2 + (1 - w)^2 + 10.1*((y - 1)^2 + (z - 1)^2) + 19.8*(y-1)*(z-1);

%Powell's function
f= (x + 10*y)^2 + 5*(w - z)^2 + (y - 2*w)^4 + 10*(x - z)^4;

function g = GF(x,y,w,z)
%Wood's GradF
%g=[2*x - 400*x*(- x^2 + y) - 2
%   - 200*x^2 + (1101*y)/5 + (99*z)/5 - 40
%   2*w - 360*w*(- w^2 + z) - 2 
%   - 180*w^2 + (99*y)/5 + (1001*z)/5 - 40];

%Powell's GradF
g=[2*x + 20*y + 40*(x - z)^3
    20*x + 200*y - 4*(2*w - y)^3
    10*w - 10*z + 8*(2*w - y)^3
    10*z - 10*w - 40*(x - z)^3];

function h = HF(x,y,w,z)
%Wood's Hessian
%h=[1200*x^2 - 400*y + 2, -400*x, 0, 0
%    -400*x, 1101/5, 0, 99/5
%    0, 0, 1080*w^2 - 360*z + 2, -360*w
%    0, 99/5, -360*w, 1001/5];

%Powell's Hessian
h=[120*(x - z)^2 + 2, 20, 0, -120*(x - z)^2
    20, 12*(2*w - y)^2 + 200, -24*(2*w - y)^2, 0
    0, -24*(2*w - y)^2, 48*(2*w - y)^2 + 10, -10
    -120*(x - z)^2,  0,  -10, 120*(x - z)^2 + 10];