shinyApp(
  ui = fluidPage(
    checkboxGroupInput("species", label = h3("By Species"), 
                       choices = list("Adelie" = "Adelie", "Chinstrap" = "Chinstrap", "Gentoo" = "Gentoo"),
    ),
    checkboxGroupInput("island", label = h3("By Island"), 
                       choices = list("Biscoe" = "Biscoe", "Dream" = "Dream", "Torgersen" = "Torgersen"),
    ),
    checkboxGroupInput("sex", label = h3("By Sex"), 
                       choices = list("female" = "female", "male" = "male"),
    ),
    h3("Generate Report"),
    downloadButton("report", "Generate report")
  ),
  server = function(input, output) {
    output$report <- downloadHandler(
      
      filename = "report.pdf",
      content = function(file) {

        tempReport <- file.path(tempdir())
        file.copy(list.files(getwd()), tempReport, overwrite = TRUE, recursive = TRUE)

        params <- list(species = input$species,
                       island = input$island,
                       sex = input$sex
        )
        rmarkdown::render(paste0(tempReport,"/Report.rmd"), 
                          output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv()),
                          encoding = "UTF-8"
        )
        # change engine to quarto when shinyapps.io supports quarto
        #quarto::quarto_render(paste0(tempReport,"/Report.qmd"),
        #                      output_file = file,
        #                      execute_params = params)
      }
    )
  }
)