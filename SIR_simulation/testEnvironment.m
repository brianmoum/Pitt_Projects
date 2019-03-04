clc, clear
 
num_subs = 100; %Initial Population
percent_immune = 0.10; %Percentage of initial population in R
num_imm = round(num_subs * percent_immune); %Round Number in R
gamma = 0.05; %Rate at which subjects go from I to R
beta = 0.2; %Decay coeffiecint for infection. P(I) = exp(-beta*dist)
infection_radius = 8; %Max Distance infection is possible
bdr = 2;
 
for r = 1:num_subs
    a = round(5*rand);
    rx = 100*rand;
    ry = 100*rand;
    subs(r) = subject(rx,ry,'Si',a);
end
subs(end).status = 'I';
for imm = 1:num_imm
    subs(imm).status = 'R';
end
 
t = 1;
T = 60;
 
S = zeros(1,T);
I = zeros(1,T);
R = zeros(1,T);
 
while t <= T
     
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
        if subs(ind).status == 'Si'
            c(ind,:) = [1,1,0]; %yellow
            S(t) = S(t) + 1;
        elseif subs(ind).status == 'I'
            c(ind,:) = [1 0 0]; %red
            I(t) = I(t) + 1;
        elseif subs(ind).status == 'R'
            c(ind,:) = [0 1 0]; %green
            R(t) = R(t) + 1;
        else
            c(ind,:) = [0 0 0]; %black
        end
    end

    scatter(x,y,[],c, 'filled', 'MarkerEdgeColor', 'k');
    title('Disease Propagation through Partially Immune Population');
    axis([0 100 0 100]);
    drawnow
%     pause(1);
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
disp(S);
disp(I);
disp(R);
time = linspace(1,T,T);
% disp(length(S));
% disp(length(time));
figure;
plot(time,S,'y',time,I,'r',time,R,'g','LineWidth',2);
title('SIR Dynamics of Disease');
xlabel('Time');
ylabel('Number of Subjects');
legend('Susceptible','Infected','Recovered');