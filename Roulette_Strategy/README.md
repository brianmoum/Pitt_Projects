# Martingale Bankroll Roulette Strategy

Python code which simulates the outcomes of roulette games utilizing a novel betting strategy. 

## The Strategy

I'm unsure if this strategy already has a name as I have not seen any betting strategy with comparable mechanics, so I'll refer to it as the Martingale Bankroll (MB) strategy. Essentially the motivation behind the strategy is to compensate for (what I think is) the greatest weakness of the traditional Martingale system, which is that in order to win some amount, the player needs to risk a disproportionately greater sum. Further, in order to accumulate winnings which are significant relevant to the amount being risked, it requires a very large number of bets to be made, which increases the risk of a bust. The MB strategy is to make two bets per round: a series of Martingale bets on an even money bet ("Red", "Black", "Odd", "Even", etc.), and another smaller bet on a high risk, high reward event, such as betting on a single number. The idea is that the Martingale bet essentially bankrolls the number bets, so that the player can make high-risk, high-reward wagers with what is essentially free money. Many analyses I've read of gambling strategies have the player make bets indefinitely, until invariably busting at some point. In order to reflect the player knowing when to quit, the simulation player bets using this strategy until he has made 50 total bets, or until he has won his number bet three times. The mechanics are displayed below:


Player has $9,000 to risk. He decides to allocate funds that will allow him to make 7 consecutive Martingale bets, which means the base amount he chooses for the Martingale bets must be 7 times the amount he places for the number bet. For the simulation, I chose a $10 number bet which corresponds to a $70 Martingale bet. The table below displays the possible outcomes. Assuming the player does not bust his Martingale bets, the worst case scenario is that the player loses 6 Martingale bets and also loses his simultaneous $10 number bets each round. Assuming he wins the Martingale bet on the 7th round, he will completely cover the losses from the 7 lost number bets, thereby essentially playing the number for free. In the other cases where the Martingale bet wins earlier than the 7th round, it creates a small surplus that can either be added to profit, or used up on number bets, further reducing the number of Martingale bets that are needed to bankroll the number bets.  

| MG Bet | Net Loss | Amount on Win | Net change from "number" bet |
|--------|----------|---------------|------------------------------|
| 70     | -70      | 140           | -10 (+60 on MG win)          |
| 140    | -210     | 280           | -20 (+50 on MG win)          |
| 280    | -490     | 560           | -30 (+40 on MG win)          |
| 560    | -1050    | 1120          | -40 (+30 on MG win)          |
| 1120   | -2170    | 2240          | -50 (+20 on MG win)          |
| 2240   | -4410    | 4480          | -60 (+10 on MG win)          |
| 4480   | -8890    | 8960          | -70 (Even on MG win)         |

## The Simulation

The simulation runs 1000 times, with the player making bets on a fair roulette wheel up to 50 times per iteration, or until he has won his number bet 3 times in the iteration. Using this strategy, with the above betting amounts, the player busted around 20-25% of the time, and successfully completed the betting round without busting 75-80% of the time. When the player did not bust, his average profit was around $1,450, which is a ~16% profit from a $9,000 initial bankroll. 
