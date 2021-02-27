%{
Author : Maharshi Gurjar
Elec 4700 Assignment 2 -  Finite Difference Method 
Part 2
%}
%%
clc; close all; clear;
set(0, 'DefaultFigureWindowStyle', 'docked')
nx = 150;
ny = 100;
G = sparse((nx *ny), (nx*ny));
V = zeros(nx *ny);
Sigma_Outside_Box = 1; 
Sigma_In_Box = 10e-2;
%% Create boxes
Lower_Box = [(nx* 2/5), (nx* 3/5), ny , (ny *4/5)]; 
Top_Box = [(nx* 2/5), (nx* 3/5),0, (ny *1/5)];
%% Generate and plot the Conductivity map
Cond_map = ones(nx,ny);
for i = 1:nx
    for j = 1:ny
        if (i < Lower_Box(2) && i >Lower_Box(1) && ((j < Top_Box(4)) || (j > Lower_Box(4))))
            Cond_map(i,j) = Sigma_In_Box;
        end
    end
end
figure('name','Conductivity Map');
surf(Cond_map);
xlabel('Y-Position')
ylabel('X-Position')
axis tight
grid on;
view(2)
title('Conductivity ($\sigma$) Map','interpreter','latex');
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2ConductivityMap.png'),'png')
%% Generate G and V matricies
for i = 1:nx
    for j = 1: ny
        n = j+ (i-1)*ny;
        if (i == 1)
            G(n,:) = 0;
            G(n,n) = 1;
            V(n) = 1; 
        elseif (i == nx)
            G(n,:) = 0;
            G(n,n) = 1;
        elseif ((i > 1) && (i < nx) && (j==1))
            G(n, n+ny) = Cond_map(i+1,j);
            G(n,n) = -(Cond_map(i,j+1)+Cond_map(i-1,j)+Cond_map(i+1,j));
            G(n,n-ny) = Cond_map(i-1,j);
            G(n,n-1) = Cond_map(i,j+1);
        elseif ((j == ny) && (i < nx) && (i >1))
            G(n, n+ny) = Cond_map(i+1,j);
            G(n,n) = -(Cond_map(i-1,j)+Cond_map(i+1,j)+Cond_map(i,j-1));
            G(n,n-ny) = Cond_map(i-1,j);
            G(n,n+1) = Cond_map(i,j-1);
        else
            G(n, n+ny) = Cond_map(i+1,j);
            G(n,n) = -(Cond_map(i-1,j)+Cond_map(i+1,j)+Cond_map(i,j+1)+Cond_map(i,j-1));
            G(n,n-ny) = Cond_map(i-1,j);
            G(n,n-1) = Cond_map(i,j+1);
            G(n,n+1) = Cond_map(i,j-1);
        end
    end
end
%%
solution1 = G\V;
Voltage = zeros(nx,ny);
for i =1:nx
    for j = 1:ny
        Voltage(i,j) = solution1(j+(i-1) * ny);
    end
end
%%
%plot the voltage map
figure('name','Voltage map (Including bottle neck)');
%3D Plot
subplot(2,1,1)
surf(Voltage);
view(-92.9556,10.2554)
xlabel('X-Position')
ylabel('Y-Position')
zlabel('V (Voltage)')
axis tight
grid on;
cb=colorbar;
cb.Label.String = 'Voltage';
cb.Location = 'eastoutside';
%2D plot
subplot(2,1,2)
surf(Voltage);
axis tight
grid on;
view(2)
xlabel('X-Position')
ylabel('Y-Position')
%Title and colorbar
sgtitle('Voltage Map with Bottleneck');
cb=colorbar;
cb.Label.String = 'Voltage';
cb.Location = 'eastoutside';
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2VoltageMapBottleNeck.png'),'png')
%%
%Plot the Electric field using maxwells equation 
% Using the classical E = -GradV equation
[E_x,E_y] = gradient(Voltage);
% Applying the '-' 
E_x = -E_x;
E_y = -E_y;
figure('name','Electric Field')
quiver(E_x',E_y');
axis tight
xlabel('X-Position')
ylabel('Y-Position')
title('Quiver Plot of Electric Field')
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2QuiverPlotEf.png'),'png')
%%
%Plot the current density
% Using Maxwells equation for the current 
% J = sigma E
Jx = E_x .*Cond_map;
Jy = E_y .*Cond_map;
figure('name','Current Density')
quiver(Jx,Jy);
axis tight
xlabel('Y-Position')
ylabel('X-Position')
title('Quiver Plot of Current Density (J)')
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2CCurrentDensity.png'),'png')
%%
%Plot the Magnitude of the current density
% Simply getting the magnitude of the current density
magnitude_current_density = sqrt(((Jx .^2) + (Jy .^2)));
% Plot the magnitude of the current density
figure('name','|Current Density|')
%3D Plot
subplot(2,1,1)
surf(magnitude_current_density)
axis tight
grid on;
xlabel('X-Position')
ylabel('Y-Position')
zlabel('V/m (Voltage/meter)')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = '|J|';
%2D Plot
subplot(2,1,2)
surf(magnitude_current_density)
axis tight
view(2)
grid on;
xlabel('Y-Position')
ylabel('X-Position')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = '|J|';
sgtitle('Magnitude of Current Density')
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2MagCurrentDensity.png'),'png')
%%
%Plot the Electric field in X
figure('name','Electric Field in X')
%3D Plot
subplot(2,1,1)
surf(E_x)
axis tight
grid on;
xlabel('Y-Position')
ylabel('X-Position')
zlabel('V/m (Voltage/meter)')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = 'E-Field';
%2D Plot
subplot(2,1,2)
surf(E_x)
axis tight
grid on;
view(2)
sgtitle('Electric Field along the X direction')
xlabel('Y-Position')
ylabel('X-Position')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = 'E-Field';
sgtitle('Electric Field')
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2EfieldX.png'),'png')
%%
%plot the Electric Field in Y
figure('name','Electric Field in Y')
%3D Plot
subplot(2,1,1)
surf(E_y)
axis tight
grid on;
xlabel('Y-Position')
ylabel('X-Position')
zlabel('V/m (Voltage/meter)')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = 'E-Field';
%2D Plot
subplot(2,1,2)
surf(E_y)
axis tight
grid on;
view(2)
xlabel('X-Position')
ylabel('Y-Position')
sgtitle('Electric Field along the Y direction')
cb=colorbar;
cb.Location = 'eastoutside';
cb.Label.String = 'E-Field';
sgtitle('Electric Field')
%saveas(gcf,fullfile('D:\School Work\ELEC 4700\My 4700 Code\Assignment 2\Figures','Part2EfieldY.png'),'png')