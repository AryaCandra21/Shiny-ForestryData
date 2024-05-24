server <- function(input, output){
  output$dataset <- renderDT(
    server = F,
    {
      
      data %>%
        filter(
          provinsi %in% input$prov_dataset) %>%
        datatable(
          extensions = "Buttons",
          options = list(
            scrollX = T,
            dom = "lBfrtip",
            buttons =
              list(
                list(
                  extend = "csv",
                  buttons = c("csv"),
                  exportOptions = list(
                    modifiers = list(page = "all")
                  )
                )
              )
          )
        ) %>%
        formatRound(
          columns = nama_kolom[-c(1:2)],
          digits = 3
        )
    })
  
  theme_set(theme_bw())
  
  output$vis_scatter <- renderPlot({
    
    data %>%
      filter(
        provinsi %in% input$prov_scatter) %>%
      ggplot(
        aes_string(
          x = input$var_scatterX,
          y = input$var_scatterY
        )
      ) +
      geom_point(
        size = 1.5,
        color = "blue") +
      labs(
        title = paste0(
          "Scatterplot variabel ",
          input$var_scatterX,
          " dan ",
          input$var_scatterY
        ),
        x = input$var_scatterX,
        y = input$var_scatterY
      ) +
      theme(
        plot.title = element_text(hjust = 0.5,
                                  face = "bold")
      )
  })
  
  output$vis_corr <- renderPlot({
    data_user <- data %>%
      filter(
        provinsi %in% input$prov_corr)
    
    psych::cor.plot(
      data_user[input$var_corr]
    )
  })
  
  output$vis_hist <- renderPlot({
    
    data %>%
      filter(
        provinsi %in% input$prov_hist) %>%
      ggplot(
        aes_string(
          input$var_hist
        )
      ) +
      geom_histogram(
        color = "black",
        fill = "maroon",
        alpha = 0.8) +
      labs(
        title = paste0(
          "Histogram dari ",
          input$var_hist
        )
      ) +
      theme(
        plot.title = element_text(hjust = 0.5,
                                  face = "bold")
      )
  })
  
  
  model_reg <- reactive({
    
    data %>%
      filter(
        provinsi %in% input$prov_reg) %>%
      lm(
        formula = as.formula(
          paste0(
            input$var_regY,
            "~",
            paste0(input$var_regX,
                   collapse = "+"
            )
          )
        ),
        data = .
      )
  })
  
  output$reg_coef <- renderDT(
    server = F,
    {
      model_reg() %>%
        broom::tidy() %>%
        datatable(
          extensions = "Buttons",
          options = list(
            scrollX = T,
            dom = "lBfrtip",
            "copy", "print", "csv", "excel"
          )
        ) %>%
        formatRound(c(2:5),
                    digits = 3
        )
  })
  
  output$reg_model <- renderDT({
    model_reg() %>%
      broom::glance() %>%
      datatable(
        extensions = "Buttons",
        options = list(
          scrollX = T,
          dom = "lBfrtip",
          "copy", "print", "csv", "excel"
        )
      ) %>%
      formatRound(c(1:12),
                  digits = 3
      )
  })
  
  output$reg_ANOVA <- renderDT({
    model_reg() %>%
      anova() %>%
      broom::tidy() %>%
      datatable(
        extensions = "Buttons",
        options = list(
          scrollX = T,
          dom = "lBfrtip",
          "copy", "print", "csv", "excel"
        )
      ) %>%
      formatRound(c(2:6),
                  digits = 3
      )
  })
  
  output$vis_reg_diagnostik <- renderPlot({
    model_reg() %>%
      performance::check_model() %>%
      plot()
  })
  
  output$diagnostik_normalitas <- renderPrint({
    model_reg() %>%
      residuals() %>%
      shapiro.test()
  })
  
  output$diagnostik_varians <- renderPrint({
    model_reg() %>%
      lmtest::bptest()
  })
  
  output$diagnostik_nonmultikol <- renderPrint({
    model_reg() %>%
      car::vif()
  })
}