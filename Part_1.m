%{
Author : Maharshi Gurjar
Elec 4700 Assignment 2 -  Finite Difference Method 
Part 1  
%}
%%
%Part 1 - A
clc; close all; clear;
set(0, 'DefaultFigureWindowStyle', 'docked')

%Initalize size of mesh
nx = 150;
ny = 100;
%Initalize G and V matrix
G = sparse(nx*ny,nx*ny);
V = zeros(nx*ny,1);
V0=1;
%The G matrix is filled in using a loop using the FD method
for i = 1:nx
    for j = 1:ny
        n = j + (i-1)*ny;
        if i == 1 
            G(n,:) = 0;
            G(n,n) = 1;
            V(n) = 1;
        elseif i == nx 
            G(n,:) = 0;
            G(n,n) = 1;
            V(n) = 0;
        elseif j == 1 
            G(n, :) = 0;
            G(n, n) = -3;
            G(n, n+1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
        elseif j == ny
            G(n, n) = -3;
            G(n, n-1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
        else
            G(n, n) = -4;
            G(n, n+1) = 1;
            G(n, n-1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
        end
    end 
end

V = G\V;
Soln = zeros(nx,ny,1);
for i=1:nx
    for j=1:ny
        Soln(i,j) = V(j+(i-1)*ny);
    end
end
figure('Name','1D FD Solution')
surf(Soln,'edgecolor','none')
title('Voltage plot using FD - 1D solution')
xlabel('Y-Position')
ylabel('X-Position')
zlabel('V (Voltage)')
axis tight
cb=colorbar;
cb.Label.String = 'Voltage';
cb.Location = 'eastoutside';
view(-120,35)
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part11DPlot.png'),'png')
%%
%Part 1-B
%Initalize size of mesh
%Initalize G and V matrix
G2 = sparse(nx*ny,nx*ny);
V2 = zeros(nx*ny,1);

%The G matrix is filled in using a loop using the FD method
for x = 1:nx
    for y = 1:ny
        n = y + (x-1)*ny;
    
        if x == 1
            G2(n,:) = 0;
            G2(n, n) = 1;
            V2(n) = 1;
        elseif x == nx
            G2(n,:) = 0;
            G2(n, n) = 1;
            V2(n) = 1;
        elseif y == 1
            G2(n,:) = 0;
            G2(n, n) = 1;
        elseif y == ny
            G2(n,:) = 0;
            G2(n, n) = 1;
        else
            G2(n, n) = -4;
            G2(n, n+1) = 1;
            G2(n, n-1) = 1;
            G2(n, n+ny) = 1;
            G2(n, n-ny) = 1;
        end
    end
end

V2 = G2\V2;
Soln2 = zeros(nx,ny,1);
for i=1:nx
    for j=1:ny
        Soln2(i,j) = V2(j+(i-1)*ny);
    end
end
figure('Name','2D FD Solution')
surf(Soln2,'edgecolor','none')
title('Voltage plot using FD - 2D solution')
xlabel('X-Position')
ylabel('Y-Position')
zlabel('V (Voltage)')
cb=colorbar;
cb.Label.String = 'Voltage';
cb.Location = 'eastoutside';
axis tight
view(-120,35)
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part12DPlot.png'),'png')
%%
%Analytical solution
x = linspace(-nx/2,nx/2,nx);
y = linspace(0,ny,ny);
[i,j] = meshgrid(x,y);
AnalyticalSoln = sparse(ny,nx);
for n = 1:2:300
   AnalyticalSoln = AnalyticalSoln + cosh(n*pi*i/ny).*sin(n*pi*j/ny)./(n*cosh(n*pi*nx/2/ny));
   figure(3)
   surf(x,y,(4/pi)*AnalyticalSoln)
   title('Voltage plot using FD - 2D solution')
   xlabel('X-Position')
   ylabel('Y-Position')
   zlabel('V (Voltage)')
   cb=colorbar;
   cb.Label.String = 'Voltage';
   cb.Location = 'eastoutside';
   axis tight
   view(3)
   pause(0.1)
end
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part12DAnalyticalPlot.png'),'png')