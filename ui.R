ui <- dashboardPage(skin = "green",
  dashboardHeader(title = "Spotify Data Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Popularity", tabName = "popularity", icon = icon("spotify")),
      menuItem(text = "Release Date", tabName = "date", icon = icon("far fa-calendar-alt")),
      menuItem(text = "Data", tabName = "data", icon = icon("server")),
      menuItem(text = "About", tabName = "about", icon = icon("fas fa-sliders-h"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "popularity",
              fluidRow(
                valueBox(
                  width = 4,
                  value = n_distinct(spotify_clean$track_artist),
                  subtitle = "Total Artist",
                  icon = icon("fas fa-users"),
                  color = "green" ),
                valueBox(
                  width = 4,
                  value = n_distinct(spotify_clean$track_album_name),
                  subtitle = "Total Album",
                  icon = icon("fas fa-file-audio"),
                  color = "green" ),
                valueBox(
                  width = 4,
                  value = n_distinct(spotify_clean$track_name),
                  subtitle = "Total Song",
                  icon = icon("fas fa-music"),
                  color = "green")
              ),
              
              fluidPage(
                box(width = 14,
                  title = "Top 15 Artists on Spotify",
                    plotlyOutput(outputId = "plot_artist"))),
              fluidPage(
                box(width = 13,
                    title = "Top 15 Songs on Spotify",
                    plotlyOutput(outputId = "plot_album")))
              
            ),
      tabItem(tabName = "date",
              fluidPage(
                fluidRow(
                  box(
                    width = 6,
                    height = 70,
                    background = "green",
                    selectInput(inputId = "select_artist",
                                label = "Select Artist :",
                                choices = unique(spotify_clean$track_artist),
                                selected = "Ed Sheeran")),
                  box(
                    width = 6,
                    height = 70,
                    background = "green",
                    dateRangeInput(inputId = "select_date",
                                  label = "Select range :",
                                  start = "1970-01-01", 
                                  end = "2020-12-30"))
                ),
                fluidRow(
                  box(
                    width = 12,
                    plotlyOutput(outputId = "duration")
                  )
                ),
                fluidRow(
                  box(
                    width = 12,
                    plotlyOutput(outputId = "valence")
                  )
                ),
                fluidRow(
                  box(
                    width = 12,
                    plotlyOutput(outputId = "workout")
                  )
                )
              )
              ),
      tabItem(tabName =  "data",
              fluidRow(
                box(width = 12,
                    title = "Data Spotify",
                    DT::dataTableOutput(outputId = "table"))
              )),
      tabItem(
        tabName = "about",
        fluidPage(
          h1("Data Visualization Capstone"),
          h3("Spotify Data Analysis"),
          h5("By ", a("Justinus Dedy Handyka Simanjuntak", href = "https://www.linkedin.com/in/justinusdhs/")),
          h2("Dataset"),
          p("The data comes from Spotify via the spotifyr package, published on ", 
            a("Github", href = "https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-01-21/readme.md#spotify_songscsv")),
          h2("Code"),
          p("Find out my code in ", a("GitHub", href = "https://github.com/JustinusDHS"))
                  )
      )
      
      
    )
  )
)