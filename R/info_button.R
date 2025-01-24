library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  leafletOutput("mymap")
)

server <- function(input, output, session) {

  observeEvent(input$my_easy_button, {
    print(input$my_easy_button)
  })

  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data=quakes,
                 clusterOptions = markerClusterOptions(),
                 clusterId = "quakesCluster") %>%
      addEasyButton(
        easyButton(
          icon     = "fa-info-circle",
          title    = "Meta data",
          position = "topright",
          id = "info_button",
            onClick = JS("
              function(btn, map) {
                Shiny.onInputChange('my_easy_button', 'frozen');
              }"
                         )
        # states = list(
        #   easyButtonState(
        #     stateName="unfrozen-markers",
        #     icon="ion-toggle",
        #     title="Freeze Clusters",
        #     onClick = JS("
        #       function(btn, map) {
        #         var clusterManager =
        #           map.layerManager.getLayer('cluster', 'quakesCluster');
        #         clusterManager.freezeAtZoom();
        #         btn.state('frozen-markers');
        #         Shiny.onInputChange('my_easy_button', 'frozen');
        #       }")
        #   ),
        #   easyButtonState(
        #     stateName="frozen-markers",
        #     icon="ion-toggle-filled",
        #     title="UnFreeze Clusters",
        #     onClick = JS("
        #       function(btn, map) {
        #         var clusterManager =
        #           map.layerManager.getLayer('cluster', 'quakesCluster');
        #         clusterManager.unfreeze();
        #         btn.state('unfrozen-markers');
        #         Shiny.onInputChange('my_easy_button', 'free');
        #       }")
        #   )
        # )
      ))
  })
}

shinyApp(ui, server)

library(shiny)
library(leaflet)
library(shinyBS)

points <- data.frame(cbind(latitude = rnorm(40) * 2 + 13, longitude  =
                             rnorm(40) + 48))


ui <- fluidPage(
  leafletOutput("mymap"),
  actionButton("action1","Show modal")
)

server <- function(input, output, session) {

  observeEvent(input$button_click, {
    showModal(modalDialog(
      title = "Important message",
      "This is an important message!"
    ))
  })

  output$mymap <- renderLeaflet({
    leaflet(options = leafletOptions(maxZoom = 18)) %>%
      addTiles() %>%
      addMarkers(lat = ~ latitude, lng = ~ longitude,
                 data = points,
                 popup= ~paste("<b>", latitude, longitude, "</b></br>",
                               actionButton("showmodal", "Show modal",
                                            onclick = 'Shiny.onInputChange(\"button_click\",  Math.random())')
                               )
                 )
  })
}

shinyApp(ui, server)


library(shiny)
library(leaflet)

points <- data.frame(cbind(id=seq(1,40),latitude = rnorm(40) * 2 + 13, longitude  =
                             rnorm(40) + 48))


ui <- fluidPage(
  leafletOutput("mymap"),
  actionButton("action1","Show modal")
)

server <- function(input, output, session) {

  observeEvent(input$mymap_marker_click, {
    id = input$mymap_marker_click$id
    showModal(modalDialog(
      title = "You selected a marker!",
      paste0("ID: ", id, ", lat: ", round(points$latitude[id==id],2),", lon: ", round(points$longitude[id==id],2))
    ))
  })

  output$mymap <- renderLeaflet({
    leaflet(options = leafletOptions(maxZoom = 18)) %>% addTiles() %>%
      addMarkers(lat = ~ latitude, lng = ~ longitude,
                 data = points,
                 popup= ~paste("<b>", latitude, longitude, "</b></br>", actionButton("showmodal", "Show modal", onclick = 'Shiny.onInputChange(\"button_click\",  Math.random())')))
  })
}


shinyApp(ui, server)

