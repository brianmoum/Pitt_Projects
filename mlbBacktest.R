mlb_s <- read.csv("mlb_2017.csv")
mlb_s$Date <- as.Date(mlb_s$Date, "%A %B %d %Y")
mlb_s[, 1] <- sapply(mlb_s[, 1], as.character)
mlb_s[, 3] <- sapply(mlb_s[, 3], as.character)
xmlb_s <- subset(mlb_s, mlb_s$Date <= "2017-10-01")

mlb_s2 <- read.csv("mlb_2018.csv")
mlb_s2$Date <- as.Date(mlb_s2$Date, "%A %B %d %Y")
mlb_s2[, 2] <- sapply(mlb_s2[, 2], as.character)
mlb_s2[, 2] <- sapply(mlb_s2[, 2], as.character)
xmlb_s2 <- subset(mlb_s2, mlb_s2$Date <= "2018-10-01")

xmlb_tot <- rbind(xmlb_s, xmlb_s2)

finals <- aggregate(x = xmlb_tot$Final_Score, 
                    by = list(xmlb_tot$Game_ID), 
                    FUN = sum)


start_ind = 1001
game_window = 30

## stadium_modifier <- as.numeric(as.character(stad_diff[stad_diff$`Home Team` == team2, 2]))


getScores <- function(team, games) {
  team_name = team
  game_window = games
  scores <- vector(mode = "integer", length = game_window)
  i = 0
  for (row in (start_ind - 1):1) {
    
    if (xmlb_tot$Team[row] == team_name) {
      scores[i] = xmlb_tot$Final_Score[row]
      i = i + 1
      if (i == game_window) {
        break
      }
    }
  }
  return(scores)
}

test_data <- matrix(ncol = 3)
print('start')
test_counter = 1
for (game in seq(from = start_ind, to = nrow(xmlb_tot), by = 2)) {
  test_counter = test_counter + 1
  if (test_counter %% 100 == 0) {
    print(game)
  }
  
  team1 <- xmlb_tot$Team[game]
  team2 <- xmlb_tot$Team[game + 1]
  stadium_modifier <- as.numeric(as.character(stad_diff[stad_diff$`Home Team` == team2, 2]))
  
  scores1 <- getScores(team1, game_window)
  scores2 <- getScores(team2, game_window)
  
  agg <- vector(mode = "integer", length = (game_window^2))
  mod_agg <- vector(mode = "numeric", length = (game_window^2))
  count = 1
  
  for (n in 1:length(scores1)) {
    for (m in 1:length(scores2)) {
      agg[count] = scores1[n] + scores2[m]
      mod_agg[count] = as.numeric(as.character(scores1[n])) + as.numeric(as.character(scores2[m])) + as.numeric(as.character(stadium_modifier))
      count = count + 1
    }
  }
  
  true_score1 <- xmlb_tot$Final_Score[game]
  true_score2 <- xmlb_tot$Final_Score[game + 1]
  true_final <- as.numeric(as.character(true_score1)) + as.numeric(as.character(true_score2))
  
  test1 <- mean(agg)
  test2 <- mean(mod_agg)
  
  test_data <- rbind(test_data, c(true_final, test1, test2))
  test_data <- test_data[-1,]
}