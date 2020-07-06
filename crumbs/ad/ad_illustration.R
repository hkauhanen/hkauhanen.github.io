make_animation <- function(logfile,
                           tmpfolder,
                           outfile,
                           fps = 50,
                           width = 1600,
                           height = 800,
                           pointsize = 28) {
  grid <- read.csv(logfile)
  png(file=paste0(tmpfolder, "/tmp%05d.png"), width=width, height=height, pointsize=pointsize)
  par(mfcol=c(1,2))

  # plot initial state for a while
  for (i in 1:(2*fps)) {
    plot_LL_space(grid[grid$iteration==0, ])
    plot_energy_until(grid, until_iteration=0)
  }

  # now set animation in motion
  for (i in unique(grid$iteration)) {
    plot_LL_space(grid[grid$iteration==i, ])
    plot_energy_until(grid, until_iteration=i)
  }

  # plot final state for a while
  for (i in 1:(2*fps)) {
    plot_LL_space(grid[grid$iteration==max(grid$iteration), ])
    plot_energy_until(grid, until_iteration=max(grid$iteration))
  }

  dev.off()
  system(paste0("avconv -r ", fps, " -i ", tmpfolder, "/tmp%05d.png -qscale 1 ", outfile))
}

plot_LL_space <- function(grid,
                          pch = 21,
                          bg = "",
                          cex = 1.2,
                          contours = TRUE,
                          lwd = 1.5,
                          lwd.cont = 1.5,
                          M1lim = c(350, 850),
                          M2lim = c(800, 1700)) {
  # prepare plot
  plot(M1~M2prime,
       grid,
       xlim=rev(M2lim),
       ylim=rev(M1lim),
       xlab="M2'",
       ylab="M1",
       type="n",
       main="Vowel space (mel)")
  if (bg == "") {
    bg <- rainbow(nrow(grid))
  }

  # plot contours
  if (contours) {
    segments(y0=M1lim[1], y1=M1lim[1], x0=M2lim[2], x1=M2lim[1], lwd=lwd.cont)
    x <- seq(from=M2lim[2], to=1150)
    lines(x, M1lim[2] - (M1lim[2]-M1lim[1])*((x - 1150)/(M2lim[2] - 1150))^2, lwd=lwd.cont)
    x <- seq(from=1150, to=M2lim[1])
    lines(x, M1lim[2] - (M1lim[2]-M1lim[1])*((x - 1150)/(M2lim[1] - 1150))^2, lwd=lwd.cont)
  }

  # plot vowels
  points(M1~M2prime, grid, pch=pch, cex=cex, lwd=lwd, bg=bg)
}

plot_energy_until <- function(grid,
                              until_iteration,
                              lwd = 1.2) {
  maxiter <- max(grid$iteration)
  maxenergy <- max(grid$energy)
  minenergy <- min(grid$energy)
  grid <- grid[, c("iteration", "energy")]
  grid <- grid[grid$iteration <= until_iteration, ]
  grid <- grid[!duplicated(grid), ]
  if (until_iteration == 0) {
    plot(energy~iteration, grid, type="n", log="xy", xlim=c(1, maxiter), ylim=c(minenergy, maxenergy), lwd=lwd, main="Energy evolution")
  } else {
    plot(energy~iteration, grid, type="l", log="xy", xlim=c(1, maxiter), ylim=c(minenergy, maxenergy), lwd=lwd, main="Energy evolution")
    points(energy~iteration, grid[nrow(grid),], pch=20)
  }
  text(x=0.8, y=minenergy, pos=4, labels=paste0("iteration: ", until_iteration), cex=0.9)
}
