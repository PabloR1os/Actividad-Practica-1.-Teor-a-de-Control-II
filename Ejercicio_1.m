%  TP1 - Control II
%  Caso de estudio 1 - Sistema RLC

%1. Definimos parametros del circuito

R=2200;
L=0.5;
C=10e-6;

%2. Armamos las matrices

A = [-R/L, -1/L; 1/C, 0];
b = [1/L; 0];
c = [R, 0];
d = 0;
sys = ss (A,b,c,d);

%3. Definimos el tiempo de simulacion

t = 0:1e-5:0.1; %Definimos 100ms, tiempo suficiente para ver varias conmutaciones.

%4. Definimos la enrada onda cuadrada

u = 12*square(2*pi*50*t);

%5. Hacemos la simulacion

[y,t,x] = lsim(sys,u,t);

%6. Definimos las variables que nos interesa analizar

i=x(:,1); %Corriente en el circuito
Vc=x(:,2); %Tension en el capacitor
Vo=y; %Tension de salida

%7. Hacemos las graficas

figure;

subplot(4,1,1)
plot(t, u, 'k')
title('Entrada u(t)')
ylabel('Voltaje [V]')
grid on

subplot(4,1,2)
plot(t, Vc, 'b')
title('Tensión en el capacitor Vc(t)')
ylabel('Voltaje [V]')
grid on

subplot(4,1,3)
plot(t, i, 'r')
title('Corriente i(t)')
ylabel('Corriente [A]')
grid on

subplot(4,1,4)
plot(t, Vo, 'm')
title('Salida Vo(t) = R*i(t)')
ylabel('Voltaje [V]')
xlabel('Tiempo [s]')
grid on
