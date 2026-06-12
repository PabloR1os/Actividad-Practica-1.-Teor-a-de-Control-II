% TP1 - Control II
% Caso de estudio 1 - Sistemas RLC
% Item 2 y 3

%% 1. Cargamos los datos del excel

datos = xlsread('Curvas_Medidas_RLC_2026.xls');

t  = datos(:,1);
I  = datos(:,2);
Vc = datos(:,3);
Ve = datos(:,4);

%% 2. Metodo de Chen

t0 = 0.1;      
t1 = 0.02;     
[~,i1] = min(abs(t-(t0+t1)));
[~,i2] = min(abs(t-(t0+2*t1)));
[~,i3] = min(abs(t-(t0+3*t1)));

y1 = Vc(i1);
y2 = Vc(i2);
y3 = Vc(i3);

K = 1;

k1 = y1/12 - 1;
k2 = y2/12 - 1;
k3 = y3/12 - 1;

be = 4*k1^3*k3 ...
    -3*k1^2*k2^2 ...
    -4*k2^3 ...
    +k3^2 ...
    +6*k1*k2*k3;

alpha1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alpha2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));

beta=(k1+alpha2)/(alpha1-alpha2);

T1=-t1/log(alpha1);
T2=-t1/log(alpha2);
T3=beta*(T1-T2)+T1;

fprintf('\n');
fprintf('T1 = %.6e s\n',T1);
fprintf('T2 = %.6e s\n',T2);
fprintf('T3 = %.6e s\n',T3);

%% 3. Se muestra la funcion de transferencia identificada

Gchen = tf(K*[T3 1],conv([T1 1],[T2 1]));

[num,den] = tfdata(Gchen,'v');

disp('Funcion de transferencia:')
Gchen

%% 4. Se muestran los parametros identificados mediante este método

LC = den(1);
RC = den(2);

C_chen = 220e-6;
L_chen = LC/C_chen;
R_chen = RC/C_chen;

fprintf('\n');
fprintf('R = %.4f Ohm\n',R_chen);
fprintf('L = %.6f H\n',L_chen);
fprintf('C = %.6e F\n',C_chen);

%% 5. Realizamos las validaciones que se piden

Vc_modelo = lsim(Gchen,Ve,t);

dt = t(2)-t(1);
I_modelo = C_chen*gradient(Vc_modelo,dt);

figure

subplot(4,1,1)
plot(t,Ve,'k','LineWidth',1.5)
grid on
xlabel('Tiempo [s]')
ylabel('V_e [V]')
title('Tensión de entrada')

subplot(4,1,2)
plot(t,Vc,'b','LineWidth',1.5)
hold on
plot(t,Vc_modelo,'r--','LineWidth',1.5)

grid on
xlabel('Tiempo [s]')
ylabel('V_C [V]')
title('Tensión en el capacitor')
legend('Medida','Modelo Chen')

subplot(4,1,3)
plot(t,I,'b','LineWidth',1.5)
hold on
plot(t,I_modelo,'r--','LineWidth',1.5)

grid on
xlabel('Tiempo [s]')
ylabel('I [A]')
title('Corriente')
legend('Medida','Modelo Chen')

subplot(4,1,4)

Vs = datos(:,5);

plot(t,Vs,'m','LineWidth',1.5)

grid on
xlabel('Tiempo [s]')
ylabel('V_s [V]')
title('Tensión de salida')