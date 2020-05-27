# load libraries and data
if (!require("shiny", quietly = TRUE)) {install.packages("shiny")}
library(shiny)
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
if (!require("tidyr", quietly = TRUE)) {install.packages("tidyr")}
library(tidyr)
if (!require("readtext", quietly = TRUE)) {install.packages("readtext")}
library(readtext)

#setwd("C:/Users/LLIU01/Desktop/Temp/Coursera/DataScienceCapstoneProject/DSCapstoneShiny")
if(!exists("four.lookup2")) {load("four.lookup2.RData")}
if(!exists("tri.lookup2")) {load("tri.lookup2.RData")}
if(!exists("bi.lookup2")) {load("bi.lookup2.RData")}

# Define UI for predict the next word
ui <- fluidPage(
    titlePanel("Text Prediction"),
    p("The predictive text input is based on the model built using 20+ millions of n-grams."),
    p("By typing in phrases or a sentense, there will be a list of suggested words appear, with the highest ranking at the top."),
    
    textInput(inputId="userinput", label="Type in phrase or sentence:", width="1000",
              placeholder="Start typing..."),
    tableOutput("predict")
  )
    
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
