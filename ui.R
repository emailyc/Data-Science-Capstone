#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  title = "Text Prediction",
        
  # Application title
  titlePanel("Data Science Capstone: Next word prediction algorithm"),
  tabsetPanel(type='tab',
  tabPanel("Guess Next Word",
           # Sidebar with a slider input for number of bins 
           sidebarLayout(
                   sidebarPanel(
                           textInput("userInput", "Type your phrase here", "May the force be with"),
                           helpText("Note:",br(),
                                    "You may type any English text (seperated by space) into the text box above.",
                                    br(),
                                    "The table below and the word cloud on the right will update accordingly.",
                                    br(), br(),
                                    tableOutput('resultTable')
                                    ), 
                           width = 4),
                   
                   # Show a plot of the generated distribution
                   mainPanel(
                           h2(textOutput("topWord")),
                           h6("The wordcloud contains rest of the predictions"),
                           plotOutput('wordcloud',width='450px',height='500px')
                           )
                   )
           ),
  tabPanel("The Training Data",
           h3("Most Common Words, Bigrams to 5-grams (barcharts)"),
           h5("The dataset can be found ", a("here", href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")),
           h5("The algorithm utilised ~30% of the entire corpus."),
           br(),
           plotOutput('top12gram'),
           br(),
           plotOutput('top34gram'),
           br(),
           plotOutput('top5gram')
           ),
  tabPanel("About This App",
           h3("The Prediction Algorithm"),
           h6("The algorithm is based on the Stupid Backoff model (Brants, Popat, Xu, Och, & Dean, 2007) in Natural Language Processing (NLP)."),
           h6("This is a recursive model which directly use the relative frequencies to give score to each word in the corpus."),
           h6("A paper about many NLP algorithms including Stupid Backoff can be found ", a("here", href = "http://www.aclweb.org/anthology/D07-1090.pdf"), "."),
           br(),
           h5(a("Slide Deck", href = "http://rpubs.com/danskin/348215")),
           h5(a("Github Repository", href = "https://github.com/emailyc/Data-Science-Capstone")),
           br(),
           h5("This application is developed for the ", a("Data Science Specialisation Capstone Project.", href="https://www.coursera.org/learn/data-science-project")),
           h5("Offered by ", a("Coursera.org", href="https://www.coursera.org/")),
           h5("Created using ", a("Shiny", href = "https://shiny.rstudio.com"), ", a R package"),
           br()
           ),
  tabPanel("Reference & Further Readings",
           h5("Brants, T., Popat, A. C., Xu, P., Och, F. J., & Dean, J. (2007). Large language models in machine translation. In Proceedings of the Joint Conference on Empirical Methods in Natural Language Processing and Computational Natural Language Learning."),
           h5(a("Natural language processing Wikipedia page", 
                href = "https://en.wikipedia.org/wiki/Natural_language_processing")),
           h5(a("Text mining infrastucture in R", 
                href = "http://www.jstatsoft.org/v25/i05/")),
           h5(a("CRAN Task View: Natural Language Processing", 
                href = "http://cran.r-project.org/web/views/NaturalLanguageProcessing.html")),
           h5(a("Coursera course on NLP (not in R)", 
                href = "https://www.coursera.org/course/nlp")),
           br()
           )),
  
  fluidRow(
          HTML("<div style='margin-left:16px;margin-bottom:18px;color:grey;'><strong>Created on: Jan 2018</strong></div>")
  ),
  fluidRow(HTML("<div style='margin-left:16px;margin-bottom:30px;margin-top:-12px;color:grey;'><strong><big>By <a title='Write to me!...' 
      href='https://www.linkedin.com/in/yiu-chung-wong-19084a98/'>Yiu Chung Wong</a></big></strong>&nbsp;&nbsp;&nbsp;&nbsp;</div>"))
  ))
