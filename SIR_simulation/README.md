## SIR Simulation

Matlab program which simulates 100 subjects who are either susceptible, infected, or recovered from a disease,
moving in a 100 by 100 grid in discrete time steps. The subjects track their age, position and infection status, and have the ability to
move, become infected or infect others, recieve vaccination, and recover naturally. Every time step, two subjects "die" at random, and are
replaced by two "newborns" who are not yet vaccinated. Subjects increment their age at every time step, and at age "6", will randomly
receive or not receive a vaccination, depending on a variable vaccination rate. Subjects interact in the grid for a predetermined number
of time steps, and the simulation will then print graphs of the SIR dynamics of the simulation run after it terminates. The simulation
was designed to test the effects of a varying vaccinaton rate on the overall infection rate for a disease in a population. The data used to determine the infectivity and vaccination rate was the CDC data on the Pertussis diseae and the DTaP vaccine. 

Descriptions of the four matlab files are as follows:

subject.m : Definition of the objects which interact in the grid. The function defines a class which tracks it's x,y coordinates, 
infection status, and age. it also possesses functions which allow it to change position randomly, and check it's surrounding area
for nearby subjects and potentially infect them. The infection radius for each subject can be changed before every simulation run, and 
the probability of infection exponentially decays proportional to the distance between two subjects. The subjects also track and increment
their age, and at age 6 will either recieve vaccination and become immune, or forego vaccination and remain susceptible. 

testEnvironment.m : The first of two test environments. Both are identical, with the exception that this environment does not include
vaccinations; it is a pure SIR simulation where the only way to become immune is to first become "infected" and then become "recovered".
The environment contains an iterative structure that runs for the prespecified number of time steps. On each step the subjects are all told to move randomly, then each subject creates a list of the subjects within it's infection radius, and checks for infection. It does
this by first checking it's infection status, then checking those of it's neighbors. If two subjects are compatible for infection (i.e. one is infected and the other is susceptible) then the subjects will calculate an "infection threshold" which is determined by their distance from one another and by the "infectiousness" of the specific disease, which is determined experimentally. At each interaction an random number is generated, and if it exceeds the infection threshold the susceptible subject becomes infected. All subjects will interact this way, and the counts for each distinct group are tracked by vectors, which are then displayed graphically and the end of the simulation. In order to both introduce new subjects and maintain the total number present in the grid, every time step two subjects "die" at random and are removed, unrelated to their infection status. Then, two new subjects are added, with age set to one. The environment displays all subjects and their positions and infection status for each time step on an animated grid. The subjects' colors correlate to their infection status. Yellow = Susceptible, Red = Infected, Green = Recovered. 

testEnvironment2.m : Identical to above environment, with the distinction that subjects can recieve vaccination and immediately transition from Susceptible to Recovered. In order to more accurately represent how actual vaccines are administered, subjects do not recieve vaccination until they are age 6, meaning they are susceptible from ages 1 to 5. Then at age 6, they randomly receive or do not receive a vaccination, by generating a random number and comparing it to the prespecified vaccination rate, which is determined using CDC data. In order to differentiate between newborns who are not yet old enough to receive a vaccine, and those old enough but who "opted out" of vaccination, they are labeled "involuntarily" susceptible and "voluntarily" susceptible respectively. In the animated simulation, Yellow = Involuntary susceptible, Blue = Voluntary susceptible. 

discreteSIR.m : Creates a mathematical SIR dynamics graph with discrete time steps to compare with the results of the simulation. The standard SIR equations are modified to accomidate a vaccine which allows for direct S -> R interaction.  
