SpringDat.R <- function(path) {
  glob.path <- paste0(path, "/*", ".csv")
  dataFiles <- lapply(Sys.glob(glob.path), read.csv, skip=1, header=T)
  datepat <- "\\d{2}\\/\\d{2}\\/\\d{2}"
  timepat <- "\\d{2}\\:\\d{2}\\:\\d{2} [AP]M"
  GMTpat <- "\\d{2}.\\d{2}"
  Temppat <- "Temp\\.{3}[FC]"
  for (i in 1:length(dataFiles)){
    #separate 'Date.Time' into two separate columns
    DTCol <- dataFiles[[i]][, grepl("Date.Time", names(dataFiles[[i]]))]
    dataFiles[[i]]$Date <- str_extract(DTCol,datepat)
    dataFiles[[i]]$Time <- str_extract(DTCol,timepat)
    GMTval <- str_extract(names(dataFiles[[i]])[grepl("Date.Time", names(dataFiles[[i]]))], GMTpat)
    #column name should look like "Time GMT-04:00"
    timecol <- paste0("Time, GMT-", substr(GMTval,1,2),":",substr(GMTval,4,5))
    names(dataFiles[[i]])[names(dataFiles[[i]])=="Time"] <- timecol
    #drop original Date-Time column
    dataFiles[[i]] <- dataFiles[[i]][, !grepl("Date.Time", names(dataFiles[[i]]))]
    #if Temp is in F, convert values and column name to C
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
  #create a new folder, save files to folder
  dir.create("SpringData", showWarnings = F)
  for (i in 1:length(dataFiles)){
    write_csv(dataFiles[[i]], file.path("SpringData", basename(Sys.glob(glob.path)[i])))
  }
}
