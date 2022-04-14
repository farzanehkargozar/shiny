# CADAA


## Description of CADAA
The CADAA (Computer Aided Detection Agonist Antagonist) is an R-Shiny application designed to predict agonist / antagonist state of an unknown substance with respect to GPCRs using graph theory and network similarity. In this approach, at first the SDF file related to an unknown substance is submitted as the input file and compared with the knowledge based fingerprints of 400 drugs affecting GPCRs. This knowledge based database was made by random walk on similarity network of cognate ligands acting on different GPCRs (starting with each compound as a seed node). A resulting probability vector could indicate how this unkonwn compound might affect each receptor.   


## Install Dependencies
#### Install CRAN dependencies

```r
cran_pkgs <- c("igraph", "shiny","shinyjs", "shinyBS", "shinydashboard", "ggplot2", "dnet","ChemmineR","digest")

cran_pkgs.inst <- cran_pkgs[!(cran_pkgs %in% rownames(installed.packages()))]

if(length(cran_pkgs.inst)>0){ 
  print(paste0("Missing ", length(cran_pkgs.inst), " CRAN Packages:"))
  for(pkg in cran_pkgs.inst){
    print(paste0("Installing Package:'", pkg, "'..."));  
    install.packages(pkg, repo="http://cran.rstudio.org", dependencies=TRUE);print("Installed!!!") 
  }
}
```


#### Install Bioconductor dependencies for R versions > 4
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")
bioc_pkgs <- c( "supraHex","hexbin",  "fgsea","Rgraphviz")
bioc_pkgs.inst <- bioc_pkgs[!(bioc_pkgs %in% rownames(installed.packages()))];
if(length(bioc_pkgs.inst)>0){
  print(paste0("Missing ", length(bioc_pkgs.inst), " Bioconductor Packages:"));  
  for(pkg in bioc_pkgs.inst){
    print(paste0("Installing Package:'", pkg, "'..."));  
    BiocManager::install(pkg)
    print("Installed!!!")
  }
}
```
## Launch from GitHub

```r
runGitHub("shiny", "hadi-masjedy", subdir="shiny")
## Using the archived file
runUrl("https://github.com/hadi-masjedy/shiny/archive/refs/heads/master.tar.gz", subdir="shiny")
runUrl("https://github.com/hadi-masjedy/shiny/archive/refs/heads/master.zip", subdir="shiny")
```
## Launch locally
```
git clone https://github.com/hadi-masjedy/shiny
```

## Launch from R

```r
## Run by using runApp()
setwd("~/shiny")
shiny::runApp(appDir = getwd(), port = getOption("shiny.port"),
              launch.browser = getOption("shiny.launch.browser", interactive()),
              host = getOption("shiny.host", "127.0.0.1"), workerId = "",
              quiet = FALSE, display.mode = c("auto", "normal", "showcase"), 
              test.mode = getOption("shiny.testmode", FALSE))
```

## CADAA Usage

### Algorithm
<img src="/example/algorithm.jpg" width="600">
  This is primary tab of application and used for exacute the algorithm and its settings.

### About
<img src="/example/about.jpg" width="600">
  The summary about web application and description of it.
