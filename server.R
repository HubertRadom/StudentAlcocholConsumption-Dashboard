library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)
library(plyr)
library(dplyr)

library(ggridges)
library(viridis)
library(hrbrthemes)
library(RColorBrewer)

require(gridExtra)

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
    colnames = c("School","Sex","Age","Address","Family size", "Parent status","Mother's edu","Father's edu","Mother's job","Father's job")
    ))

  
  output$explorePlot = renderPlot({
    
    
    sub = strtoi(input$expl_subject)
    
    set.seed(123)
    ggplot(dfs[[sub]], aes_string(x = input$expl_grade, y = "sum_alcohol", color=input$expl_factor)) +
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
      geom_bar(position = "fill") + ylab("proportion") + xlab("family relations") + labs(fill = "alcohol consumption") +
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
  
  
  
  output$gradesC <- renderPlot({
    
    sub = strtoi(input$subj)
    temp_data = dfs[[sub]]
    
    temp_data$sex <- as.factor(temp_data$sex)
    temp_data$Pstatus <- as.factor(temp_data$Pstatus)
    
    ggplot(temp_data[temp_data[, "age"]>=input$age_range[1] & temp_data[, "age"]<=input$age_range[2], ], aes_string(x="sex", y=input$grades_gradeT, fill="Pstatus")) + 
      geom_violin(trim=T) +
      ylim(0, 20)
    

    
  })
  
  output$gradesSTR <- renderPlot({
    
    sub = strtoi(input$subjS)
    temp_data = dfs[[sub]]
    
    temp_data$studytime <- as.factor(temp_data$studytime)
    
    
    
    p1 <- ggplot(data = filter(temp_data, romantic == input$rel_romanticS & sex == "M"), aes_string(x = input$grades_gradeS, y = "studytime", fill= "..x..")) + 
      geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
      labs(title = "Boys' score") + 
      scale_fill_viridis(name = "Score", option = "C") +
      theme_ipsum() + 
      theme(
        panel.spacing = unit(0.1, "lines"),
        strip.text.x = element_text(size=8)
      )
    
    p2 <- ggplot(data = filter(temp_data, romantic == input$rel_romanticS & sex == "F"), aes_string(x = input$grades_gradeS, y = "studytime", fill="..x..")) + 
      geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
      labs(title = "Girls' score") + 
      scale_fill_viridis(name = "Score", option = "C") +
      theme_ipsum() + 
      theme(
        panel.spacing = unit(0.1, "lines"),
        strip.text.x = element_text(size=8)
      )
    
    grid.arrange(p1, p2, ncol = 2)
    
    
  })
  
  output$Pass <- renderPlot({
    
    sub = strtoi(input$subjP)
    t_data = dfs[[sub]]
    
    
    myPalette <- brewer.pal(5, "Set2")
    
    
    column = c()
    for (val in t_data[,"failures"] == 0){
      if (val){
        column <-  c(column, "Pass")
      }
      else{
        column <-  c(column, "Fail")
      }
    }
    t_data$lucky <- column
    sum(t_data$lucky == "Fail")
    
    ###
    grid <- matrix(c(1, 1, 2, 3), nrow = 2, ncol = 2, byrow = T)
    layout(grid)
    
    x = input$sexP
    dt = t_data
    if(x == "F"){
      dt = t_data[t_data[, "sex"] == "F",]
    }
    if(x == "M"){
      dt = t_data[t_data[, "sex"] == "M",]
    }
    
    data_yes = list(c("yes", "yes"), c("yes", "no"), c("no", "yes"))
    
    da = data_yes[[strtoi(input$activities)]]
    
    data_temp = dt[dt[, "activities"] == da[1] | dt[, "activities"] != da[2],]
    
    
    prop <- c(sum(data_temp[,"lucky"] == "Pass" ), sum(data_temp[,"lucky"] == "Fail"))
    p1 <- pie(prop, labels = c("Pass", "Fail"), col = myPalette, main = "Extracurricular activities")
    
    ###
    
    
    dr = data_yes[[strtoi(input$rel_romanticP)]]
    data_temp1 = data_temp[data_temp[, "romantic"] == dr[1] | data_temp[, "romantic"] != dr[2],]
    
    prop <- c(sum(data_temp1[,"lucky"] == "Pass" ), sum(data_temp1[,"lucky"] == "Fail"))
    p2 <- pie(prop, labels = c("Pass", "Fail"), col = myPalette, main = "Romantic relationship")
    
    ##
    di = data_yes[[strtoi(input$internetP)]]
    data_temp2 = data_temp[data_temp[, "internet"] == di[1] | data_temp[, "internet"] != di[2],]
    
    prop <- c(sum(data_temp2[,"lucky"] == "Pass"), sum(data_temp2[,"lucky"] == "Fail"))
    p3 <- pie(prop, labels = c("Pass", "Fail"), col = myPalette, main = "Internet access")
    
    
  })
  
  
})

