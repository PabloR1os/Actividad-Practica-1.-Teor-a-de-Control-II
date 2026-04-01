% TP1 - Teoria de Control II
% Caso de estudio 2 - Item 6

% 1. Definimos los parámetros de:
 %Motor:
 L=366e-6;
 J=5e-9;
 R=55.6;
 B=0;
 Ki=6.49e-3;
 Km=6.53e-3;

 %PID dados por el enunciado:
 Kp=0.1;
 Ki_pid=0.01;
 Kd=5;

% 2. Definimos las variables de la simulacion
dt=1e-5;
t_final=0.1;
t=0:dt:t_final;
N=length(t);

% 3. Introducimos las variables del sistema
ia=zeros(1,N);
w=zeros(1,N);
theta=zeros(1,N);
Va=zeros(1,N);
theta_ref=ones(1,N); %La variable de referencia dada de 1 rad
TL=zeros(1,N);
TL(t>0.04 & t<0.07) =0.002; %Perturbacion tomando como referencia las curvas de la grafica dada

% 4. Armamos el contorlador PID
e=zeros(1,N);
e_prev=0;
integral=0;
 
for k=1:N-1
       e(k)=theta_ref(k)-theta(k); %error

       integral=integral+e(k)*dt;
       derivada=(e(k)-e_prev)/dt;
       Va(k)=Kp*e(k)+Ki_pid*integral+Kd*derivada;
       e_prev=e(k);

       dia = (-R/L)*ia(k) - (Km/L)*w(k) + (1/L)*Va(k);
       dw  = (Ki/J)*ia(k) - (B/J)*w(k) - (1/J)*TL(k);
       dth = w(k);

       ia(k+1)=ia(k)+dia*dt;
       w(k+1)=w(k)+dw*dt;
       theta(k+1)=theta(k)+dth*dt;
end
% 5. Hacemos las gráficas
figure;

subplot(4,1,1)
plot(t,theta,'b','LineWidth',1.5)
hold on
plot(t,theta_ref,'r--')
title('Posicion \theta(t)')
legend('Salida','Referencia')
grid on

subplot(4,1,2)
plot(t,w,'LineWidth',1.5)
title('Velocidad angular \omega(t)')
grid on

subplot(4,1,3)
plot(t,ia,'LineWidth',1.5)
title('Corriente i_a(t)')
grid on

subplot(4,1,4)
plot(t,Va,'LineWidth',1.5)
title('Control V_a(t)')
xlabel('Tiempo [s]')
grid on
