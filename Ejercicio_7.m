% TP 1 - Teoria de Control II
% Caso de estudio 2 - Item 7

% 1. Definimos parametros.
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

K = [0.01  0.001  50]; % Ganancia que definimos

% 3. Etapa de simulacion:
dt=1e-5;
t_final=100;
t=0:dt:t_final;
N=length(t);
x=zeros(3,N);
u=zeros(1,N);
theta_ref=zeros(1,N);
TL=zeros(1,N);

%4. Definimos la referencia y el torque de carga
for k=1:N
       if mod(t(k),50)<25
          theta_ref(k)=pi/2;
          TL(k)=10; %el punto en que se produce la carga
       else
          theta_ref(k)=-pi/2;
          TL(k)=0;
       end
end

%5. Etapa de simulacion
for k=1:N-1
       %ecuacion de control
       u(k) = -K*x(:,k) + 50*theta_ref(k); %definimos la ganancia de referencia
       %ecuacion para el sistema
       dx = A*x(:,k) + B*u(k) + E*TL(k);
       %Aplicacion de Euler
       x(:,k+1) = x(:,k) + dx*dt;
end
%6. Definimos las variables del sistema
ia=x(1,:);
w=x(2,:);
theta=x(3,:);

%7. Armamos los graficos
figure;

subplot(4,1,1)
plot(t,theta,'b','LineWidth',1.5)
hold on
plot(t,theta_ref,'r--')
title('Posicion angular \theta(t)')
legend('Salida','Referencia')
grid on

subplot(4,1,2)
plot(t,w,'LineWidth',1.5)
title('Velocidad angular')
grid on

subplot(4,1,3)
plot(t,ia,'LineWidth',1.5)
title('Corriente')
grid on

subplot(4,1,4)
plot(t,TL,'LineWidth',1.5)
title('Torque de carga')
xlabel('Tiempo [s]')
grid on
