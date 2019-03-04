import random
import numpy as np

def roulette():
    black = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35]
    red = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]
    green = [0,37]

    result = random.randint(0,37)
    color = "null"
    if result in black:
        color = "black"
    elif result in red:
        color = "red"
    elif result in green:
        color = "green"

    return [result, color]

runs = 0
busts = 0
tot_winnings = []
tot_norm_wins = []
while runs < 1000:
    cash = 10000
    norm_cash = 10000
    prop_wins = 0
    bets = 0
    bet_color = "black"
    bet_number = 14
    mg_count = 0
    mg_bet = 70
    prop_bet = 10
    bust = False
    temp_bet = 0

    while prop_wins < 3 and bets < 50 :

        bets += 1
        if mg_count == 0:
            temp_bet = mg_bet
        else:
            temp_bet = temp_bet * 2

        mg_count += 1
        cash = cash - (temp_bet + prop_bet)
        norm_cash = norm_cash - prop_bet

        [result, color] = roulette()

        if result == bet_number:
            prop_wins += 1
            cash = cash + (35*prop_bet)
            norm_cash = norm_cash + (35*prop_bet)

        if color == bet_color:
            mg_count = 0
            cash = cash + (2 * temp_bet)

        if color != bet_color and mg_count == 7:
            '''print("Martingale Bust")'''
            bust = True
            busts += 1
            break
    if mg_count > 0 and bust == False:
        while mg_count > 0:
            bets += 1
            mg_count += 1
            temp_bet = mg_bet * mg_count
            cash = cash - (temp_bet + prop_bet)

            [result, color] = roulette()

            if result == bet_number:
                prop_wins += 1
                cash = cash + (35*prop_bet)

            if color == bet_color:
                mg_count = 0
                cash = cash + (2 * temp_bet)

            if color != bet_color and mg_count == 7:
                '''
                print("Martingale Bust")

                '''
                bust = True
                busts += 1
                break
    winnings = cash - 10000
    norm_winnings = norm_cash - 10000
    tot_norm_wins.append(norm_winnings)
    if bust == False:
        tot_winnings.append(winnings)
    runs += 1
    '''
    print("Total bets = ", bets)
    print("Total prop wins = ", prop_wins)
    print("Final cash total = ", cash)
    print("Total winnings = ", winnings)
    '''
print("Total runs = ", runs)
print("Number of Martingale busts = ", busts)
print("Success percentage = ", (1 - (busts/runs)))
print("Average profit = ", np.mean(tot_winnings))
print("Average profit (without Martingale bet) = ", np.mean(tot_norm_wins))
