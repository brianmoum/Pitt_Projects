clc, clear

num_subs = 100; %Initial Population
percent_immune = 0.20; %Percentage of initial population in R
num_imm = round(num_subs * percent_immune); %Round Number in R
init_infected = 3; %Initial subjects infected
gamma = 0.08; %Rate at which subjects go from I to R
beta = 0.4; %Decay coeffiecint for infection. P(I) = exp(-beta*dist)
alpha = 0.2; %Loss of efficacy
infection_radius = 10; %Max Distance infection is possible
bdr = 4; %number of subjects that are added and removed per step (const. pop)
vaccination_rate = 0.50; %Proportion of subjects at age 6mo given vaccine
end_age = 15; %Age at which subjects are no longer studied

for r = 1:num_subs
    a = round(5*rand);
    rx = 100*rand;
    ry = 100*rand;
    subs(r) = subject(rx,ry,'Si',a);
end
for in = length(subs):-1:(length(subs)- (init_infected-1))
    subs(in).status = 'I';
end
for imm = 1:num_imm
    subs(imm).status = 'R';
end

t = 1;
T = 30;
So = num_subs - num_imm - init_infected;
Io = init_infected;
Ro = num_imm;
S = zeros(1,T);
I = zeros(1,T);
R = zeros(1,T);
Si = zeros(1,T);
Sv = zeros(1,T);
A = zeros(1,T);
AV = zeros(1,T);
AI = zeros(1,T);
V = zeros(1,T);
a = init_infected;
av = 0;
ai = 0;
v = 0;
while t <= T
%     if mod(t,12) == 0
%         new = randi(100);
%         subs(new).status = 'I';
%     end
    
    for i = 1:length(subs)
        subs(i).move();
    end
   
    for k = 1:length(subs)        
        [close,dist] = inRadius(subs(k), subs(k:end), infection_radius);

        for j = 1:length(close)
            [type,infect] = checkStatus(subs(k),subs(close(j)+(k-1)),dist(j),beta);

            if infect
                subs(k).status = 'I';
                subs(close(j)+(k-1)).status = 'I';
                a = a + 1;
                if type == 'Sv'
                    av = av + 1;
                elseif type == 'Si'
                    ai = ai + 1;
                end
            end
        end
        checkRecover(subs(k), gamma);
    end
        
    x = [];
    y = [];
    c = [];
    for ind = 1:length(subs)
        x(ind) = subs(ind).position(1);
        y(ind) = subs(ind).position(2);
        
        vac = checkAge(subs(ind),vaccination_rate,alpha);
        if vac
            v = v + 1;
        end
        if subs(ind).status == 'Si'
            c(ind,:) = [1,1,0]; %yellow
            S(t) = S(t) + 1;
            Si(t) = Si(t) + 1;
        elseif subs(ind).status == 'Sv'
            c(ind,:) = [0,0,1]; %blue
            S(t) = S(t) + 1;
            Sv(t) = Sv(t) + 1;
        elseif subs(ind).status == 'I'
            c(ind,:) = [1 0 0]; %red
            I(t) = I(t) + 1;
        elseif subs(ind).status == 'R'
            c(ind,:) = [0 1 0]; %green
            R(t) = R(t) + 1;
        else
            c(ind,:) = [0 0 0]; %black
        end
        subs(ind).age = subs(ind).age + 1;
    end
    A(t) = a;
    AI(t) = ai;
    AV(t) = av;
    V(t) = v;
        
    scatter(x,y,[],c, 'filled', 'MarkerEdgeColor', 'k');
    title('Pertussis Outbreak in Partially Immune Population');
    axis([0 100 0 100]);
    drawnow

    o = [];
    for out = 1:bdr
        death = randi(100);
        delete(subs(death));
        o(out) = death;
    end
    for in = 1:bdr
        rx = 100*rand;
        ry = 100*rand;
        newsub = subject(rx,ry,'Si',0);
        subs(o(in)) = newsub;
    end

    t = t + 1;
end
disp('Total Affected = ');
disp(a);
time = linspace(0,T,T+1);
S = [So, S];
I = [Io, I];
R = [Ro, R];
A = [init_infected, A];
AI = [0, AI];
AV = [0, AV];
figure;
plot(time,S,'y',time,I,'r',time,R,'g','LineWidth',2);
title('SIR Dynamics of Disease');
xlabel('Time');
ylabel('Number of Subjects');
legend('Susceptible','Infected','Recovered');

figure;
plot(time,AI,'y--',time,AV,'b--',time,A,'r','LineWidth',2);
title('Subjects Affected');
xlabel('Time');
ylabel('Number of Subjects');
legend('Involuntary','Voluntary','Total');
