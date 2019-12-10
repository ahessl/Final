# Manipulating Dataframes that Contain a Variety of Data


Once in a blue moon, under the arc of a double rainbow, you might find yourself blessed with a perfectly formatted .csv file. However, once the rainbows fade and you realize that many files are in fact compiled and formatted in a way that makes you question your sanity, you begin your search for a way to read and manipulate the files to fit your needs. This is my story...

For my project, the .csv files that were in need of some TLC were collections of spring data collected over a large temporal and spatial scale. The files were initially unreadable because of the format of the title and the header, which were improperly spaced and did not correlate to each column of data. Due to the nature of the location and time of the data collections, differences in column names and values became a significant problem to overcome. For instance, some files listed the data collection time in GMT-04:00, while others listed it in GMT-05:00. Some files included the range of the spring, while other files omitted this info. Lastly, all files grouped date and time into the same column, so I took it upon myself to separate them into two distinct columns. 


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

To begin, _________________________ 

### Prerequisites

Within RStudio, run the following code to set stringsAsFactors to false, install and load the tidyverse (a collection of packages for data manipulation), and to set the CSV folder containing the .csv files as the path that will be used within the function. 
```
options(stringsAsFactors = F)
install.packages("tidyverse")
library("tidyverse")
path <- "CSV"
```

### Installing

A step by step series of examples that tell you how to get a development env running
Say what the step will be
```
Give the example
```
And repeat
```
until finished
```
End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

To utilize the function that manipulates the files, run the code below that sources the function and applies it to all of the .csv files within the CSV folder.
```
source("FunctionSpr.R")
SpringDat.R("CSV")
```
### Break down into end to end tests

Explain what these tests test and why
```
Give an example
```

### And coding style tests

Explain what these tests test and why
```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

Dropwizard - The web framework used
Maven - Dependency Management
ROME - Used to generate RSS Feeds

## Versioning

For the versions available, see the tags on this repository.

## Authors

Hartford Johnson

## License



## Acknowledgments

Appreciation to 
