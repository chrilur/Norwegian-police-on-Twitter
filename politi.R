## Dette scriptet tråler gjennom Twitter og henter ut tweets fra utvalgte politi-konti.

setwd ('/Users/chrilur/Documents/R/twpoliti/')

alle <- read.table('totalt.csv', sep=",", header=TRUE, stringsAsFactors=FALSE)
konti <- c('Hordalandpoliti', 'oslopolitiops', 'Rogalandops')
droppes <- c("favorited", "truncated", "replyToSID", "statusSource", "retweeted", "longitude", "latitude", "replyToUID", "retweetCount", "favoriteCount","replyToSN", "isRetweet")

print("Henter data fra Twitter...")

tw.df <- data.frame()
for (i in 1:length(konti)) {
        cat("Konto:", konti[i])
        tw <- userTimeline(konti[i], n=50)
        tw <- twListToDF(tw)
        tw <- tw[,!(names(tw) %in% droppes)]
        tw$text <- gsub("\"", "", tw$text)
        tw <- tw[c("created", "screenName", "text", "id")]
        tw.df <- rbind(tw.df,tw)
        }

alltw <- rbind(tw.df, alle)
alltw <- unique(alltw)

#Lagre data
write.table(alltw, 'totalt.csv', col.names=TRUE, row.names=FALSE, sep=",")
d <- date()
fil <- paste0('data/tweets', '_', d, '.csv')
write.table(tw.df, fil, col.names=TRUE, row.names=FALSE, sep=",")


alltwsorted <- alltw[with(alltw, order(alltw[1])), ]
twnr <- nrow(alltwsorted)
siste50 <- alltwsorted[((twnr-50):twnr),]
print(siste50)

