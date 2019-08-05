library(ggplot2)


mlb <- read.csv("mlb_2018.csv")
mlb$Date <- as.Date(mlb$Date, "%A %B %d %Y")
mlb[, 2] <- sapply(mlb[, 2], as.character)
xmlb <- subset(mlb, mlb$Date <= "2018-10-01")

mlb2 <- read.csv("mlb_2019.csv")
mlb2$Date <- as.Date(mlb2$Date, "%A %B %d %Y")
mlb2[, 2] <- sapply(mlb2[, 2], as.character)
xmlb2 <- subset(mlb2, mlb2$Date >= "2019-03-28" & mlb2$Date < Sys.Date())

mlb_tot <- rbind(xmlb, xmlb2)

codes <- read.csv("mlb codes.csv")

## Edit these variables for each game
## code1 = "PIT"
## code2 = "CIN"
## run_line = 6.5

team1 = as.character(codes$Name[match(code1, codes$Code)]) ## Away Team
team2 = as.character(codes$Name[match(code2, codes$Code)])  ## Home Team

stadium_modifier <- as.numeric(as.character(stad_diff[stad_diff$`Home Team` == team2, 2]))
game_window = 30
start_date = Sys.Date()



i = 1
getScores <- function(team, games) {
  team_name = team
  game_window = games
  scores <- vector(mode = "integer", length = game_window)
  for (row in nrow(mlb_tot):1) {
    
    if (mlb_tot$Team[row] == team_name) {
      scores[i] = mlb_tot$Final_Score[row]
      i = i + 1
      if (i == game_window) {
        break
      }
    }
  }
  return(scores)
}
scores1 <- getScores(team1, game_window)
scores2 <- getScores(team2, game_window)

agg <- vector(mode = "integer", length = (game_window^2))
mod_agg <- vector(mode = "numeric", length = (game_window^2))
count = 1

for (n in 1:length(scores1)) {
  for (m in 1:length(scores2)) {
    agg[count] = scores1[n] + scores2[m]
    mod_agg[count] = scores1[n] + scores2[m] + stadium_modifier
    count = count + 1
  }
}

upper <- max(agg)
print(count)
print(length(agg))
print(length(mod_agg))

boxplot(agg, mod_agg, horizontal = TRUE, main = c(team1, " vs. ", team2), at = c(2,4), names = c('normal', 'modified'))
abline(v = run_line, col = "blue")
text(x=fivenum(agg), labels =fivenum(agg), y=2.5)
text(x=fivenum(mod_agg), labels =fivenum(mod_agg), y=3.5)
text(x=run_line, labels = run_line, y=3)
