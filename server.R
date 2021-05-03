library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)
library(plyr)
library(dplyr)

d_math=read.table("www/student-mat.csv",sep=",",header=TRUE)
d_por=read.table("www/student-por.csv",sep=",",header=TRUE)

d_math$sum_alcohol <- d_math$Dalc + d_math$Walc
d_por$sum_alcohol <- d_por$Dalc + d_por$Walc

dfs=list(d_math,d_por)

shinyServer(function(input, output) {
  
  output$RawData <- DT::renderDataTable(
    
    DT::datatable({
      select( dfs[[strtoi(input$expl_subject)]] ,school,sex,age,address,famsize,Pstatus,Medu,Fedu,Mjob,Fjob)
    },
    options = list(lengthMenu=list(c(5,10,15),c('5','10','15')),pageLength=5,
                   initComplete = JS(
                     "function(settings, json) {",
                     "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '1c1b1b'});",
                     "}"),
                   columnDefs=list(list(className='dt-center',targets="_all"))
    ),
    filter = "top",
    selection = 'multiple',
    style = 'bootstrap',
    class = 'cell-border stripe',
    rownames = FALSE,
    #colnames = c("School","Sex","Age")
    colnames = c("School","Sex","Age","Address","Family size", "Parent status","Mother's edu","Father's edu","Mother's job","Father's job")
    #print(input$RawData_rows_selected)
    ))
  #print(input$RawData_rows_selected)
  
  
  output$explorePlot = renderPlot({
    
    
    sub = strtoi(input$expl_subject)
    
    set.seed(123)
    ggplot(dfs[[sub]], aes_string(x = input$expl_grade, y = "sum_alcohol", color=input$expl_factor)) +
      #geom_point(aes(color = "yellow")) +
      geom_jitter() +
      geom_point(data = dfs[[sub]][input$RawData_rows_selected,], aes_string(x = input$expl_grade, y = "sum_alcohol"), size=5, color="black") + 
      theme_classic() +
      stat_smooth(method = "lm",
                  col = "#C42126",
                  se = FALSE,
                  size = 1.5) +
      geom_smooth(method="lm")
    
  })
  
  
  output$relationshipPlot <- renderPlot({
    
    sub = strtoi(input$rel_subject)
    temp_data = dfs[[sub]]
    temp_data$Dalc <- as.factor(temp_data$Dalc)
    temp_data$Walc <- as.factor(temp_data$Walc)
    
    ggplot(data = filter(temp_data, romantic == input$rel_romantic), aes_string(x = "famrel", fill = input$rel_alcohol)) +
      geom_bar(position = "fill") + ylab("proportion") +
      stat_count(geom = "text", 
                 aes(label = stat(count)),
                 position=position_fill(vjust=0.5), colour="white")
    
  })
  
  
  output$gradesHistPlot <- renderPlot({
    
    sub = strtoi(input$grades_subject)
    temp_data = dfs[[sub]]
    
    if (input$grades_alcohol == "Walc") {
      temp_data$split = ifelse(temp_data$Walc >= strtoi(input$grades_split), "more", "less")
    } else {
      temp_data$split = ifelse(temp_data$Dalc >= strtoi(input$grades_split), "more", "less")
    }
    
    if (input$grades_grade == "G1") {
      cdat <- ddply(temp_data, "split", summarise, mean=mean(G1))
    } else if (input$grades_grade == "G2") {
      cdat <- ddply(temp_data, "split", summarise, mean=mean(G2))
    } else if (input$grades_grade == "G3") {
      cdat <- ddply(temp_data, "split", summarise, mean=mean(G3))
    }
    
    ggplot(temp_data, aes_string(x=input$grades_grade, fill="split")) +
      geom_histogram(binwidth=1, alpha=.5, position="identity") + 
      geom_vline(data=cdat, aes_string(xintercept="mean",  colour="split"),
                 linetype="dashed", size=1)
    
  })
  
  output$gradesBoxPlot <- renderPlot({
    
    sub = strtoi(input$grades_subject)
    temp_data = dfs[[sub]]
    
    if (input$grades_alcohol == "Walc") {
      temp_data$split = ifelse(temp_data$Walc >= strtoi(input$grades_split), "more", "less")
    } else {
      temp_data$split = ifelse(temp_data$Dalc >= strtoi(input$grades_split), "more", "less")
    }
    
    
    ggplot(temp_data, aes_string(x="split", y=input$grades_grade, fill="split")) + geom_boxplot() +
      guides(fill=FALSE)
    
  })
  
})

