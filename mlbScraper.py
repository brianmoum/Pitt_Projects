from bs4 import BeautifulSoup
import requests
import io
import re
import csv

## IMPORTANT: Make sure both the page AND the name of the csv file writing
## the data to are the same year.

## Seems as though Baseball Reference is changing their html selectors for the
## content sections fairly frequently. Need to go directly to page and get new
## selector ID for every new scrape. If the data variable contains a NoneType
## this is the issue.

page2017 = requests.get("https://www.baseball-reference.com/leagues/MLB/2017-schedule.shtml")
page2018 = requests.get("https://www.baseball-reference.com/leagues/MLB/2018-schedule.shtml")
page2019 = requests.get("https://www.baseball-reference.com/leagues/MLB-schedule.shtml")
page = page2019

soup = BeautifulSoup(page.content, 'html.parser')

pretty = soup.prettify()

with io.open("html.txt", "w", encoding="utf-8") as f:
    f.write(pretty)

fullDates = []
fullTeams = []
fullScores = []
fullHomes = []
gameIDs = []

## Make sure to grab updated div_id before scraping.

div_id_2017 = 'div_6904075901'
div_id_2018 = 'div_2760521449'
div_id_2019 = 'div_8846635709'
div_id = div_id_2019

data = soup.find('div', class_= "section_content", id= div_id)
year = "2019"
id = 1
for divs in data.find_all('div'):
    date = str(divs.find('h3').contents)
    date = date[date.find("[")+1:date.find("]")]
    date = date.strip('\'\"')
    date = date.replace(",",'')
    if "Today" in date :
        date = 'Today'
    games = divs.find_all('p', class_= "game")
    for game in games:
        ##print(game.contents)
        teams = game.find_all("a")
        i = 1
        for team in teams:
            temp = str(team.get('href'))
            ##print(team.contents)

            if "team" in temp:
                teamStr = str(team.contents)
                teamStr = teamStr[teamStr.find("[")+1:teamStr.find("]")]
                teamStr = teamStr.strip('\'')
                teamStr = teamStr.strip('\"')
                fullDates.append(date)
                fullTeams.append(teamStr)
                if i == 2:
                    home = teamStr
                    fullHomes.append(teamStr)
                    fullHomes.append(teamStr)
                i += 1


        gameStr = str(game)
        scores = re.findall(r'\([0-9]+\)',gameStr)
        if len(scores) > 0 :
            first = scores[0]
            second = scores[1]
            first = first[first.find("(")+1:first.find(")")]
            second = second[second.find("(")+1:second.find(")")]
            first = int(first)
            second = int(second)
        fullScores.append(first)
        fullScores.append(second)
        gameIDs.append(year + "_" + str(id))
        gameIDs.append(year + "_" + str(id))
        id += 1

print(len(fullDates))
print(len(fullTeams))
print(len(fullScores))
print(len(fullHomes))
j = 0
while j < len(fullTeams):
    if fullTeams[j] == "Arizona D'Backs":
        fullTeams[j] = "Arizona Diamondbacks"
    j += 1
j = 0
while j < len(fullHomes):
    if fullHomes[j] == "Arizona D'Backs":
        fullHomes[j] = "Arizona Diamondbacks"
    j += 1

file2017 = 'mlb_2017.csv'
file2018 = 'mlb_2018.csv'
file2019 = 'mlb_2019.csv'
file = file2019
with open(file, mode='w') as mlb_file:
    mlb_writer = csv.writer(mlb_file, delimiter=',', quoting=csv.QUOTE_MINIMAL)

    mlb_writer.writerow(['Game_ID', 'Date', 'Team', 'Final_Score', 'Home_Team'])
    i = 0
    while i < len(fullScores):
        mlb_writer.writerow([gameIDs[i], fullDates[i], fullTeams[i], fullScores[i], fullHomes[i]])
        i += 1

## print(date)
## print(elements)
