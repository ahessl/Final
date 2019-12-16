SpringDat.R <- function(path) {
  glob.path <- paste0(path, "/*", ".csv")
  dataFiles <- lapply(Sys.glob(glob.path), read.csv, skip=1, header=T)
  datepat <- "\\d{2}\\/\\d{2}\\/\\d{2}"
  timepat <- "\\d{2}\\:\\d{2}\\:\\d{2} [AP]M"
  GMTpat <- "\\d{2}.\\d{2}"
  Temppat <- "Temp[\\.Â]+?[FC]"
  for (i in 1:length(dataFiles)){
    DTCol <- dataFiles[[i]][, grepl("Date.Time", names(dataFiles[[i]]))]
    dataFiles[[i]]$Date <- str_extract(DTCol,datepat)
    dataFiles[[i]]$Time <- str_extract(DTCol,timepat)
    GMTval <- str_extract(names(dataFiles[[i]])[grepl("Date.Time", names(dataFiles[[i]]))], GMTpat)
    timecol <- paste0("Time, GMT-", substr(GMTval,1,2),":",substr(GMTval,4,5))
    names(dataFiles[[i]])[names(dataFiles[[i]])=="Time"] <- timecol
    dataFiles[[i]] <- dataFiles[[i]][, !grepl("Date.Time", names(dataFiles[[i]]))]
    tempcolname <- names(dataFiles[[i]])[grepl("Temp", names(dataFiles[[i]]))]
    Fextrc <- str_extract(tempcolname, Temppat)
    is_F <- substr(Fextrc, nchar(Fextrc),nchar(Fextrc))=="F"
    if (is_F) {
      dataFiles[[i]] <- dataFiles[[i]] %>% 
        mutate(convert=(!!as.name(tempcolname) - 32) * 5/9 )
      Cextrc <- str_replace(Fextrc,"F","C")
      newcolname <- str_replace(tempcolname, Fextrc, Cextrc)
      dataFiles[[i]] <- dataFiles[[i]][, !grepl("Temp", names(dataFiles[[i]]))]
      names(dataFiles[[i]])[names(dataFiles[[i]])=="convert"] <- newcolname
    }
    dataFiles[[i]] <- dataFiles[[i]] %>% 
      select(!!as.name(names(dataFiles[[i]])[1]), Date, !!as.name(timecol), if(is_F)newcolname else tempcolname, everything())
  }
  filepattern <- "\\S+?_"
  locations <- c()
  for (i in 1:length(dataFiles)){
    locations <- c(locations,str_extract(basename(Sys.glob(glob.path)[i]),filepattern))
  }
  output <- list()
  for (unique_location in unique(locations)){
    tmp <- NULL
    for (i in 1:length(locations)){
      if(locations[i]==unique_location){
        tmp <- bind_rows(tmp,dataFiles[[i]])
      }
    }
    output[[unique_location]] <- tmp
  }
  dir.create("SpringData", showWarnings = F)
  for (i in 1:length(output)){
    filename <- paste0(substr(names(output)[i],1,nchar(names(output)[i])-1),".csv")
    write_csv(output[[i]], file.path("SpringData",filename))
  }
}
