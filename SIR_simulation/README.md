## SIR Simulation

Matlab program which simulates 100 subjects who are either susceptible, infected, or recovered from a disease,
moving in a 100 by 100 grid in discrete time steps. The subjects track their age, position and infection status, and have the ability to
move, become infected or infect others, recieve vaccination, and recover naturally. Every time step, two subjects "die" at random, and are
replaced by two "newborns" who are not yet vaccinated. Subjects increment their age at every time step, and at age "6", will randomly
receive or not receive a vaccination, depending on a variable vaccination rate. Subjects interact in the grid for a predetermined number
of time steps, and the simulation will then print graphs of the SIR dynamics of the simulation run after it terminates. 
