library(shiny)
library(bslib)
library(markdown)
library(shinydashboard)
library(tidyverse)
library(shinythemes)
library(DT)
library(readxl)
library(performance)
library(see)
library(patchwork)

# read data
source("data/read_data.R")

# teks
# source("teks/teks.R")

# ui
source("ui/ui.R")

# server
source("server/server.R")

# run
shinyApp(ui = ui,
         server = server)
