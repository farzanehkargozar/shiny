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

header <- dashboardHeader(title = "CADAA")


sidebar <-  dashboardSidebar(
    
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
                
                headerPanel("CADAA Algorithm"),
                sidebarPanel(
                    p(strong("Compile CADAA algorithm data")),
                    bsPopover(id = "input_sdf", title = "Input File",
                              content = paste("SDF file of unknown substance as input file and in .sdf format", br(),
                                               sep = " "),
                              placement = "right",
                              trigger = "hover",
                              options = list(container = "body")),
                    box(
                    fileInput(inputId = "sdf_input",
                              label = list("SDF file of unknown substance:", bsButton("input_sdf", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
                              accept = c("sdf", ".sdf")),
                    collapsible = T,collapsed = F,width = 14,title="Input data file",solidHeader=T),
                    
                    box(
                        
                        numericInput(inputId = "num_target", label = "Select number of output target:", 1, 1, 97,1, "100%"),
                        # numericInput(inputId = "num_vortex", label = "Select number of subgraph vortex:", min = 2, step = 1, max = 50,value = 2, "100%"),
                        selectInput(inputId = "hash_func", label = "Select hash code function for fingerprint:", c("md5", "sha1","sha256")),
                        actionButton(inputId = "run_btn", label = "Calculate"),
                        collapsible = T,collapsed = T,width = 14,title="Algorithm Setting",solidHeader=T),
                    
                    box(
                        downloadButton('export_btn_fingerprint','Export Fingerprint'),
                        # br(),
                        # br(),
                        # downloadButton('export_btn_plot','Export plot'),
                        collapsible = T,collapsed = T,width = 14,title="Export",solidHeader=T),
                    
                      
                ),
                
                mainPanel(
                    
                    fluidRow(
                        column(width = 12,
                        
                        
                        # box(
                        #      # bsPopover(id = "output_mechanism", title = "Output Mechanism",
                        #      #           content = paste("Mechanism of action of unknown substance",
                        #      #                           br(), sep = " " ),
                        #      #           placement = "right",
                        #      #           trigger = "hover",
                        #      #           options = list(container = "body")
                        #      # ),
                        #     title = "Prediction Mechanism of action:",
                        #     textOutput(outputId = "mechanism"),
                        #     height = 100, width = 12, solidHeader = T
                        #     
                        # ),
                        # 
                        # box(
                        #     # bsPopover(id = "output_indication", title = "Output Indication",
                        #     #           content = paste("Indication target of unknown substance",
                        #     #                           br(), sep = " " ),
                        #     #           placement = "right",
                        #     #           trigger = "hover",
                        #     #           options = list(container = "body")
                        #     # ),
                        #     title = "Indication target:",
                        #     textOutput(outputId = "target"),
                        #     height = 100, width = 12, solidHeader = T
                        #     
                        # ),
                        
                        box(
                            plotOutput('plot_target_probability',
                                       height = 400,
                                       dblclick = 'plot_target_probability_dbl_click',
                                       brush = brushOpts(id = 'plot_target_probability_brush', resetOnNew = T)
                            ),
                            width = 12, collapsible = T,collapsed = T, title = "Plot of effect probability on GPCR receptors"),
                        
                        box(
                            title = "Plot of subgraph of candidate drug",
                            plotOutput('plot_subgraph',
                                       height = 400,
                                       dblclick = 'plot_subgrapgh_dbl_click',
                                       brush = brushOpts(id = 'plot_subgraph_brush', resetOnNew = T)
                            ),
                            width = 12, collapsible = T, collapsed = T),
                        
                        box(
                            # bsPopover(id = "output_fingerprint", title = "Output Fingerprint",
                            #           content = paste("Fingerprint of unknown substance",
                            #                           br(), sep = " " ),
                            #           placement = "right",
                            #           trigger = "hover",
                            #           options = list(container = "body")
                            # ),
                            title = "Fingerprint of unknown substance",
                            textOutput(outputId = "fingerprint"),
                            width = 12, collapsible = T, collapsed = T),
                        
                        
                        )
                    ),
                    
                    
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


ui <- dashboardPage(header, sidebar, body, skin = "green")