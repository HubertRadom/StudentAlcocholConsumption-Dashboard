library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)

shinyUI(fluidPage(theme = shinytheme("cerulean"),
                  
                  titlePanel("Student Alcohol Consumption"),
                  navbarPage("Let's get started",
                             #tabPanel("1"),
                             tabPanel("Explore",
                                      
                                      fluidRow(column(tags$img(src="pp_logo.png",width="240px",height="240px"),width=2),
                                               column(
                                                 
                                                 br(),
                                                 p("This dashboard is a project for the Data Visualization course at the Poznań University of Technology. 
                                   It allows for an interactive analysis of the selected dataset. 
                                   It was made using RStudio and shiny. Visualizations were made in ggplot2. 
                                     ",style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                                 br(),
                                                 
                                                 p("The data used in this application are publicly available on the Kaggle. The data were obtained in a survey of students math and portuguese language courses in secondary school. 
                                     It contains a lot of interesting social, gender and study information about students.",
                                                   style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                                 
                                                 width=8),
                                               
                                               
                                               column(
                                                 br(),
                                                 p("To find more about",em("Student Alcohol Consumption"),"dataset click below.",
                                                   br(),
                                                   a(href="https://www.kaggle.com/uciml/student-alcohol-consumption", "Go to Kaggle",target="_blank"),style="text-align:center;color:black"),
                                                 #  width=2),
                                                 br(),
                                                 
                                                 
                                                 p("To check out ",em("source code")," click below.",
                                                   br(),
                                                   a(href="https://www.kaggle.com/uciml/student-alcohol-consumption", "Go to Github",target="_blank"),style="text-align:center;color:black"),
                                                 width=2),
                                               
                                               br()
                                      ),
                                      
                                      
                                      fluidRow(  
                                        sidebarLayout(
                                          sidebarPanel(
                                            
                                            # Input: Slider for the number of bins ----
                                            radioButtons(inputId = "expl_subject",
                                                         label = "Subject:",
                                                         choices = list("Math"=1,"Portuguese"=2)),
                                            radioButtons(inputId = "expl_grade:",
                                                         label = "Grade period:",
                                                         choices = list("G1"="G1","G2"="G2","G3"="G3")),
                                            selectInput(inputId = "expl_factor",
                                                        label = "Select factor:",
                                                        choices = list("Sex"="sex","Address"="address","Family size"="famsize")),
                                          ),
                                          
                                          
                                          mainPanel(
                                            plotOutput('explorePlot')
                                          )
                                        )
                                      ),
                                      
                                      
                                      fluidRow(column(DT::dataTableOutput("RawData"),
                                                      width = 12),
                                               #column(plotOutput('explorePlot'),
                                               #      width = 3)
                                               
                                      ),
                                      
                                      
                             ),
                             
                             tabPanel("Relationships",
                                      sidebarLayout(
                                        
                                        # Sidebar panel for inputs ----
                                        sidebarPanel(
                                          
                                          # Input: Slider for the number of bins ----
                                          radioButtons(inputId = "rel_subject",
                                                       label = "Subject:",
                                                       choices = list("Math"=1,"Portuguese"=2)),
                                          radioButtons(inputId = "rel_alcohol",
                                                       label = "Alcohol consumption time:",
                                                       choices = list("Workday"="Dalc","Weekend"="Walc")),
                                          radioButtons(inputId = "rel_romantic",
                                                       label = "In a romantic relationship:",
                                                       choices = list("Yes"="yes","No"="no"))
                                        ),
                                        
                                        
                                        # Main panel for displaying outputs ----
                                        mainPanel(
                                          
                                          # Output: Histogram ----
                                          plotOutput(outputId = "relationshipPlot")
                                          
                                        )
                                      )
                             ),
                             
                             tabPanel("Grades distribution",
                                      sidebarLayout(
                                        
                                        # Sidebar panel for inputs ----
                                        sidebarPanel(
                                          
                                          # Input: Slider for the number of bins ----
                                          radioButtons(inputId = "grades_subject",
                                                       label = "Subject:",
                                                       choices = list("Math"=1,"Portuguese"=2)),
                                          radioButtons(inputId = "grades_alcohol",
                                                       label = "Alcohol consumption time:",
                                                       choices = list("Workday"="Dalc","Weekend"="Walc")),
                                          radioButtons(inputId = "grades_grade:",
                                                       label = "Grade period:",
                                                       choices = list("G1"="G1","G2"="G2","G3"="G3")),
                                          sliderInput("grades_split", label = h3("Split:"), min = 1, 
                                                      max = 5, value = 3)
                                        ),
                                        
                                        
                                        # Main panel for displaying outputs ----
                                        mainPanel(
                                          
                                          # Output: Histogram ----
                                          plotOutput(outputId = "gradesHistPlot"),
                                          
                                          plotOutput(outputId = "gradesBoxPlot")
                                          
                                        )
                                      )
                             )
                  )
)
)
