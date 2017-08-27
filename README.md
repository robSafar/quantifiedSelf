# quantifiedSelf
Resources for analysing personal 'quantified self' data

## Notes

- Monitored data loads from iCloud Drive folder.
- Now integrates iOS Health/Activity data - downloaded archive loads from `~/Downloads` folder.
    - As this involves loading from a sizeable `.xml` file, processing might now take a couple of minutes. 
- The `.gitignore` file is used to omit the data and output from this repository. This is an open methodology project, rather than open data.

## Requirements

- [R](https://cran.r-project.org)
    - `ggplot2` package for plotting graphics
    - `knitr` package for weaving the R Markdown analysis
    - `lubridate`
    - `reshape2`
    - `XML`

