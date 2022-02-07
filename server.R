server <- function(input, output){
  output$plot_artist <- renderPlotly({
    plot1 <- ggplot(data = fav_artist, aes(x = avg, 
                                           y = reorder(track_artist, avg),  # reorder(A, berdasarkan B)
                                           text = label)) + # untuk tooltip
      geom_col(aes(fill = avg)) +
      scale_fill_gradient(low="seagreen1", high="lightseagreen") +
      labs(title = NULL,
           x = "Popularity",
           y = NULL) +
      theme_replace() +
      theme(legend.position = "none")
    
    ggplotly(plot1, tooltip = "text")
    
  })
  
  output$plot_album <- renderPlotly({
    plot2 <- ggplot(data = fav_song, aes(x = avgs, 
                                         y = reorder(track_name, avgs),  # reorder(A, berdasarkan B)
                                         text = label)) + # untuk tooltip
      geom_col(aes(fill = avgs)) +
      scale_fill_gradient(low="mediumspringgreen", high="lightseagreen") +
      labs(title = NULL,
           x = "Popularity",
           y = NULL) +
      theme_replace() +
      theme(legend.position = "none")
    
    ggplotly(plot2, tooltip = "text")
    
  })
  
  output$duration <- renderPlotly({
    durasi <- spotify_clean %>% 
      filter(track_artist == input$select_artist) %>% 
      filter(track_album_release_date >= input$select_date[1] & track_album_release_date <= input$select_date[2]) %>% 
      group_by(track_name) %>% 
      summarise(avg = mean(duration_ms)) %>% 
      top_n(5) %>% 
      arrange(desc(avg)) %>% 
      mutate(label= glue("Song : {track_name} 
                      Duraton : {avg} in ms "))
    
    plot3 <-  ggplot(durasi, aes(reorder(track_name, + avg), avg, text=label))+
      geom_bar(stat = "identity", fill = "lightseagreen", col = "grey10")+
      coord_flip()+
      labs(x = NULL ,
           y = "Score", 
           title = paste("Top 5", input$select_artist, "Songs by Duration"))+
      geom_text(aes(label = format(as.POSIXct(Sys.Date())+avg/1000, "%M:%S"), y = avg/2))+
      theme_gray() +
      theme(legend.position = "none") 
    
    ggplotly(plot3, tooltip = "text")
    
  })
  
  output$valence <- renderPlotly({
    artisttt <- spotify_clean %>% 
      filter(track_artist == input$select_artist) %>% 
      filter(track_album_release_date >= input$select_date[1] & track_album_release_date <= input$select_date[2]) %>%
      group_by(track_name) %>% 
      summarise(avg=mean(valence),
                avgs=mean(energy)) %>% 
      mutate(label= glue("Song : {track_name} 
                        Valence : {avg}
                        Energy :{avgs} "))
    
    plot4 <- ggplot(artisttt, aes(x = avg, y = avgs, color = track_name,text=label)) +
      geom_jitter() +
      geom_vline(xintercept = 0.5) +
      geom_hline(yintercept = 0.5) +
      scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
      annotate('text', 0.25 / 2, 0.95, label = "Turbulent/Angry", fontface = "bold") +
      annotate('text', 1.75 / 2, 0.95, label = "Happy/Joyful", fontface = "bold") +
      annotate('text', 1.75 / 2, 0.05, label = "Chill/Peaceful", fontface = "bold") +
      annotate('text', 0.25 / 2, 0.05, label = "Sad/Depressing", fontface = "bold")+
      labs(x = "Valence",
           y = "Energy",
           title = paste(input$select_artist, "Songs by Mood"))+
      theme_gray() 
    
    ggplotly(plot4, tooltip = "text")
    
    
  })
  
  output$workout <- renderPlotly({
    workout <- spotify_clean %>% 
      filter(track_artist == input$select_artist) %>% 
      filter(track_album_release_date >= input$select_date[1] & track_album_release_date <= input$select_date[2]) %>%
      group_by(track_name) %>% 
      summarise(avg=mean(danceability),
                avgs=mean(energy)) %>% 
      mutate(label= glue("Song : {track_name} 
                        Valence : {avg}
                        Energy :{avgs} "))
   
    
    plot5 <- ggplot(workout, aes(x= avg, y= avgs, color= track_name, text=label)) +
      geom_jitter(show.legend= FALSE) +
      scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
      labs(x = "Danceability",
           y = "Energy",
        title = paste(input$select_artist, "Songs by Workout Vibes")) +
      theme_gray()
    ggplotly(plot5, tooltip = "text")
    
  })
  
  output$table <- DT::renderDataTable(spotify_clean,
                                      options=list(scrollX=T,
                                                   scrollY=T))
  
}