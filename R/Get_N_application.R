Get_N_application <- function (expID, treatment){
data(Fertilisation)
result <- Fertilisation [(Fertilisation$ExpID ==expID),]
result <- result[(result$Treatment==treatment) | (result$Treatment =="ALL"),]

if(dim(result)[1] ==0){
  result <- data.frame (Date = NA, TotalN = NA)
}
else{
for (i in 1: dim(result)[1]){
  if(result$Fertilizer[i] == "Ammonium nitrate" || result$Fertilizer[i] == "" || result$Fertilizer[i] == "Unknown"){
    result$TotalN[i] <- result$Amount[i]*0.34
  }else{
        if(result$Fertilizer[i] == "Aqua ammonia"){
         result$TotalN[i] <- result$Amount[i]*0.205
        }
        if(result$Fertilizer[i] == "Ammonium sulphate"){
          result$TotalN[i] <- result$Amount[i]*0.202
        }
        if(result$Fertilizer[i] == "Ammonium nitrate - sulphate"){
          result$TotalN[i] <- result$Amount[i]*0.0
        }
        if(result$Fertilizer[i] == "Anhydrous ammonia"){
          result$TotalN[i] <- result$Amount[i]*0.82
        }      
      }  
  }
result <- subset (result, select = c("Date", "TotalN"))
}
return(result)
}
