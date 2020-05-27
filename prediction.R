
textpredict <- function (myinquiry) {
#myinquiry <- "a pound of bacon, a bouquet, and a case of"
myinquiry.df <- data_frame(text=myinquiry)

urltag <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
myinquiry.tidy <- myinquiry.df %>%
    mutate(text = tolower(text)) %>% 
    mutate(text = str_replace_all(text, "<.*?>","")) %>% # Remove HTML/XML
    mutate(text = str_replace_all(text, urltag, "")) %>% # Remove URL
    mutate(text = str_replace_all(text, "(.{2,})\\1", "\\1")) %>% # remove 2+ repeats
    mutate(text = str_replace_all(text, "[:punct:]"," ")) %>% # Remove punctation
    mutate(text = str_replace_all(text, "[^A-Za-z ]",""))
myinquiry.corpus <- corpus(myinquiry.tidy)
myinquiry.tokens <- tokens(myinquiry.corpus) %>%
    tokens(remove_punct=TRUE,remove_numbers=TRUE,remove_separators=TRUE) %>%
    tokens_remove(pattern=letters) %>%
    tokens_wordstem()

inquiry.trigram <- tokens_ngrams(myinquiry.tokens,n=3)
inquiry.bigram <- tokens_ngrams(myinquiry.tokens,n=2)
inquiry.unigram <- tokens_ngrams(myinquiry.tokens,n=1)

inquiry3 <- tail(as.character(inquiry.trigram),1)
#system.time(match3 <- four.prob2.dt[.(inquiry3)])
match3 <- four.lookup2[.(inquiry3),nomatch = NULL]
match3.prob <- match3 %>% mutate(prob=prob*1)
pred3 <- head(match3.prob[order(-match3$prob),],10)[,c(2,3)]

inquiry2 <- tail(as.character(inquiry.bigram),1)
match2 <- tri.lookup2[.(inquiry2),nomatch = NULL]
match2.prob <- match2 %>% mutate(prob=prob*0.4)
pred2 <- head(match2.prob[order(-match2$prob),],10)[,c(2,3)]

#inquiry1 <- tail(as.character(inquiry.unigram),1)
#match1 <- bi.lookup2[.(inquiry1),nomatch = NULL]
#match1.prob <- match1 %>% mutate(prob=prob*0.4^2)
#pred1 <- head(match1.prob[order(-match1$prob),],10)[,c(2,3)]

pred.all <- rbind(pred3,pred2)
pred.top20 <- head(arrange(pred.all,desc(prob)),20)
predict10 <- head(unique(pred.top20$suggest),10)
return (predict10)

}