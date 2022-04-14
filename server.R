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
# library("dnet")
library("digest")
library("ggplot2")

drug_apset <- readRDS("inputData/apset.rds")
drugs <- readRDS("inputData/drugs.rds")
target_matrix <- readRDS("inputData/drugTargetMatrix.rds")
randomWalkMatrix <- readRDS("inputData/outMat.rds")
targetName <- readRDS("inputData/targetName.rds")
mechanismName <- readRDS("inputData/mechanismName.rds")

if(interactive()){

function(input, output, session) {
    
    source('functions/output_target_vector.R')        
    source('functions/sort_RandomWalk_vector.R')
    source('functions/target_mapping.R')
    source('functions/mechanism_mapping.R')
    
    unknown <- reactive({
        req(input$sdf_input)
        tanimoto_vector <- c()
        unknown_drug <- sdf2ap(read.SDFset(input$sdf_input$datapath))
        
        
        for (i in 1:length(drug_apset)) {
            tanimoto_vector[i] <- 
                cmp.similarity(unknown_drug, drug_apset[i])
        }
        
        bestSimilarity <- max(tanimoto_vector)
        bestSimilarityIndex <- which.max(tanimoto_vector)
        
        # mechanism <- drugs$mechanism[bestSimilarityIndex]
        # targetNames <- colnames(target_matrix)
        # 
        # resultTarget <- c()
        # for (i in 1:96) {
        #     if(target_matrix[bestSimilarityIndex, i] == 1){
        #         resultTarget <- append(resultTarget,targetNames[i])
        #     }
        #     
        # }
        
        resultFingerprint <- bestSimilarity*randomWalkMatrix[bestSimilarityIndex, ]
        hashFingerprint <- digest(resultFingerprint, algo = input$hash_func)
        
        
        endResult <- c(bestSimilarity, bestSimilarityIndex)
        
        output$export_btn_fingerprint <- downloadHandler(filename = function(){
            paste("shiny_result", ".csv", sep = "")
        },
        content = function(file){
            write.csv(hashFingerprint, file)
            
        })
        
        return(endResult)
        
    })
     
     # output$mechanism <- renderText({
     #     if(input$run_btn == 0){
     #         return()
     #     }
     #     return(mechanism <- isolate(drugs$mechanism[unknown()[2]]))
     # })
     # 
     # output$target <- renderText({
     #     if(input$run_btn == 0){
     #         return()
     #     }
     #     targetNames <- colnames(target_matrix)
     #     
     #     resultTarget <- c()
     #     for (i in 1:97) {
     #         if(isolate(target_matrix[unknown()[2], i]) == 1){
     #             resultTarget <- append(resultTarget,targetNames[i])
     #         }
     #     }
     #     return(resultTarget)
     # })
     
    
    output$plot_target_probability <- renderPlot({
        if(input$run_btn == 0){
            return()
        }
        sortVector <- sort_RandomWalk_vector(randomWalkMatrix, isolate(unknown()[2]))
        targetVector <- output_target_vector(sortVector, target_matrix, isolate(input$num_target))
        
        nodeVector <- c()
        targetOut <- c()
        targetProbabilityVector <- c()
        
        unknown_drug <- sdf2ap(read.SDFset(isolate(input$sdf_input$datapath)))
        
        for (i in 1:nrow(targetVector)) {
            flag = FALSE
            for (j in 1:nrow(sortVector)) {
                if((targetVector$probability[i] == sortVector$value[j]) && flag==FALSE ){
                    
                    nodeVector <- append(nodeVector, sortVector$node[j])
                    targetOut <- append(targetOut, targetVector$target[i])
                    targetProbabilityVector <- append(targetProbabilityVector, cmp.similarity(unknown_drug, drug_apset[j]))
                    flag <- TRUE
                    
                }
            }
        }
        name <- c()
        for (i in 1:length(nodeVector)) {
            
            t1 <- targetName[targetOut[i]]
            t2 <- mechanismName[nodeVector[i]]
            name[i] <- paste(t2, t1, sep = "_")
            
        }
        
        dataForPlot <- data.frame(name = name, probability = targetProbabilityVector)
        
        ggplot(dataForPlot, aes(x = name, y = probability)) +
            geom_bar(stat = "identity", width=0.2) + theme_minimal() + ggtitle("") +
            xlab("Name of receptors") +
            ylab("Probability") +
            theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10), 
                  axis.title.y = element_text(size = 12),
                  axis.ticks.x = element_blank(),legend.position = "none",
                  plot.margin = margin(0, 2, 0, 4, "cm"),
                  panel.grid.minor = element_blank(),
                  plot.title = element_text(face = "bold"))
        
    })
    
    output$plot_subgraph <- renderPlot({
        if(input$run_btn == 0){
            return()
        }
        sortVector <- sort_RandomWalk_vector(randomWalkMatrix, isolate(unknown()[2]))
        
        vortex <- c()
        for (i in 1:isolate(input$num_vortex)) {
            vortex[i] <- sortVector$node[i]
            
        }
        
        data <- data.frame(vortex)
        st <- make_star(n = isolate(input$num_vortex), mode = "undirected")
        
        plot(st, vertex.label = data$vortex)
    })
     
    output$fingerprint <-renderText({
         if(input$run_btn == 0){
             return()
         }
         isolate(resultFingerprint <- unknown()[1]*randomWalkMatrix[unknown()[2],])
         hashFingerprint <- digest(resultFingerprint, algo = isolate(input$hash_func))
         return(hashFingerprint)
     })
    
    
     
     
}

}