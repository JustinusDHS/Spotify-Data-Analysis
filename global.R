library(flexdashboard)
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2) # pembuatan plot statis
library(plotly) # buat plot interaktif
library(glue) # utk setting tooltip
library(ggridges)
library(shiny)
library(shinydashboard)

spotify_songs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv')

spotify_clean <- spotify_songs %>% 
  select(-c(track_id, track_album_id, playlist_id, mode, key, playlist_subgenre, instrumentalness)) %>% 
  mutate(track_album_release_date=ymd(track_album_release_date))

anyNA(spotify_clean)
colSums(is.na(spotify_clean))

spotify_clean <- na.omit(spotify_clean)
dim(spotify_clean)
colSums(is.na(spotify_clean))

fav_artist <- spotify_clean %>% 
  group_by(track_artist) %>% 
  summarise(avg=round(mean(track_popularity),digits = 2)) %>% 
  top_n(15) %>% 
  arrange(desc(avg)) %>% 
  mutate(label= glue("Artist : {track_artist} 
                      Popularity : {avg} "))

fav_song <- spotify_clean %>% 
  group_by(track_name) %>% 
  summarise(avgs=round(mean(track_popularity))) %>% 
  top_n(15) %>% 
  arrange(desc(avgs)) %>% 
  mutate(label= glue("Song : {track_name} 
                      Popularity : {avgs} "))

valences <- spotify_clean %>% 
  group_by(track_album_name) %>% 
  summarise(avg=mean(valence)) %>% 
  top_n(10) %>% 
  arrange(desc(avg)) %>% 
  mutate(label= glue("{track_album_name} : {avg} "))