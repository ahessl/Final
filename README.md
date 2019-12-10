# Manipulating _.csv_ Files that Contain a Variety of Data in Different Formatts 


Once in a blue moon, under the arc of a double rainbow, you might find yourself blessed with a perfectly formatted .csv file. However, you awake from your dream and remember that many files are in fact compiled and formatted in ways that make you question your sanity. Thus, you begin your search for a rational way to read and manipulate the files to fit your needs.

For my project, the .csv files that were in need of some TLC were collections of spring data collected over a large temporal and spatial scale. The files were initially unreadable because of the format of the title and the header, which were improperly spaced and did not correlate to each column of data. Due to the nature of the location and time of the data collections, differences in column names and values became a significant problem to overcome. For instance, some files listed the data collection time in GMT-04:00, while others listed it in GMT-05:00. Some files included the _range_ of the spring, while other files omitted this info and thus had fewer columns. Lastly, all of the files grouped 'Date' and 'Time' into the same column, so I took it upon myself to separate them into two distinct columns. 


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for access to the code, files, and outputs.

To begin, we want to select _Clone_ to download a ZIP of my repository. Save the folder to whichever directory that you would like to work in. Please note that the .csv files must remain inside of the folder titled "CSV" that is located in the working directory along with "FunctionSpr.R". Then,---------------- 

### Prerequisites

Within RStudio, run the following code to set stringsAsFactors to false, install and load the tidyverse (a collection of packages for data manipulation), and to set the CSV folder containing the .csv files as the path that will be used within the function. 
```
options(stringsAsFactors = F)
install.packages("tidyverse")
library("tidyverse")
path <- "CSV"
```

### Installing

A step by step series of examples that tell you how to get a development environment running. 
Say what the step will be. 
```
Give the example
```
And repeat
```
until finished
```

## Running the Code

Explain how to run the automated tests for this system

To utilize the function that manipulates the files, we must first run the entire function (using the console of RStudio) to asign it our desired name. This allows us to later call upon this function by simply typing the name we have assigned it. To do this, open the "FunctionSpr.R" file in RStudio. Select the entire function and run it, making sure that the name "SpringDat.R" has shown up in the _Functions_ portion of the R _Environment_ in the upper right-hand corner. 

run the code below that sources the function and applies it to all of the .csv files within the CSV folder.
```
source("FunctionSpr.R")
SpringDat.R("CSV")
```
This command will run and edit each file individually, then export it to a newly created folder titled "SpringData" within the working directory. The newly edited files will keep their original filenames.

### Breaking it Down

The very first line of code renames the function of the path (in this case the path being = to CSV) to _SpringDat.R_, which can then be called upon from the command line at a later time. The subsequent code allows us to read the _.csv_ files while also skipping over the unnecessary title. Patterns are assigned to names so that they may be called upon at a later time to edit the 'Date.Time' columns.
```
SpringDat.R <- function(path) {
   glob.path <- paste0(path, "/*", ".csv")
   dataFiles <- lapply(Sys.glob(glob.path), read.csv, skip=1, header=T)
   datepat <- "\\d{2}\\/\\d{2}\\/\\d{2}"
   timepat <- "\\d{2}\\:\\d{2}\\:\\d{2} [AP]M"
   GMTpat <- "\\d{2}.\\d{2}"
   Temppat <- "Temp\\.{3}[FC]"
```
The next part of the function utilizes some of the patterns that were previously created to separate the 'Date.Time' column into two separate columns.
```
   for (i in 1:length(dataFiles)){
      DTCol <- dataFiles[[i]][, grepl("Date.Time", names(dataFiles[[i]]))]
      dataFiles[[i]]$Date <- str_extract(DTCol,datepat)
      dataFiles[[i]]$Time <- str_extract(DTCol,timepat)
      GMTval <- str_extract(names(dataFiles[[i]])[grepl("Date.Time", names(dataFiles[[i]]))], GMTpat)
```
The next part of the function creates a new time column with the formatt of _Time GMT-04:00_.
```
      timecol <- paste0("Time, GMT-", substr(GMTval,1,2),":",substr(GMTval,4,5))
      names(dataFiles[[i]])[names(dataFiles[[i]])=="Time"] <- timecol
```
The next part of the function drops the original _Date.Time_ column, which is uneccessary to keep since separate columns were created for both 'Date' and 'Time'.
```
      dataFiles[[i]] <- dataFiles[[i]][, !grepl("Date.Time", names(dataFiles[[i]]))]
```
The next part of the function checks to see if the _Temp_ column is listed in fahrenheit or celcius. If the column name includes '°F', the temp values are converted to celcius and the column name is edited so that F is replaced by C. The next part of the function (where it says "dir.create") creates a new folder named "SpringData" where outputs of each individual file will be sent.
```
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
        select(!!as.name(names(dataFiles[[i]])[1]), Date, !!as.name(timecol), if(is_F)newcolname else tempcolname,    everything())
    }
   dir.create("SpringData", showWarnings = F)
      for (i in 1:length(dataFiles)){
       write_csv(dataFiles[[i]], file.path("SpringData", basename(Sys.glob(glob.path)[i])))
    }
}
```

## Built With

RStudio


## Authors

Hartford Johnson
