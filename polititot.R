## Dette scriptet tråler gjennom Twitter og henter ut tweets fra utvalgte politi-konti.
setwd ('/Users/chrilur/Documents/R/twpoliti/')

    pol <- c('Hordalandpoliti', 'oslopolitiops', 'Rogalandops')
    droppes <- c("favorited", "truncated", "replyToSID", "statusSource", "retweeted", "longitude", "latitude", "replyToUID", "retweetCount", "favoriteCount","replyToSN", "isRetweet")

tot <- read.table('totalt2.csv', header=TRUE, sep=",", stringsAsFactors=FALSE) 
        
for (i in 1:length(pol)) {
        print(paste("Henter tweets fra", pol[i]))
        tw <- userTimeline(pol[i], n=50)
                tw <- twListToDF(tw)
                tw <- tw[,!(names(tw) %in% droppes)]
                tw$text <- gsub("\"", "", tw$text)
                tw <- tw[c("created", "screenName", "text", "id")]

                d <- date()

                #Generiske filnavn
                ##Lagre uttrekket separat
                fil <- paste0('data/', pol[i], '_', d, '.csv')
                write.table(tw, fil, col.names=TRUE, row.names=FALSE, sep=",")

                #Hente tidligere samlet uttrekk, slå sammen med siste uttrekk og sortere
                tot <- merge(tw,tot, all=TRUE)
                rownames(tot) <- NULL
                tot <- unique(tot)
                tot <- tot[order(as.Date(tot[,1], format="%Y-%m-%d %H:%M:%S"), decreasing=TRUE),]
                }

#Lagre totaluttrekk
write.table(tot, 'totalt2.csv', col.names=TRUE, row.names=FALSE, sep=",")
print("Suksess!")