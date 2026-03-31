% TP1 - Teoria de Control II
% Caso de Estudio 2 - Item 5
 
% 1. Cargamos los datos del Excel
datos = xlsread('Curvas_Medidas_Motor_2026.xls');
t=datos(:,1); %Tiempo
w=datos(:,2); %Velocidad angular
ia=datos(:,3); %corriente
Va=datos(:,4); %Tension de entrada
TL=datos(:,5); %Torque de carga
dt=t(2)-t(1);

% 2. Graficamos
figure;
subplot(4,1,1)
plot(t, w, 'b', 'LineWidth',1.2)
title('Velocidad angular \omega_r(t)')
ylabel('\omega [rad/s]')
grid on

subplot(4,1,2)
plot(t, ia, 'r', 'LineWidth',1.2)
title('Corriente i_a(t)')
ylabel('i_a [A]')
grid on

subplot(4,1,3)
plot(t, Va, 'k', 'LineWidth',1.2)
title('Tension de entrada V_a(t)')
ylabel('V_a [V]')
grid on

subplot(4,1,4)
plot(t, TL, 'g', 'LineWidth',1.2)
title('Torque de carga T_L(t)')
ylabel('T_L [Nm]')
xlabel('Tiempo [s]')
grid on

%3. Hacemos las derivadas correspondientes
dia=diff(ia)/dt;
dw=diff(w)/dt;

ia_id=ia(1:end-1);
w_id=w(1:end-1);
Va_id=Va(1:end-1);
TL_id=TL(1:end-1);

% 4. Identificacion de la ecuacion electrica
Phi1=[ia_id w_id Va_id];
theta1 = Phi1\dia;
a1=theta1(1);
a2=theta1(2);
a3=theta1(3);

%5. Identificacion de la ecuacion mecanica
Phi2=[ia_id w_id TL_id];
theta2=Phi2\dw;
b1=theta2(1);
b2=theta2(2);
b3=theta2(3);

% 6. Recueperamos parametros fisicos
L  = 1/a3;
R  = -a1 * L;
Km = -a2 * L;

J  = -1/b3;
Ki = b1 * J;
B  = -b2 * J;

fprintf('\n===== PARAMETROS ESTIMADOS =====\n');
fprintf('R  = %.4f Ohm\n', R);
fprintf('L  = %.6e H\n', L);
fprintf('Km = %.6e\n', Km);
fprintf('Ki = %.6e\n', Ki);
fprintf('J  = %.6e\n', J);
fprintf('B  = %.6e\n', B);


%7. Ahora realizamos la validacion del modelo
ia_sim = zeros(size(t));
w_sim  = zeros(size(t));

for k = 1:length(t)-1
    
    dia_sim = (-R/L)*ia_sim(k) - (Km/L)*w_sim(k) + (1/L)*Va(k);
    
    dw_sim  = (Ki/J)*ia_sim(k) - (B/J)*w_sim(k) - (1/J)*TL(k);
    
    ia_sim(k+1) = ia_sim(k) + dia_sim*dt;
    w_sim(k+1)  = w_sim(k)  + dw_sim*dt;
    
end
% 8. Establecemos una comparacion entre el modelo desarrollado y el real
figure;

subplot(2,1,1)
plot(t, ia, 'b', 'LineWidth',1.2)
hold on
plot(t, ia_sim, 'r--', 'LineWidth',1.2)
title('Validacion de corriente i_a(t)')
legend('Real','Modelo')
grid on

subplot(2,1,2)
plot(t, w, 'b', 'LineWidth',1.2)
hold on
plot(t, w_sim, 'r--', 'LineWidth',1.2)
title('Validacion de velocidad \omega_r(t)')
legend('Real','Modelo')
xlabel('Tiempo [s]')
grid on