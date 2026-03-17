library(magick)

giphy_frames <- image_read("giphy.gif") %>%
  image_coalesce()

group_1 <- giphy_frames %>%
  image_annotate(
    text = "CONGRATULATIONS!",
    gravity = "south",
    location = "+0+15",
    size = 30,
    color = "white",
    strokecolor = "black",
    strokewidth = 2,
    font = "Impact"
  )

group_2 <- giphy_frames %>%
  image_annotate(
    text = "WE PASSED STATS 220",
    gravity = "south",
    location = "+0+15",
    size = 30,
    color = "white",
    strokecolor = "black",
    strokewidth = 2,
    font = "Impact"
  )

group_3 <- giphy_frames %>%
  image_annotate(
    text = "YEAHHH",
    gravity = "south",
    location = "+0+15",
    size = 30,
    color = "white",
    strokecolor = "black",
    strokewidth = 2,
    font = "Impact"
  )

group_4 <- giphy_frames %>%
  image_annotate(
    text = "FINALY!",
    gravity = "south",
    location = "+0+15",
    size = 30,
    color = "white",
    strokecolor = "black",
    strokewidth = 2,
    font = "Impact"
  )

# Combine the captioned sections and speed up the background animation.
animation <- c(group_1, group_2, group_3, group_4) %>%
  image_animate(fps = 10)

# Save the final animated GIF.
animation %>%
  image_write(path = "my_animated_meme.gif")
