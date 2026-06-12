% TP1 - Teoria de Control II
% Caso de estudio 2 - Sistema de tres variables de estado
% Item [5] y deducción de parámetros físicos mediante doble Chen

%% 1. Cargamos los datos desde el excel.
datos = xlsread('Curvas_Medidas_Motor_2026.xls');

t  = datos(:,1);
w  = datos(:,2);
ia = datos(:,3);
Va = datos(:,4);
TL = datos(:,5);

%% 2. Sincronización y puntos para el algoritmo de Chen cruzado
t0 = find(Va > 0, 1);
% Se busca el tiempo de subida de la velocidad y se divide para definir el paso
x = fix(find(w == max(w), 1, 'first') / 5);

t1 = t0 + x;
t2 = t0 + x * 2;
t3 = t0 + x * 3;

StepAmplitude = max(Va); % Amplitud del escalón de tensión (10V)
M = [w, ia];            % Matriz con ambas señales para identificar en paralelo

% Inicialización de vectores para almacenar ganancias y constantes
K = zeros(1, 2);
T1 = zeros(1, 2);
T2 = zeros(1, 2);
T3 = zeros(1, 2);

%% 3. Identificación mediante el método de CHEN (Doble canal)
for k = 1:2
    K(k) = M(end, k) / StepAmplitude;
    
    k1 = (1 / StepAmplitude) * M(t1, k) / K(k) - 1;
    k2 = (1 / StepAmplitude) * M(t2, k) / K(k) - 1;
    k3 = (1 / StepAmplitude) * M(t3, k) / K(k) - 1;
    
    be = 4 * k1^3 * k3 - 3 * k1^2 * k2^2 - 4 * k2^3 + k3^2 + 6 * k1 * k2 * k3;
    
    alpha1 = (k1 * k2 + k3 - sqrt(be)) / (2 * (k1^2 + k2));
    alpha2 = (k1 * k2 + k3 + sqrt(be)) / (2 * (k1^2 + k2));
    
    beta = (k1 + alpha2) / (alpha1 - alpha2);
    
    T1(k) = -(t(t1) - t(t0)) / log(alpha1);
    T2(k) = -(t(t1) - t(t0)) / log(alpha2);
    T3(k) = beta * (T1(k) - T2(k)) + T1(k);
end

% Funciones de transferencia identificadas ante Va
G_w  = tf(K(1) * [T3(1), 1], conv([T1(1), 1], [T2(1), 1]));
G_ia = tf(K(2) * [T3(2), 1], conv([T1(2), 1], [T2(2), 1]));

% Validación con lsim (Simulación temporal)
w_modelo  = lsim(G_w, Va, t);
ia_modelo = lsim(G_ia, Va, t);

%% 4. Ganancia estática ante la perturbación de Torque (T_L)
inicio_TL = find(TL > 0, 1);
final_TL  = find(TL > 0, 1, 'last');
k_tl = (w(inicio_TL) - w(final_TL)) / max(TL);

%% 5. DEDUCCIÓN DE PARÁMETROS FÍSICOS DEL MOTOR (Fórmulas de la cátedra)
Ra_calc  = (-T1(1) * T2(1) + T1(1) * T3(2) + T2(1) * T3(2)) / (K(2) * T3(2)^2);
Laa_calc = (T1(1) * T2(1)) / (K(2) * T3(2));
Km_calc  = (T1(1) * T2(1) + T3(2)^2 - T3(2) * (T1(1) + T2(1))) / (K(1) * T3(2)^2);
Ki_calc  = (K(1) * Ra_calc) / k_tl;
J_calc   = (K(2) * Ki_calc * T3(2)) / K(1);
B_calc   = (K(2) * Ki_calc) / K(1);

%% 6. RESULTADOS EN CONSOLA
fprintf('\n==================================================\n');
fprintf('RESULTADOS DE PARAMETROS IDENTIFICADOS (CHEN DOBLE)\n');
fprintf('==================================================\n');
fprintf('  Ra  = %.16f [Ohm]\n', Ra_calc);
fprintf('  Laa = %.16f [H]\n', Laa_calc);
fprintf('  Ki  = %.16f [N*m/A]\n', Ki_calc);
fprintf('  Km  = %.16f [V*s/rad]\n', Km_calc);
fprintf('  J   = %.16f [Kg*m^2]\n', J_calc);
fprintf('  B   = %.16f [N*m*s/rad]\n', B_calc);
fprintf('==================================================\n');

%% 7. Graficamos los datos medidos y las validaciones (Metiendo tus subplots)
figure('Name', 'Validacion de Modelos Identificados', 'NumberTitle', 'off')

subplot(4,1,1)
plot(t, Va, 'LineWidth', 1.5)
grid on
title('Tension de Armadura')
ylabel('V_a [V]')

subplot(4,1,2)
plot(t, w, 'b', 'LineWidth', 1.5); hold on;
plot(t, w_modelo, 'r--', 'LineWidth', 1.5);
plot(t(t1), w(t1), 'ob', t(t2), w(t2), 'ob', t(t3), w(t3), 'ob', 'LineWidth', 2);
grid on
title('Velocidad Angular (Medida vs Modelo Chen)')
ylabel('\omega [rad/s]')
legend('Medida', 'Modelo', 'Puntos Chen')

subplot(4,1,3)
plot(t, TL, 'LineWidth', 1.5)
grid on
title('Torque de Carga')
ylabel('T_L [Nm]')
xlabel('Tiempo [s]')

subplot(4,1,4)
plot(t, ia, 'g', 'LineWidth', 1.5); hold on;
plot(t, ia_modelo, 'r--', 'LineWidth', 1.5);
plot(t(t1), ia(t1), 'ob', t(t2), ia(t2), 'ob', t(t3), ia(t3), 'ob', 'LineWidth', 2);
grid on
title('Corriente de Armadura (Medida vs Modelo Chen)')
ylabel('i_a [A]')
xlabel('Tiempo [s]')
legend('Medida', 'Modelo', 'Puntos Chen')