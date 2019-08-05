


mlb_s <- read.csv("mlb_2017.csv")
mlb_s$Date <- as.Date(mlb_s$Date, "%A %B %d %Y")
mlb_s[, 1] <- sapply(mlb_s[, 1], as.character)
mlb_s[, 3] <- sapply(mlb_s[, 3], as.character)
xmlb_s <- subset(mlb_s, mlb_s$Date <= "2017-10-01")

mlb_s2 <- read.csv("mlb_2018.csv")
mlb_s2$Date <- as.Date(mlb_s2$Date, "%A %B %d %Y")
mlb_s2[, 1] <- sapply(mlb_s2[, 1], as.character)
mlb_s2[, 3] <- sapply(mlb_s2[, 3], as.character)
xmlb_s2 <- subset(mlb_s2, mlb_s2$Date <= "2018-10-01")

stad_data <- rbind(xmlb_s, xmlb_s2)

stads <- as.character(unique(stad_data$Home_Team))
teams <- unique(stad_data$Team)

game_scores <- matrix(ncol = 2)
score_mods <- matrix(ncol = 3)

finals <- aggregate(x = stad_data$Final_Score, 
                      by = list(stad_data$Game_ID), 
                      FUN = sum)
avg_final <- mean(finals$x)

stad_diff <- matrix(ncol = 2)

for (stad in 1:length(stads)) {
  
  stad_scores <- stad_data[which(stad_data$Home_Team == stads[stad]), ]
  stad_finals <- aggregate(x = stad_scores$Final_Score, 
                      by = list(stad_scores$Game_ID), 
                      FUN = sum)
  stad_finals_avg <- mean(stad_finals$x)
  stad_diff_mod <- as.numeric(stad_finals_avg - avg_final)
  stad_diff_mod <- round(stad_diff_mod, digits = 2)
  stad_diff <- rbind(stad_diff, c(stads[stad], stad_diff_mod))
}

stad_diff <- as.data.frame(stad_diff)
stad_diff <- tail(stad_diff, -1)
colnames(stad_diff) <- c('Home Team', 'Modifier')  