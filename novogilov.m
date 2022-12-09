clear
clc
close all 

k0 = 10;
k1 = 1;
k2 = 1;
k3 = 0.5;  
k4 = 0.3;
k5 = 1;
kf = 0.25;

T0 = 2;
T2 = 0.1;
T3 = 100;
T4 = 0.5;
Tf = 0.8;

t0 = 20;
t2 = 0.2;
t3 = 2.3;   

W0 = tf(k0, [T0 1]);
W1 = tf (k1);
W2 = tf ([(k2*t2) k2],[T2 1]);
W3_pi = tf ([(k3*T3) k3],[T3 0]);
W3_pid = tf ([(k3*t3*T3) (k3*T3) k3],[T3 0]);
W4 = tf (k4, [T4 1 0]);
W5 = tf (k5);
Wf = tf (kf, [Tf 1])

Wraz = W0 * W1 * W2 * W4 * W5;
Wzam = feedback(Wraz, 1);

%1 - Устойчивость по Гурвицу
matrix_gurvits = [1.25  1.6   0   0 
                  0.1   2.6   3   0 
                  0     1.25  1.6 0
                  0     0     2.6 3];
               
minor1 = 1.25;
minor2 = 1.25*2.6-1.6*0.1;
minor3 = minor2 * 1.6;
minor4 = minor3 * 3; % больше нуля значит устойчивая замкнутая система
% 
% bode(Wraz)
% figure
%  step(Wzam)


% 2 - ПФ по ошибке
Wmist = 1 / (1+Wraz); % предел по ошибке равен 0

kf = 0.25;
Tf = 0.8; % как определить ?
Wf = tf(kf, [Tf 1]);
Wvozm = Wf/(1+Wraz); % предел по ошибке равен 0


% 3 - ПИ и ПИД регуляторы

% ПИ регулятор
Wraz_pi_reg = W0 * W1 * W2 * W3_pi * W4 * W5;
Wzam_pi_reg = feedback(Wraz_pi_reg, 1);
Wmist_pi_reg = 1 / (1+Wraz_pi_reg);

% figure
% title('ПХ замкнутой системы с ПИ-регулятором');
% step(Wzam_pi_reg);
% figure
% title('ЛЧХ разомкнутой системы с ПИ-регулятором');
% bode(Wraz_pi_reg);


% ПИД регулятор
Wraz_pid_reg = W0 * W1 * W2 * W3_pid * W4 * W5
Wzam_pid_reg = feedback(Wraz_pid_reg, 1);

% figure
% title('ПХ замкнутой системы с ПИД-регулятором');
% step(Wzam_pid_reg);
% figure
% title('ЛЧХ разомкнутой системы с ПИД-регулятором');
% bode(Wraz_pid_reg);

figure
step(Wzam_pid_reg)


