today <- read.csv("mlb_2019.csv")
today <- subset(today, today$Date == "Today")
today$Date <- Sys.Date()
today <- subset(today, select = c(1,2,3,5))

num = nrow(today) / 2

for (game in seq(1,nrow(today), by = 2)) {  
  code1 = today$Team[game]
  code2 = today$Team[game + 1]
  pmpt =  paste("Enter runline for", code1, "vs.", code2, ": ", sep = " " )
  run_line = readline(prompt = pmpt)
  code1 = as.character(codes$Code[match(code1, codes$Name)])
  code2 = as.character(codes$Code[match(code2, codes$Name)])
  source('scoreGraph.R')
}