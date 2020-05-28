# load libraries and data
if (!require("shiny", quietly = TRUE)) {install.packages("shiny")}
library(shiny)
if (!require("shinythemes", quietly = TRUE)) {install.packages("shinythemes")}
library(shinythemes)
if (!require("quanteda", quietly = TRUE)) {install.packages("quanteda")}
library(quanteda)
if (!require("corpus", quietly = TRUE)) {install.packages("corpus")}
library(corpus)
if (!require("dplyr", quietly = TRUE)) {install.packages("dplyr")}
library(dplyr)
if (!require("stringr", quietly = TRUE)) {install.packages("stringr")}
library(stringr)
if (!require("knitr", quietly = TRUE)) {install.packages("knitr")}
library(knitr)
if (!require("data.table", quietly = TRUE)) {install.packages("data.table")}
library(data.table)

#setwd("C:/Users/LLIU01/Desktop/Temp/Coursera/DataScienceCapstoneProject/DSCapstoneShiny")
if(!exists("four.lookup2")) {load("four.lookup2.RData")}
if(!exists("tri.lookup2")) {load("tri.lookup2.RData")}

# Define UI for predict the next word
ui <- navbarPage(title="Word Prediction App",theme = shinytheme("united"),inverse=TRUE,
                mainPanel(
                tabsetPanel(type = 'tabs',
                        tabPanel("Prediction App", br(),
                            h4("The predictive text input is using the N-gram model built using 20+ millions of n-grams."),
                            h4("By typing in phrases or a sentense, there will be a list of suggested words appear, with the highest ranking at the top."),
                            br(),
                            textInput(inputId="userinput", label="Type in phrase or sentence:", width="600",
                                        placeholder="Start typing..."),
                            h4("Suggested next word:"),
                            tableOutput("predict")),
                        tabPanel("Instruction", br(),br(),
                                h4("This app is simple and intuitive to use."), 
                                h4("Just type in the first few words of a sentence and the suggested next word will show up at the bottom." 
                                ),br(),
                                h4("For coding details please visit Github Repository: (https://github.com/liuliuc/DataScienceCapstone)"
                                )),
                        tabPanel("Additional Info", br(),
                                h3("Overview"),br(),
                                h4("- This app used N-gram natural language modeling method for the next word prediction."),
                                h4("Based on the fact how many words were used to build a n-gram, they are called uni-, bi (2), tri(3), four(4) ... n-gram."),
                                h4("For the project Uni-, Bi-, Tri-, Four- and Five-gram models were built using quanteda."),br(),
                                h4("- In each N-gram, the frequency of occurence of each word was counted, and the probability (prob)"),
                                h4("was calculated for a single occurence of word. Those serve as the training dataset."),br(),
                                h4("- For this application a stupid back-off model is used to determine which N-gram model to use."),
                                h4("Given an input string, the prediction model uses the last 3 words entered to search the four-gram model."),
                                h4("If no match was found, it backs off to the last 2 words and uses the tri-gram model."),
                                h4("If there is still no match the most likely unigram estimates will be choosen.")
                                )
                    )
))

# Define server logic required to the predicition output
server <- function(input, output) {
    
    output$predict <- renderTable(colnames=FALSE,{
        source("prediction.R", local = TRUE)
        prediction <- textpredict(input$userinput)
        ifelse((is.null(prediction)),"the",data.frame(prediction))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
