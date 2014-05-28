library(sqldf)
new <- read.csv("/Users/dlebauer/Documents/My Box Files/EBI-modeling/BETYdb/test-csv-files/demo/upload_candidate_test_with_sites.csv")
old <- read.csv("/Users/dlebauer/Documents/My Box Files/EBI-modeling/BETYdb/test-csv-files/demo/upload_candidate_test.csv")
head(old)

library(lubridate)
old$date <- ymd(old$date)
new$date <- mdy(new$date)

join <- sqldf("select new.site, old.cultivar, old.date, old.dateloc from new join old on new.yield = old.yield and new.date = old.date")

