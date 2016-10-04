


shinyUI(fluidPage(
    titlePanel("Rates of changes in survival"),

    sidebarLayout(
        sidebarPanel(
          tags$div(
  HTML("<ul><h3>Hyperparameter-tuning and filtering</h3>

              <li>  The substitution value of the lx = 0 hyperparameter has a substantial effect on the results.
                    When it is set to 0 (no substitution), the regression results ignore those years when the lx = 0</li>
              <li>  The fitting interval (selected years) has a pivotal impact on the results as well. Note that by default the selection does not give a warning if the selected years include years outside the range of available years.  Refer to the HMD  for the list of years of available data for each country. </li>
</ul>")
),
            fluidRow(
               column(3,
      selectInput("countries", label = h3("Country"),
        choices = list("Australia" = "AUS",
                       "Austria" = "AUT",
                       "Belarus" = "BLR",
                        "Belgium" =  "BEL",
                        "Bulgaria" = "BGR",
                         "Canada" = "CAN",
                        "Chile" = "CHL",
                        "Czech Republic" = "CZE",
                        "Denmark" = "DNK",
                        "Estonia" = "EST",
                        "Finland" = "FIN",
                        "France" = "FRATNP",
                        "Germany" = "DEUTNP",
                        "Hungary" = "HUN",
                        "Iceland" = "ISL",
                        "Ireland" = "IRL",
                        "Israel" = "ISR",
                         "Italy" = "ITA",
                         "Japan" = "JPN",
                         "Latvia" = "LVA",
                         "Lithuania" = "LTU",
                         "Luxembourg" = "LUX",
                         "Netherlands" = "NLD",
                         "New Zealand (N-M)" = "NZL_NM",
                         "Norway"="NOR",
                         "Poland" = "POL",
                         "Portugal" = "PRT",
                         "Russia" = "RUS",
                         "Slovakia" = "SVK",
                          "Slovenia" = "SVN",
                          "Spain" = "ESP",
                          "Sweden" = "SWE",
                          "Swizerland" = "CHE",
                          "Taiwan" = "TWE",
                          "United Kingdom" = "GBR_NP",
                          "USA" = "USA",
                          "Ukraine" = "UKR"
                           )
                  , selected = "FRATNP"))
                ),
             fluidRow(
                column(8,
                       sliderInput("years", "",
                                   min = 1751, max = 2015, step=1,animate=TRUE,sep="", value = c(1900, 2015))
                       )
                ),
            fluidRow(
                column(8,
                       numericInput("lx0",
                                    label =
        h3("Substitute a value for the survival function when it is 0."),
                                    value = 1e-9))
                ),
             fluidRow(
                column(5,
                       numericInput("min_age",
                                    label =
        h3("Minimal age of fitting"),
                                    value = 70))
                )
        ),
    mainPanel(
      plotOutput("coef_age")
        )
    )
    ))
