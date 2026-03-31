>> % TP1 - Teoria de Control II
% Caso de Estudio 2
% Sistema de tres variables de estado 
% Item 4

%1. Parámetros a usar
Laa = 366e-6;
J = 5e-9;
Ra = 55.6;
B = 0;
Ki = 6.49e-3;
Km = 6.53e-3;
>> Va = 12; %Tension aplicada a la entrada
>> 
>> %2. Hacemos el calculo del "Torque limite"
>> ia_eq=Va/Ra;
>> TL_max = Ki*ia_eq;
>> fprintf('Torque limite TL_max= %.6e Nm\n', TL_max);

%3. Iniciamos la simulacion
dt = 1e-7;
t_final = 0.01;
t= 0:dt:t_final;
N=length(t);

TL_values = [0.9*TL_max, TL_max, 1.1*TL_max];

colores = ['b','r','g']; 

figure;

for j =1:length(TL_values)

TL = TL_values(j);
ia=zeros(1,N);
w=zeros(1,N);

%Aquí empezamos a aplicar Euler
for k=1:N-1
    dia = (-Ra/Laa)*ia(k) - (Km/Laa)*w(k) + (1/Laa)*Va;
    dw = (Ki/J)*ia(k) - (B/J)*w(k) - (1/J)*TL;
    
    ia(k+1) = ia(k) + dia*dt;
    w(k+1)  = w(k)  + dw*dt;
end

%4. Graficamos
subplot(2,1,1)
plot(t, ia, colores(j), 'LineWidth',1.5)
hold on
title('Corriente i_a(t)')
ylabel('Corriente [A]')
grid on

subplot(2,1,2)
plot(t, w, colores(j), 'LineWidth',1.5)
hold on
title('Velocidad angular \omega_r(t)')
ylabel('Velocidad [rad/s]')
xlabel('Tiempo [s]')
grid on

end

%5. Cuadro comparativo
subplot(2,1,1)
legend('0.9 TL_{max}','TL_{max}','1.1 TL_{max}')

subplot(2,1,2)
legend('0.9 TL_{max}','TL_{max}','1.1 TL_{max}')
