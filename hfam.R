library(ggplot2)

## Returns a 2-D dataframe containing the names of each MLB team and a home field advantage modifier
## (HFAM). The latter is calculated by first finding each team's average score for the 2017 and 2018
## seasons. Then the average score for each of the 30 teams when playing at each home stadium is 
## calculated, and each team's overall average score is subtracted from these results. Finally, the 
## 30 numbers representing the differences in scoring between each team's overall average and stadium
## average are themselves averaged, resulting in a HFAM for that particular stadium. A negative
## modifier indicates that visiting teams to the corresponding stadium score fewer runs when at that
## stadium compared to their overall average. A positive modifier indicates the opposite. 



mlb_s <- read.csv("mlb_2017.csv")
mlb_s$Date <- as.Date(mlb_s$Date, "%A %B %d %Y")
mlb_s[, 2] <- sapply(mlb_s[, 2], as.character)
xmlb_s <- subset(mlb_s, mlb_s$Date <= "2017-10-01")

mlb_s2 <- read.csv("mlb_2018.csv")
mlb_s2$Date <- as.Date(mlb_s2$Date, "%A %B %d %Y")
mlb_s2[, 2] <- sapply(mlb_s2[, 2], as.character)
xmlb_s2 <- subset(mlb_s2, mlb_s2$Date <= "2018-10-01")

stad_data <- rbind(xmlb_s, xmlb_s2)

stads <- as.character(unique(stad_data$Home_Team))
teams <- unique(stad_data$Team)
stad_mods <- matrix(ncol = 3)

for (stad in 1:length(stads)) {
  
  stad_scores <- stad_data[which(stad_data$Home_Team == stads[stad]), ] ## All scores at stadium
  
  for (team in 1:length(teams)) {
    team_scores <- stad_data[which(stad_data$Team == teams[team]), ] ## All team scores
    team_at_stad <- stad_scores[which(stad_scores$Team == teams[team]), ] ## Team scores at stadium
    
    team_avg <- mean(team_scores$Final_Score)
    stad_avg <- mean(team_at_stad$Final_Score)
    stad_mod <- as.numeric(stad_avg - avg)
    
    stad_mods <- rbind(stad_mods, c(as.character(stads[stad]), as.character(teams[team]), as.numeric(stad_mod)))
  }
  
}
stad_mods <- as.data.frame(stad_mods)
colnames(stad_mods) <- c('Stadium', 'Team', 'Modifier')
home_adv <- matrix(ncol = 2)

for (i in 1:length(stads)) {
  mod <- stad_mods[which(stad_mods$Stadium == stads[i]), ]
  mod <- subset(mod, mod$Team != stads[i])
  mod_avg <- mod$Modifier
  mod_avg <- sapply(mod_avg, as.character)
  mod_avg <- sapply(mod_avg, as.numeric)
  
  mod_avg <- mean(mod_avg, na.rm = TRUE)
  mod_avg <- round(mod_avg, digits = 3)
  
  home_adv <- rbind(home_adv, c(stads[i], mod_avg))
}
home_adv <- as.data.frame(home_adv)
home_adv <- tail(home_adv, -1)
colnames(home_adv) <- c('Home Team', 'Modifier')  
