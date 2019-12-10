# Manipulating _.csv_ Files that Contain a Variety of Data in Different Formatts 


Once in a blue moon, under the arc of a double rainbow, you might find yourself blessed with a perfectly formatted .csv file. However, once the rainbows fade and you realize that many files are in fact compiled and formatted in a way that makes you question your sanity, you begin your search for a rational way to read and manipulate the files to fit your needs. This is my story...

For my project, the .csv files that were in need of some TLC were collections of spring data collected over a large temporal and spatial scale. The files were initially unreadable because of the format of the title and the header, which were improperly spaced and did not correlate to each column of data. Due to the nature of the location and time of the data collections, differences in column names and values became a significant problem to overcome. For instance, some files listed the data collection time in GMT-04:00, while others listed it in GMT-05:00. Some files included the range of the spring, while other files omitted this info and had an overall fewer number of columns. Lastly, all of the files grouped date and time into the same column, so I took it upon myself to separate them into two distinct columns. 


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

## Running the tests

Explain how to run the automated tests for this system

To utilize the function that manipulates the files, we must first run the entire function (using the console of RStudio) to asign it our desired name. This allows us to later call upon this function by simply typing the name we have assigned it. To do this, open the "FunctionSpr.R" file in RStudio. Select the entire function and run it, making sure that the name "SpringDat.R" has shown up in the _Functions_ portion of the R _Environment_ in the upper right-hand corner. 

run the code below that sources the function and applies it to all of the .csv files within the CSV folder.
```
source("FunctionSpr.R")
SpringDat.R("CSV")
```
This command will run and edit each file individually, then export it to a newly created folder titled "SpringData" within the working directory. The newly edited files will keep their original filenames.

### Breaking it Down

_____Explain each section of the function to list what it's used for._____
```
Give an example
```

## Built With

RStudio


## Authors

Hartford Johnson
