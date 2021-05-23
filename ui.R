library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)

shinyUI(fluidPage(theme = shinytheme("cerulean"),
                  
                  titlePanel("Student Alcohol Consumption"),
                  navbarPage("Let's get started",
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
                                                        choices = list("School"="school","Sex"="sex","Address"="address","Family size"="famsize"
                                                                       ,"Parent status"="Pstatus", "Reason to choose school"="reason",
                                                                       "Guardian"="guardian","Extra educational support"="schoolsup",
                                                                       "Family educational support"="famsup","Extra paid classes"="paid",
                                                                       "Internet"="internet","Romantic relationship"="romantic")),
                                          ),
                                          
                                          
                                          mainPanel(
                                            plotOutput('explorePlot')
                                          )
                                        ),
                                        
                                        fluidRow(column(DT::dataTableOutput("RawData"),
                                                        width = 12),
                                        ), fluidRow(
                                          p("Attributes for select factor: ",br(),"

                                            school - student's school (binary: 'GP' - Gabriel Pereira or 'MS' - Mousinho da Silveira)",br(),"
                                            sex - student's sex (binary: 'F' - female or 'M' - male)",br(),"
                                            address - student's home address type (binary: 'U' - urban or 'R' - rural)",br(),"
                                            famsize - family size (binary: 'LE3' - less or equal to 3 or 'GT3' - greater than 3)",br(),"
                                            Pstatus - parent's cohabitation status (binary: 'T' - living together or 'A' - apart)",br(),"
                                            reason - reason to choose this school (nominal: close to 'home', school 'reputation', 'course' preference or 'other')",br(),"
                                            guardian - student's guardian (nominal: 'mother', 'father' or 'other')",br(),"
                                            schoolsup - extra educational support (binary: yes or no)",br(),"
                                            famsup - family educational support (binary: yes or no)",br(),"
                                            paid - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no)",br(),"
                                            internet - Internet access at home (binary: yes or no)",br(),"
                                            romantic - with a romantic relationship (binary: yes or no)",br(),br(),"

                                            These grades are related with the course subject, Math or Portuguese:",br(),"
                                            
                                            G1 - first period grade (numeric: from 0 to 20)",br(),"
                                            G2 - second period grade (numeric: from 0 to 20)",br(),"
                                            G3 - final grade (numeric: from 0 to 20, output target)",br(),"
                                        ",
                                            style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                                          width=8)
                                      )
                             ),
                             
                             tabPanel("Relationships",
                                      sidebarLayout(
                                        sidebarPanel(
                                          
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
                                        
                                        
                                        mainPanel(
                                          
                                          plotOutput(outputId = "relationshipPlot")
                                          
                                        )
                                      ), fluidRow(
                                        p("Analyzing the data, we can see that people who have poor relationships with their family have a higher proportion of alcohol consumption above 1 than those who have better relationships. This may indicate that people with problems at home are more likely to drink alcohol. However, such dependence is not so apparent depending on whether or not they are in a romantic relationship. ",
                                          style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                        width=8)
                                      
                             ),
                             
                             tabPanel("Grades distribution",
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          
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
                                        
                                        
                                        mainPanel(
                                          
                                          plotOutput(outputId = "gradesHistPlot"),
                                          
                                          plotOutput(outputId = "gradesBoxPlot")
                                          
                                        )
                                      ), fluidRow(
                                        p("The split divides students into those who have alcohol consumption of a certain level or more. The relationship resulting from this analysis is obvious - students who drink alcohol more often have lower grades. ",
                                          style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                        
                                        width=8)
                             ),
                             tabPanel("Grades and cohabitation",
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          
                                          radioButtons(inputId = "subj",
                                                       label = "Subject:",
                                                       choices = list("Math"=1,"Portuguese"=2)),
                                          
                                          radioButtons(inputId = "grades_gradeT:",
                                                       label = "Grade period:",
                                                       choices = list("G1"="G1","G2"="G2","G3"="G3")),
                                          
                                          sliderInput("age_range", label = h3("Age range:"), min = 15, 
                                                      max = 19, value = c(15,19))
                                        ),
                                        
                                        
                                        mainPanel(
                                          
                                          plotOutput(outputId = "gradesC")
                                          
                                        )
                                      ), fluidRow(
                                        p("Boys that were living with a single parent(their parents lived apart) had
                                          better scores.
                                          The same, but the very opposite happend to girls' scores, when the parents
                                          lived together their scores were better.",
                                          style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                        width=8)
                             ),
                             tabPanel("Study Time",
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          
                                          radioButtons(inputId = "subjS",
                                                       label = "Subject:",
                                                       choices = list("Math"=1,"Portuguese"=2)),
                                          
                                          radioButtons(inputId = "grades_gradeS:",
                                                       label = "Grade period:",
                                                       choices = list("G1"="G1","G2"="G2","G3"="G3")),
                                          
                                          radioButtons(inputId = "rel_romanticS",
                                                       label = "In a romantic relationship:",
                                                       choices = list("Yes"="yes","No"="no"))
                                        ),
                                        
                                        mainPanel(
                                          
                                          plotOutput(outputId = "gradesSTR")
                                        )
                                      ), fluidRow(
                                        p(" Boys that were in the romantic relationship had slightly better scores
                                        even though they spent less time studying(the disappear of the 4th(highest)
                                        category of time spent studying indicates that).
                                        And their score's became 'more stable'.",
                                          style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                        width=8)
                             ),
                             tabPanel("Pie",
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          
                                          radioButtons(inputId = "subjP",
                                                       label = "Subject:",
                                                       choices = list("Math"=1,"Portuguese"=2)),
                                          
                                          radioButtons(inputId = "sexP",
                                                       label = "Sex:",
                                                       choices = list("Doesn't matter"="W", "Female"="F","Male"="M")),
                                          
                                          radioButtons(inputId = "activities",
                                                       label = "Extracurricular activities:",
                                                       choices = list("Doesn't matter" = 1, "Yes"=2,"No"=3)),
                                          
                                          radioButtons(inputId = "rel_romanticP",
                                                       label = "In a romantic relationship:",
                                                       choices = list("Doesn't matter" = 1, "Yes"=2,"No"=3)),
                                          
                                          
                                          radioButtons(inputId = "internetP",
                                                       label = "Internet access:",
                                                       choices = list("Doesn't matter"= 1, "Yes"= 2,"No"= 3))
                                          
                                          
                                        ),
                                        
                                        mainPanel(
                                          
                                          plotOutput(outputId = "Pass")
                                          
                                        )
                                      ), fluidRow(
                                        p("    Boys that weren't taking any extra lessons in romantic relationship
                                        has the biggest chance of failing at least once in math course.
                                        
                                        Girls in a romantic relationships have much greater chance of failing at
                                        least once in the math course, it didn't matter whether they had any extra lessons.
                                        
                                        Boys in a romantic relationship that were taking extra lessons had higher chance
                                        of passing all the math exams.",
                                          style="text-align:justify;color:black;background-color:papayawhip;padding:15px;border-radius:10px"),
                                        width=8)
                             )
                  )
)
)
