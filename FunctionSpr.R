SpringDat.R <- function(path) {
  #Applies the function to SpringDat.R
  glob.path <- paste0(path, "/*", ".csv")
  #Sets all of the .csv files in the path (CSV folder) to the name glob.path
  dataFiles <- lapply(Sys.glob(glob.path), read.csv, skip=1, header=T)
  #reads all of the files, skips the first row, and keeps header as true
  datepat <- "\\d{2}\\/\\d{2}\\/\\d{2}"
  #creates and names pattern to format date column
  timepat <- "\\d{2}\\:\\d{2}\\:\\d{2} [AP]M"
  #creates and names pattern to format time column
  GMTpat <- "\\d{2}.\\d{2}"
  #creates and names pattern to format "GMT" in time column
  Temppat <- "Temp[\\.Â]+?[FC]"
  #creates and names pattern used to ignore special character (for degree symbol) if computer doesn't automatically ignore it
  for (i in 1:length(dataFiles)){
    #for loop that will run each file in the CSV folder
    DTCol <- dataFiles[[i]][, grepl("Date.Time", names(dataFiles[[i]]))]
    #selects and applies "Date.Time column to "DTcol"
    dataFiles[[i]]$Date <- str_extract(DTCol,datepat)
    #extracts the "date" portion of the column and applies it to the file
    dataFiles[[i]]$Time <- str_extract(DTCol,timepat)
    #extracts the "time" portion of the column and applies it to the file
    GMTval <- str_extract(names(dataFiles[[i]])[grepl("Date.Time", names(dataFiles[[i]]))], GMTpat)
    #extracts the GMT value from the "Date.Time" column and applies it to "GMTval"
    timecol <- paste0("Time, GMT-", substr(GMTval,1,2),":",substr(GMTval,4,5))
    #formatts time column to _Time GMT-0*:00_    
    names(dataFiles[[i]])[names(dataFiles[[i]])=="Time"] <- timecol
    #applies new time formatt to time column     
    dataFiles[[i]] <- dataFiles[[i]][, !grepl("Date.Time", names(dataFiles[[i]]))]
    #drops the original "Date.Time" column
    tempcolname <- names(dataFiles[[i]])[grepl("Temp", names(dataFiles[[i]]))]
    #sets the "Temp" column to "tempcolname"
    Fextrc <- str_extract(tempcolname, Temppat)
    #applies the temp pattern to temp columns, names the command Fextrc
    is_F <- substr(Fextrc, nchar(Fextrc),nchar(Fextrc))=="F"
    #determines whether temp values are in F or C, named "is_F"
    if (is_F) {
    #if statement to be used if temp values are in F.
      dataFiles[[i]] <- dataFiles[[i]] %>% 
        mutate(convert=(!!as.name(tempcolname) - 32) * 5/9 )
        #converts the values within the column to celcius (creates new column in the process)
      Cextrc <- str_replace(Fextrc,"F","C")
      #command to replace the F in the column name to a C, set to Cextrc
      newcolname <- str_replace(tempcolname, Fextrc, Cextrc)
      #command to convert F in column names to C where applicable, set to "newcolname"
      dataFiles[[i]] <- dataFiles[[i]][, !grepl("Temp", names(dataFiles[[i]]))]
      #removes pre-conversion "Temp" columns 
      names(dataFiles[[i]])[names(dataFiles[[i]])=="convert"] <- newcolname
      #command run to convert "F" in column names to "C"
    }
    dataFiles[[i]] <- dataFiles[[i]] %>% 
      select(!!as.name(names(dataFiles[[i]])[1]), Date, !!as.name(timecol), if(is_F)newcolname else tempcolname, everything())
      #adds correct GMT value to the column name, in the format previously defined by "timecol". Important since creating new columns removed GMT value.
  }
  filepattern <- "\\S+?_"
  #creates a pattern that identifies the name of the sample location before the first underscore in the name  
    locations <- c()
    #sets "locations" as a command that returns a vector of an object
  for (i in 1:length(dataFiles)){
  #runs all files in CSV folder through a for loop
    locations <- c(locations,str_extract(basename(Sys.glob(glob.path)[i]),filepattern))
    #extracts the site names of each file, names the command "locations"
  }
  output <- list()
  #lists vectors containing other objects, sets it to "output"
  for (unique_location in unique(locations)){
  #runs for loop for all unique locations
    tmp <- NULL
    #set new tmp variable to NULL
    for (i in 1:length(locations)){
    #runs for loop for all unique site names in folder
      if(locations[i]==unique_location){
      #run if statement for locations whose name matches other files
        tmp <- bind_rows(tmp,dataFiles[[i]])
        #command to merge files from the same study site into one file set as the name "tmp"
      }
    }
    output[[unique_location]] <- tmp
    #runs the previous command to append all files from same location, outputs the files
  }
  dir.create("SpringData", showWarnings = F)
  #creates new directory called "SpringData"
  for (i in 1:length(output)){
  #runs for loop for each file in working directory
    filename <- paste0(substr(names(output)[i],1,nchar(names(output)[i])-1),".csv")
    #pastes the name of the study site, removing spaces and adding ".csv" to the end of the name
    write_csv(output[[i]], file.path("SpringData",filename))
    #outputs the modified files into the newly created folder "SpringData"
  }
}
