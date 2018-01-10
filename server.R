#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        ShinyPredictioin <- reactive(Capstone_Prediction(input$userInput, result_length = 50))

        output$topWord <- renderText({
                paste0("Top prediction: ", 
                       ShinyPredictioin()[1,Prediction])
        })
        
        output$resultTable <- renderTable({
                result = ShinyPredictioin()
                head(result, 8)
        })
        
        #output$topWord <- renderText({result[1,Prediction]})
                
        
        wordcloud_rep <- repeatable(wordcloud)
        output$wordcloud <- renderPlot({
                cloud = copy(ShinyPredictioin())
                cloud[1, Score := Score * .3]
                
                wordcloud::wordcloud(
                        cloud[,Prediction],
                        cloud[,Score],
                          scale=c(10,1),
                          rot.per=0.3,
                          colors=brewer.pal(8, "Dark2"),
                          random.order=T,
                          random.color=TRUE,
                          min.freq = 0,
                          max.words = 100,
                          family = "mono")
                })
        output$top12gram <- renderPlot({
                oneGramPlot = ggplot(readRDS("oneGramPlot.rds"), aes(reorder(feature, frequency), frequency)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        ggtitle("Top Unigrams") +
                        xlab("Unigram") + 
                        ylab("Frequency") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), 
                              plot.title = element_text(hjust = 0.5))

                twoGramPlot = ggplot(readRDS("twoGramPlot.rds"), aes(reorder(feature, frequency), frequency)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        ggtitle("Top Bigrams") +
                        xlab("Bigrams") + 
                        ylab("Frequency") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
                
                gridExtra::grid.arrange(oneGramPlot, twoGramPlot, ncol=2)
                })
        output$top34gram <- renderPlot({
                threeGramPlot = ggplot(readRDS("threeGramPlot.rds"), aes(reorder(feature, frequency), frequency)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        ggtitle("Top Trigrams") +
                        xlab("Trigrams") + 
                        ylab("Frequency") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), 
                              plot.title = element_text(hjust = 0.5))
                
                fourGramPlot = ggplot(readRDS("fourGramPlot.rds"), aes(reorder(feature, frequency), frequency)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        ggtitle("Top Quadgrams") +
                        xlab("Quadgrams") + 
                        ylab("Frequency") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
                
                gridExtra::grid.arrange(threeGramPlot, fourGramPlot, ncol=2)
                })
        output$top5gram <- renderPlot({
                ggplot(readRDS("fiveGramPlot.rds"), aes(reorder(feature, frequency), frequency)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        ggtitle("Top Pentagram") +
                        xlab("Pentagram") + 
                        ylab("Frequency") +
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
                })
        })
