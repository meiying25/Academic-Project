library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)


bankchurner_data <- read.csv("C:/R language/BankChurners (clean data).csv", header = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "Credit Card Customer Segmentation",
                  tags$li(
                    class = "dropdown",
                    actionLink(
                      inputId = "logout",
                      label = icon("sign-out-alt"),  
                      title = "Logout"))),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home Page", tabName = "home", icon = icon("home")),
      menuItem("Customer Demographic", tabName = "demographic", icon = icon("user")),
      menuItem("Exploratory Data Analysis", tabName = "exploratory_data_analysis", icon = icon("credit-card")),
      menuItem("Revolving Balance Analysis", tabName = "revolving_analysis", icon = icon("chart-line")),
      menuItem("Relationship Analysis", tabName = "relationship_analysis", icon = icon("chart-bar"))
      )),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "home",
        div(
          style = "text-align: center; background-color: #dcdcdc; padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);",
          h1(style = "font-size: 36px; margin-bottom: 10px;", "Credit Card Customer Segmentation"), 
          h2(style = "font-size: 24px; margin-top: 0;", "Presented by Group DOLLAR SIGN $")
          ),
        br(),
        br(),
       fluidRow(
         column(width = 7, 
               imageOutput("credit_card", height = "400px")
         ),
         column(width = 5, 
               div(style = "padding: 20px; text-align: justify; font-size: 20px;",
                   p("The objective of the analysis:", br(),
                     "•	To identify segments of credit card customers based on their demographic, spending patterns, transaction frequency, credit limit, balance, and payment behaviour", br(),br(),
                     "•	To identify significant correlations between financial indicators such as credit limits, transaction counts, and utilization ratios", br(),br(),
                     "•	To assess balance trends to identify potential financial distress among customers")
                   ))
              )),
      
      tabItem(
        tabName = "demographic",
        
        fluidRow(
          valueBoxOutput("total_customers"),
          valueBoxOutput("total_attrition"),
          valueBoxOutput("attrition_rate")
        ),
        br(),
        sliderInput("age_range", "Age Range", min = 18, max = 90, value = c(25, 65)),
        fluidRow(
          column(6, plotOutput("age_distribution")),  
          column(6, plotOutput("gender_distribution")) 
        ),
        fluidRow(
          column(6, plotOutput("marital_status_pie")),  
          column(6, plotOutput("education_level_distribution")) 
        )
      ),
      
      tabItem(
        tabName = "exploratory_data_analysis",
        tabsetPanel(
          tabPanel("Boxplot",
                       br(),
                       br(),
                       br(),
                       plotOutput("box_plot")
                     ),
          
          tabPanel("Donut Chart (1)",
                     br(),
                     br(),
                     br(),
                     plotlyOutput("donut_chart")
                     ),
          
          tabPanel("Donut Chart (2)",
                   br(),
                   br(),
                   br(),
                   plotlyOutput("donut_chart_bycardcategory")
          ),
          
          tabPanel("Horizontal Bar Chart",
                   sidebarLayout(
                     sidebarPanel(
                       textInput("xvar", "X-axis variable:", value = "Dependent_count"),
                       textInput("yvar", "Y-axis variable:", value = "Credit_Limit")
                     ),
                     mainPanel(
                       plotOutput("barPlot")
                     )
                   )   
          ),

          tabPanel("Histogram",
                   sliderInput("Credit_Limit", "Credit Limit", min = 1400, max = 35000, value = c(1400,15000)),
                   plotOutput("hist_density_plot")
          )
          )
        ),
      
      tabItem(
        tabName = "revolving_analysis",
        fluidRow(
          box(
            width = 12,
            div(style = "text-align: center;",
              h3(style = "font-size: 36px; color: #0073B7; margin: 0;", "Customer Focus")
            ),
            style = "background-color: #F0F0F0; border: 1px solid #0073B7; padding: 10px; box-shadow: 3px 3px 5px #888888;"
          )
        ),
        fluidRow(
          valueBoxOutput("total_customers_by_rb"),
          valueBoxOutput("zero_rb"),
          valueBoxOutput("nonzero_rb")
        ),
        br(),
        sliderInput("revolving_range", "Range of Total Revolving Balance", min = 0, max = 2600, value = c(0, 1500)),
        fluidRow(
          column(6, plotOutput("age_distribution_by_rb")),  
          column(6, plotOutput("education_level_distribution_by_rb")) 
        ),
        fluidRow(
          column(6,plotlyOutput("income_donut_chart")),  
          column(6,plotOutput("dependent_bar_chart")) 
        )
      ),
      
      
      tabItem(
        tabName = "relationship_analysis",
        tabsetPanel(
          tabPanel("Scatter Plot (1)",
                   br(),
                   br(),
                   br(),
                   plotOutput("scatter_plot")
          ),
          
            tabPanel("Scatter Plot (2)",
                     br(),
                     br(),
                     br(),
                     plotOutput("scatterplot2")
            ),
          tabPanel("Scatter Plot (3)",
                   fluidRow(
                     column(4,
                            checkboxGroupInput(
                              "genderInput", 
                              "Select Education Level", 
                              choices = unique(bankchurner_data$Gender), 
                              selected = unique(bankchurner_data$Gender)  
                            )
                     ),
                     column(12,
                              plotOutput("scatterplot3")
                     ))
          )
        )
      )
    )
  )
)

server <- function(input, output) {
  
  output$credit_card <- renderImage(
    
    list(
      src = "C:\\R language\\group project\\creditcard.png", width = "100%", height = "400px"
    ),
    deleteFile = FALSE
  )
  
  filtered_data <- reactive({
    bankchurner_data %>%
      filter(
        Age >= input$age_range[1] & Age <= input$age_range[2] 
      )
  })
  
  output$total_customers <- renderValueBox({
    total_customers <- nrow(filtered_data())  
    valueBox(total_customers, "Total Customers", icon = icon("users"), color = "blue")
  })
  
  output$total_attrition <- renderValueBox({
    total_attrition <- sum(filtered_data()$Attrition_Flag == "Attrited Customer")  
    valueBox(total_attrition, "Attrited Customers", icon = icon("times-circle"), color = "red")
  })
  
  output$attrition_rate <- renderValueBox({
    total_attrition <- sum(filtered_data()$Attrition_Flag == "Attrited Customer")
    attrition_rate <- round((total_attrition / nrow(filtered_data())) * 100, 2)  
    valueBox(paste0(attrition_rate, "%"), "Attrition Rate", icon = icon("percentage"), color = "orange")
  })
  
  output$age_distribution <- renderPlot({
    ggplot(filtered_data(), aes(x = Age)) +
      geom_histogram(bins = 10, fill = "skyblue", color = "black") +
      labs(x = "Age", y = "Count", title = "Age Distribution") +
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), 
            panel.background = element_rect(fill = "white")) 
  })
  
  output$gender_distribution <- renderPlot({
    gender_counts <- filtered_data() %>%
      count(Gender) %>%
      arrange(desc(n))  
    
    ggplot(gender_counts, aes(x = reorder(Gender, n), y = n)) +
      geom_segment(aes(xend = reorder(Gender, n), yend = 0), color = "lightcoral", size = 4) +
      geom_point(color = "firebrick", size = 13) +
      geom_text(aes(label = n), vjust = -1.5, color = "black", size = 5) +
      labs(x = "Gender", y = "Count", title = "Gender Distribution") +
      theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"))+
      coord_flip()
  })

  output$marital_status_pie <- renderPlot({
    marital_data <- filtered_data() %>%
      count(Marital_Status)  
    
    ggplot(marital_data, aes(x = "", y = n, fill = Marital_Status)) +
      geom_bar(stat = "identity") +
      coord_polar(theta = "y") + 
      labs(x = NULL, y = NULL, title = "Marital Status Distribution") +
      geom_text(aes(label = scales::percent(n / sum(n))), position = position_stack(vjust = 0.5), size = 4)+
      theme_void()  
  })

  output$education_level_distribution <- renderPlot({
    ggplot(filtered_data(), aes(x = Education_Level, fill = Education_Level)) +
     geom_bar() +
     geom_text(stat='count', aes(label=after_stat(count)), vjust=-0.5) +
     labs(x = "Education Level", y = "Count", title = "Education Level Distribution")+
     theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = "white")
      )
  })
  
  output$box_plot <- renderPlot({
    boxplot(bankchurner_data$Credit_Limit~bankchurner_data$Card_Category,xlab="Card Category",ylab="Credit Limit",
            main="Credit Limit by Card Category", col=c("cyan", "mediumorchid", "pink","orange"))
  })
  
  donut_data <- reactive({
    bankchurner_data %>%
      group_by(Income_Category) %>%
      summarise(Credit_Limit = mean(Credit_Limit, na.rm = TRUE))
  })

  output$donut_chart <- renderPlotly({
    plot_ly(donut_data(), labels = ~Income_Category, values = ~round(Credit_Limit,2), type = 'pie', hole = 0.6) %>%
      layout(title = "Average Credit Limit by Income Category",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  donut_data_income <- reactive({
    bankchurner_data %>%
      group_by(Card_Category) %>%
      summarise(Mean_Income = mean(Mean_Income, na.rm = TRUE))
  })

  output$donut_chart_bycardcategory <- renderPlotly({
    plot_ly(donut_data_income(), labels = ~Card_Category,values = ~Mean_Income, type = 'pie', hole = 0.6, text = ~paste0("$", round(Mean_Income, 2), "k")) %>%
      layout(title = "Yearly Mean Income by Card Category",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
      )
  })
  
  output$barPlot <- renderPlot({
  
    bar_data <- bankchurner_data %>%
      group_by(Dependent_count) %>%
      summarise(Credit_Limit = sum(Credit_Limit)) %>%
      arrange(Credit_Limit) 
    
    bar_data$Dependent_count <- factor(bar_data$Dependent_count, levels = bar_data$Dependent_count)
    
    ggplot(bar_data, aes_string(x = "Dependent_count", y = "Credit_Limit")) +
      geom_bar(stat = "identity", position = "stack", fill = "skyblue", color = "skyblue") +
      labs(x = "Dependent Count", y = "Credit Limit", title = "Credit Limit by Dependent Count") +
      coord_flip() +  
      theme_minimal()+
      theme(
        plot.title = element_text(face = "bold")
      )
  })
 
  output$hist_density_plot <- renderPlot({
    hist_filter_data <- bankchurner_data[bankchurner_data$Credit_Limit >= input$Credit_Limit[1] & bankchurner_data$Credit_Limit <= input$Credit_Limit[2], ]
    hist(hist_filter_data$Credit_Limit, freq = FALSE, main = "Histogram and Density of Credit Card Limit", xlab = "Credit Card Limit", col = 'blue')
    dx <- density(hist_filter_data$Credit_Limit)
    lines(dx, lwd = 2, col = "red")
  })
  
  
  rb_filter_data <- reactive({
    bankchurner_data %>%
      filter(
        Total_Revolving_Bal >= input$revolving_range[1] & Total_Revolving_Bal <= input$revolving_range[2]  
      )
  })
  
  total_filtered_customers <- reactive({
    nrow(rb_filter_data())
  })
  
  output$total_customers_by_rb <- renderValueBox({
    total_customers_by_rb <- total_filtered_customers()  
    valueBox(total_customers_by_rb, "Total Customers", icon = icon("users"), color = "blue")
  })
  
  zero_rb_count <- reactive({
    nrow(rb_filter_data() %>% filter(Total_Revolving_Bal == 0))
  })
  
  nonzero_rb_count <- reactive({
    nrow(rb_filter_data() %>% filter(Total_Revolving_Bal > 0))
  })
  
  zero_rb_percentage <- reactive({
    if (total_filtered_customers() == 0) {
      return(0)
    } else {
      (zero_rb_count() / total_filtered_customers()) * 100
    }
  })
  
  nonzero_rb_percentage <- reactive({
    if (total_filtered_customers() == 0) {
      return(0)
    } else {
      (nonzero_rb_count() / total_filtered_customers()) * 100
    }
  })
  
  output$zero_rb <- renderValueBox({
    valueBox(
      paste0(round(zero_rb_percentage(), 2), "%"), "Zero Revolving Balance", icon = icon("check-circle"), color = "green"
    )
  })
  
  output$nonzero_rb <- renderValueBox({
    valueBox(
      paste0(round(nonzero_rb_percentage(), 2), "%"), "Non-Zero Revolving Balance", icon = icon("times-circle"), color = "red"
    )
  })
  
  output$age_distribution_by_rb <- renderPlot({
    ggplot(rb_filter_data(), aes(x = Age)) +
      geom_histogram(bins = 10, fill = "skyblue", color = "black") +
      labs(x = "Age", y = "Count", title = "Age Distribution")+
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(), 
            panel.background = element_rect(fill = "white"))
  })
  
  output$education_level_distribution_by_rb <- renderPlot({
    ggplot(rb_filter_data(), aes(x = Education_Level, fill = Education_Level)) +
      geom_bar() +
      geom_text(stat='count', aes(label=after_stat(count)), vjust=-0.5) + 
      labs(x = "Education Level", y = "Count", title = "Education Level Distribution")+
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(), 
            panel.background = element_rect(fill = "white"))
  })
  
  income_filter_data <- reactive({
    bankchurner_data %>%
      filter(
        Total_Revolving_Bal >= input$revolving_range[1] & Total_Revolving_Bal <= input$revolving_range[2]  
      )
  })
  
  income_category_counts <- reactive({
    income_filter_data() %>%
      group_by(Income_Category) %>%
      summarise(Customer_Count = n())
  })
  
  output$income_donut_chart <- renderPlotly({
    plot_ly(income_category_counts(), labels = ~Income_Category, values = ~Customer_Count, type = 'pie', hole = 0.6) %>%
      layout(title = "Customer Count by Income Category",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  dependent_filter_data <- reactive({
    bankchurner_data %>%
      filter(
        Total_Revolving_Bal >= input$revolving_range[1] & Total_Revolving_Bal <= input$revolving_range[2]  
      )
  })
  
  dependent_count_data <- reactive({
    dependent_filter_data() %>%
      group_by(Dependent_count) %>%
      summarise(Customer_Count = n()) %>%
      arrange(desc(Customer_Count))
  })
  
  output$dependent_bar_chart <- renderPlot({
    ggplot(dependent_count_data(), aes(x = reorder(factor(Dependent_count), Customer_Count), y = Customer_Count)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      geom_text(aes(label = Customer_Count), hjust = -0.2, size = 3) + 
      labs(x = "Dependent Count", y = "Customer Count", title = "Customer Count by Dependent Count") +
      theme(axis.text.y = element_text(size = 10),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), 
            panel.background = element_rect(fill = "white")
      )+
      coord_flip()
  })
  
  output$scatter_plot <- renderPlot({
    ggplot(bankchurner_data, aes(x = Avg_Utilization_Ratio, y = Credit_Limit)) +
      geom_point(shape = 21, fill = "white", color = "deepskyblue4", size = 2, stroke = 1.5, alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE, color = "red") +
      labs(x = "Average Utilization Ratio",
           y = "Credit Limit", 
           title = "Relationship between Average Utilization Ratio and Credit Limit")+
      theme_minimal()+
      theme(
        plot.title = element_text(face = "bold")
      )
  })
  
  output$scatterplot2 <- renderPlot({
    ggplot(bankchurner_data, aes(x = Total_Revolving_Bal, y = Avg_Utilization_Ratio, color = Attrition_Flag)) +
      geom_point(shape = 21, size = 2, stroke = 1.5, alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE, color = "red") +
      scale_color_manual(values = c("Existing Customer" = "deepskyblue4", "Attrited Customer" = "darkorange")) +
      labs(
        x = "Total Revolving Balance",
        y = "Average Utilization Ratio",
        title = "Relationship between Total Revolving Balance and Average Utilization Ratio",
        color = "Attrition Flag"
      ) +
      theme_minimal()+
      theme(
        plot.title = element_text(face = "bold")
      )
  })
  
  output$scatterplot3 <- renderPlot({
    scatter_data <- bankchurner_data %>%
      filter(Gender %in% input$genderInput)
    
    ggplot(scatter_data, aes(x = Credit_Limit, y = Total_Trans_Amt)) +
      geom_point(aes(color = Gender), shape = 21, fill = "white", size = 2.5, stroke = 1.5, alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE, aes(group = 1), color = "black") +
      labs(
        x = "Credit Limit",
        y = "Transaction Amount",
        color = "Gender",
        title = "Relationship between Credit Limit and Transaction Amount by Gender") +
      theme_minimal()+
      theme(
        plot.title = element_text(face = "bold")
        )
  })

}

shinyApp(ui, server)