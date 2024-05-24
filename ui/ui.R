ui <- fluidPage(
  theme = bs_theme(version = 4,
                   bootswatch = "minty",
                   font_scale = 1.25),
  title = "Hutan Lindung Papua",
  tabPanel(
    title = "aaaa",
    icon = icon("home")
  ),

  # navbar pertama
  navbarPage(
    title = "Sosial Lingkungan Papua",
    navbarMenu(
      title = "home",
      icon = icon("home"),
      tabPanel(
        title = "Pengantar",
        fluidRow(
          column(
            width = 6,
            offset = 300,
            includeMarkdown(
              path = "teks/pengantar.Rmd"
            )
          ),
          column(
            width = 6,
            br(),
            br(),
            br(),
            tags$img(
              src = "https://wri-indonesia.org/sites/default/files/styles/large/public/16063131056_afe7d507d4_b.jpg?itok=aXO538D6",
              width = 600
            )
          )
        )
      )
    ),

    # Navbar Dataset
    navbarMenu(
      title = "Dataset",
      icon = icon("database"),
      
      tabPanel(
        title = "dataset",
        br(),
        h1("Dataset"),
        sidebarLayout(
          sidebarPanel(
            checkboxGroupInput(
              inputId = "prov_dataset",
              label = "Pilih Provinsi pada dataset",
              choices = prov,
              selected = prov
            ),
            width = 3
          ),
          mainPanel(
            DTOutput(
              outputId = "dataset"
            ),
            width = 9
          )
        )
      )
    ),

    # Navbar Visualisasi
    navbarMenu(
      title = "Visualisasi",
      icon = icon("chart-bar"),
      tabPanel(
        title = "Scatterplot",
        # pilih data untuk scatter
        sidebarLayout(
          sidebarPanel =
            sidebarPanel(
              h1("Scatterplot"),
              checkboxGroupInput(
                inputId = "prov_scatter",
                label = "Pilih provinsi untuk scatterplot",
                choices = prov,
                selected = prov
              ),
              selectInput(
                inputId = "var_scatterY",
                label = "Pilih Variabel Y untuk Scatterplot",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[3]
              ),
              selectInput(
                inputId = "var_scatterX",
                label = "Pilih Variabel X untuk Scatterplot",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[4]
              )
            ),
          mainPanel =
            mainPanel(
              plotOutput(
                outputId = "vis_scatter",
                width = "720px",
                height = "600px"
              )
            )
        )
      ),
      tabPanel(
        title = "Correlation Plot",
        # pilih data untuk scatter
        sidebarLayout(
          sidebarPanel =
            sidebarPanel(
              h1("Correlation Plot"),
              checkboxGroupInput(
                inputId = "prov_corr",
                label = "Pilih provinsi untuk Correlation Plot",
                choices = prov,
                selected = prov
              ),
              selectInput(
                inputId = "var_corr",
                label = "Pilih variabel untuk correlation plot",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[c(3:6)],
                multiple = T
              )
            ),
          mainPanel =
            mainPanel(
              plotOutput(
                outputId = "vis_corr",
                width = "720px",
                height = "600px"
              )
            )
        )
      ),
      tabPanel(
        title = "Histogram",
        # pilih data untuk scatter
        sidebarLayout(
          sidebarPanel =
            sidebarPanel(
              h1("Histogram"),
              checkboxGroupInput(
                inputId = "prov_hist",
                label = "Pilih provinsi untuk histogram",
                choices = prov,
                selected = prov
              ),
              selectInput(
                inputId = "var_hist",
                label = "Pilih variabel untuk histogram",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[3]
              )
            ),
          mainPanel =
            mainPanel(
              plotOutput(
                outputId = "vis_hist",
                width = "720px",
                height = "600px"
              )
            )
        )
      )
    ),


    # navbar RLB
    navbarMenu(
      title = "Regresi Linear",
      icon = icon("gears"),
      tabPanel(
        title = "Pengantar",
        fluidRow(
          column(
            width = 6,
            withMathJax(
              includeMarkdown(
                path = "teks/regresi_definisi.Rmd"
              )
            )
          ),
          column(
            width = 6,
            tags$img(
              src = "https://miro.medium.com/max/1280/1*QiU6DcP_r9qWLznMw0-M_Q.png",
              width = 600
            )
          )
        )
      ),
      tabPanel(
        title = "Pembuatan Model",
        sidebarLayout(
          sidebarPanel =
            sidebarPanel(
              checkboxGroupInput(
                inputId = "prov_reg",
                label = "Pilih provinsi untuk regresi",
                choices = prov,
                selected = prov
              ),
              selectInput(
                inputId = "var_regY",
                label = "Pilih Variabel Y untuk regresi",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[3]
              ),
              selectInput(
                inputId = "var_regX",
                label = "Pilih Variabel X untuk regresi",
                choices = nama_kolom[-c(1:2)],
                selected = nama_kolom[4],
                multiple = T
              )
            ),
          mainPanel =
            mainPanel(
              h1(
                "Koefisien Regresi"
              ),
              br(),
              DTOutput(
                outputId = "reg_coef"
              ),
              br(),
              h1(
                "Informasi Model Regresi"
              ),
              DTOutput(
                outputId = "reg_model"
              ),
              br(),
              h1(
                "ANOVA Model Regresi"
              ),
              DTOutput(
                outputId = "reg_ANOVA"
              )
            )
        )
      ),
      tabPanel(
        title = "Diagnostic",
        h1("Plot Diagnostik"),
        plotOutput(
          outputId = "vis_reg_diagnostik",
          width = "840px",
          height = "600px"
        ),
        tabsetPanel(
          id = "diagnostik",
          tabPanel(
            title = "Normalitas Residual",
            icon = icon("atom"),
            verbatimTextOutput(
              outputId = "diagnostik_normalitas"
            )
          ),
          tabPanel(
            title = "Varians Residual Konstan",
            icon = icon("atom"),
            verbatimTextOutput(
              outputId = "diagnostik_varians"
            )
          ),
          tabPanel(
            title = "Non-Multikolinearitas",
            icon = icon("atom"),
            verbatimTextOutput(
              outputId = "diagnostik_nonmultikol"
            )
          )
        )
      )
    )
  )
)
