% TP 1 - Teoria de Control II
% Caso de estudio 2 - Item 8

% 1. Definicion de los parámetros a usar
L = 366e-6;
J = 5e-9;
R = 55.6;
B = 0;
Ki = 6.49e-3;
Km = 6.53e-3;
%2. Armamos las matrices.

A = [ -R/L   -Km/L   0; 
       Ki/J   -B/J   0;
       0       1     0 ]; % Matriz A representa la dinamica del sistema

B = [1/L; 0; 0]; % Representa la entrada de control

E = [0; -1/J; 0]; % torque de carga / perturbacion

C = [0 0 1]; % representa la salida que es theta

K = [0.01  0.001  50];

O = [1000; 10000; 500]; %Este es el observador y se puede ajustar como se desee

% 2. Establecemos la etapa de simulación.
dt=1e-5;
t_final=100;
t=0:dt:t_final;
N=length(t);
x=zeros(3,N); %Esta parte corresponde a los estados reales
x_estim = zeros(3,N); %Estos son los estados que estimamos
u=zeros(1,N);

% 3. Definimos la referencia y el torque con el que trabajamos
ref=zeros(1,N);
for k=1:N
    if mod(floor(t(k)/25),2)==0
        ref(k)=pi/2;
    else
        ref(k)=-pi/2;
    end
end

TL=zeros(1,N);
for k=1:N
    if ref(k)>0
        TL(k)=10;
    end
end

%4. Simulamos y graáficamos los resultados obtenidos
for k=1:N-1
    y=C*x(:,k); %corresponde a la salida real del sistema
    y_estim=C*x_estim(:,k); %corresponde a la salida que estimamos
    u(k)=-K*x_estim(:,k)+ref(k); %control del sistema con los estados estimados
    
    x_real=A*x(:,k)+B*u(k)+E*TL(k);
    x(:,k+1)=x(:,k)+x_real*dt; %estos parametros son del sistema real
    
    x_estim_obs=A*x_estim(:,k)+B*u(k)+E*TL(k)+O*(y-y_estim);
    x_estim(:,k+1)=x_estim(:,k)+x_estim_obs*dt;
end

figure;

subplot(3,1,1)
plot(t, x(3,:), 'b', t, x_estim(3,:), 'r--')
title('Posición \theta(t)')
legend('Real','Estimado')
grid on

subplot(3,1,2)
plot(t, x(2,:), 'b', t, x_estim(2,:), 'r--')
title('Velocidad \omega(t)')
legend('Real','Estimado')
grid on

subplot(3,1,3)
plot(t, x(1,:), 'b', t, x_estim(1,:), 'r--')
title('Corriente i_a(t)')
legend('Real','Estimado')
grid on
