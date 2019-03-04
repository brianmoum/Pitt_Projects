clc, clear

% Time span
t = 1;
T = 30;

%Defining Sets of status numbers
S = zeros(1,T);
I = zeros(1,T);
R = zeros(1,T);

% Initial values
S(1) = 0.77;
I(1) = 0.03;
R(1) = 0.20;

%Proportionality Constants
gamma = 0.1; %Recovery rate
mu = 0.250; %Birth/Death rate
alpha = 0.2; %Loss of Vaccine efficacy 
eta = 0.5; %Vaccination rate
Ra = ((gamma + mu)*(alpha + mu + eta))/(alpha + mu);
disp(Ra);  
beta = 0.4594; %Infection rate

%Model

while t < T

    S(t+1) = S(t) - beta*S(t)*I(t) + mu*(S(t)+I(t)+R(t)) - mu*S(t) + alpha*R(t) - eta*S(t);

    I(t+1) = I(t) + beta*S(t)*I(t) - gamma*I(t) - mu*I(t);

    R(t+1) = R(t) + gamma*I(t) + eta*S(t) - mu*R(t) - alpha*R(t);
    
    t = t + 1; 
end
disp(I(T));
time = linspace(1,T,T);
figure
hold on
plot(time,S,'y',time,I,'r',time,R,'g','LineWidth',2);
title('Discrete SIR Model with Birth/Death and Vaccination');
xlabel('Time');
ylabel('Proportion of Subjects');
legend('Susceptible','Infected','Recovered');
hold off
