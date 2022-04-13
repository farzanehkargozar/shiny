# ------------------------------------------------------------------------------------
# File: app.R
# 
# Author:     H.Masjedy (h.masjedy@gmail.com)
# Supervisor: Dr A.H.Sakhteman, 
#             Dr S.H.Seraj
# Date:       Spring 2022
# Course:     Doctorate Thesis in Pharmacy
# 
# Summary of File:
#   This file contains code which is an R-Shiny application designed to
#   find an agonist/ antagonist of an unknown substance relative to drugs affecting
#   GPCR receptors using graph theory and similar networks by supervised machine
#   learning algorithms. 
#------------------------------------------------------------------------------------- 

library(shiny)
library(shinyBS)
library(shinydashboard)
library("igraph")
library("ChemmineR")
library("dnet")

header <- dashboardHeader(title = "RShiny GPCR Agonist/Antagonist",
                          
                          titleWidth = 350
)


sidebar <-  dashboardSidebar(
    
    width = 350,
    sidebarMenu(
        sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                          label = "Search..."),
        menuItem("Algorithm", tabName = "algorithm", icon = icon("home")),
        menuItem("About", tabName = "about", icon = icon("eject"))
    )
)

body <- dashboardBody(

    tags$script(HTML("$('body').addClass('fixed');")), #To fix header and sidebar
    tags$head(tags$style(HTML('.content-wrapper { overflow: auto; }'))), 
    
    fluidPage(
        
        
        
        
    ),
    
    tabItems(
        
        ### Tab 1: Algorithm ----------------------------------------------------------------
        tabItem("algorithm",
                
                headerPanel(""),
                
                mainPanel(
                    
                    fluidRow(
                        column(width = 12,
                        
                        box(
                            bsPopover(id = "input_sdf", title = "Input File",
                                      content = paste("SDF file of unknown substance as input file and in .sdf format",
                                                      br(), sep = " " ),
                                      placement = "right",
                                      trigger = "hover",
                                      options = list(container = "body")
                            ),
                            fileInput(inputId = "sdf_input",
                                      label = list("SDF File of unknown substance", bsButton("input_sdf", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
                                      accept = c("sdf", ".sdf")),
                            actionButton('run_btn',label = 'Run'),
                            downloadButton('export_btn','Export result data'),
                           
        
                    
                            height = 200, width = 12, solidHeader = T
                            
                        ),
                        
                        box(
                            bsPopover(id = "output_mechanism", title = "Output Mechanism",
                                      content = paste("Mechanism of action of unknown substance",
                                                      br(), sep = " " ),
                                      placement = "right",
                                      trigger = "hover",
                                      options = list(container = "body")
                            ),
                            title = "Prediction Mechanism of action:",
                            textOutput(outputId = "mechanism"),
                            height = 100, width = 12, solidHeader = T
                            
                        ),
                        
                        box(
                            bsPopover(id = "output_indication", title = "Output Indication",
                                      content = paste("Indication target of unknown substance",
                                                      br(), sep = " " ),
                                      placement = "right",
                                      trigger = "hover",
                                      options = list(container = "body")
                            ),
                            title = "Indication target:",
                            textOutput(outputId = "target"),
                            height = 100, width = 12, solidHeader = T
                            
                        ),
                        
                        box(
                            bsPopover(id = "output_fingerprint", title = "Output Fingerprint",
                                      content = paste("Fingerprint of unknown substance",
                                                      br(), sep = " " ),
                                      placement = "right",
                                      trigger = "hover",
                                      options = list(container = "body")
                            ),
                            title = "Fingerprint of unknown substance:",
                            textOutput(outputId = "fingerprint"),
                            height = 1000, width = 12, solidHeader = T
                            
                        ),
                        
                        
                        )
                    )
                )
        ),
        
        ### Tab 2: About -------------------------------------------------------------
        tabItem("about",
                fluidRow(column(width = 12, includeHTML("www/Home.html"))),
                
                p("Made with", a("Shiny",
                                 href = "http://shiny.rstudio.com"
                ), "."),
                
                img(
                    src = "imageShiny.png",
                    width = "70px", height = "70px"
                )
                
        )
        
    )
)


if(interactive()){
ui <- dashboardPage(header, sidebar, body, skin = "green")


server <- function(input, output, session) {
    
    unknown <- reactive({
        req(input$sdf_input)
        
        drug_apset <- readRDS("inputData/apset.rds")
        drugs <- readRDS("inputData/drugs.rds")
        target_matrix <- readRDS("inputData/drugTargetMatrix.rds")
        randomWalkMatrix <- readRDS("inputData/outMat.rds")
        tanimoto_vector <- c()
        unknown_drug <- sdf2ap(read.SDFset(input$sdf_input$datapath))
        
        for (i in 1:length(drug_apset)) {
            tanimoto_vector[i] <- 
                cmp.similarity(unknown_drug, drug_apset[i])
        }
        
        bestSimilarity <- max(tanimoto_vector)
        bestSimilarityIndex <- which.max(tanimoto_vector)
        
        mechanism <- drugs$mechanism[bestSimilarityIndex]
        targetNames <- colnames(target_matrix)
        
        resultTarget <- c()
        for (i in 1:96) {
            if(target_matrix[bestSimilarityIndex, i] == 1){
                resultTarget <- append(resultTarget,targetNames[i])
            }
            
        }
        
        resultFingerprint <- bestSimilarity*randomWalkMatrix[bestSimilarityIndex, ]
        
        output$mechanism <- renderText(mechanism)
        output$target <- renderText(resultTarget)
        output$fingerprint <-renderText(resultFingerprint)
        result <- c(mechanism,resultTarget, resultFingerprint)
        return(result)
        
    })
    
    
    
    
    # output$mechaism <-renderText(unknown()[1])
    output$fingerprint <-renderText(unknown()[3])

     
   
    
}

# Run the application 
shinyApp(ui = ui, server = server)
}