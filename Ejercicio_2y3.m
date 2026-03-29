% TP1 - Control II
% Caso de estudio 1 - Sistemas RLC
% Item 2 y 3

% 1. Cargamos los datos del excel
datos = xlsread('Curvas_Medidas_RLC_2026.xls');
t = datos(:,1); %Tiempo
I = datos(:,2); %Corriente
Vc = datos(:,3); %Tension capacitor
u = datos(:,4); %Tension de entrada

dt = t(2) - t(1); %Aqui definimos el tiempo de muestreo

% 2. Deteccion el inicio del escalon de forma automatica

du = diff(u);
idx0 = find(abs(du) > 5,1);
t0 = t(idx0);

% 3. Definimos los puntos t1, 2t1, 3t1.
t1 = t0 + 0.002; %es un tiempo muy pequeño despues de la entrada escalon
[~, i1] = min(abs(t - t1));
[~, i2] = min(abs(t-(t0+2*(t1-t0))));
[~, i3] = min(abs(t-(t0+3*(t1-t0))));

y1=Vc(i1);
y2=Vc(i2);
y3=Vc(i3);

% 4. Realizamos la normalizacion mediante el metodo explicado por "CHEN"
K = max(Vc);

k1 = y1/K - 1;
k2 = y2/K - 1;
k3 = y3/K - 1;

% 5. Hacemos el calculo de los parametro (Metodo dde Chen)
be = 4*k1^3*k3 - 3*k1^2*k2^2 - 4*k2^3 + k3^2 + 6*k1*k2*k3;
alfa1 = (k1*k2 + k3 - sqrt(be)) / (2*(k1^2 + k2));
alfa2 = (k1*k2 + k3 + sqrt(be)) / (2*(k1^2 + k2));
alfa1 = (k1*k2 + k3 - sqrt(be)) / (2*(k1^2 + k2));
alfa2 = (k1*k2 + k3 + sqrt(be)) / (2*(k1^2 + k2));
T1 = -(t1 - t0)/log(alfa1);
T2 = -(t1 - t0)/log(alfa2);
fprintf('T1 = %.6f s\n', T1);
T1 = 0.005103 s
fprintf('T2 = %.6f s\n', T2);
T2 = 0.043209 s
% 6. Definimos la FT

num = [1];
den = conv([T1 1],[T2 1]);
sys = tf(num, den);

% 7. Aqui hacemos la simulacion del sistema
[y_model, t_model] = lsim(sys,u,t);

%8. Estimamos la capacitancia C a partir de la corriente
dVc_dt = diff(y_model)/dt;
t_der = t(1:end-1);
C = max(I)/max(dVc_dt);
fprintf('Capacitancia estimada: %.6e F\n',C);
Capacitancia estimada: 2.197493e-04 F

% 9. Hacemos una estimacion de la corriente
i_model = C*dVc_dt;

% 10. Calculo de R y L

den_norm = den/den(2);
RC = den_norm(2);
LC = den_norm(1);
R=RC/C;
L=LC/C;
fprintf('\nParametros estimados:\n');
fprintf('R = %.2f Ohm\n', R);
fprintf('L = %.6f H\n', L);

Parametros estimados:
R = 4550.64 Ohm
L = 20.770885 H
% 11. Validacion (desde 0.05s)
idx_val = t_der >=0.05;
figure;

subplot(3,1,1)
plot(t_der(idx_val), I(idx_val), 'b', 'LineWidth', 1.2)
hold on
plot(t_der(idx_val), i_model(idx_val), 'r--', 'LineWidth', 1.2)
legend('Corriente real','Corriente modelo')
title('Validacion de corriente')
grid on

subplot(3,1,2)
plot(t, Vc, 'b')
hold on
plot(t_model, y_model, 'r--')
legend('Vc real','Vc modelo')
title('Tension en el capacitor')
grid on

subplot(3,1,3)
plot(t, u, 'k')
title('Entrada u(t)')
grid on