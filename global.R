suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(stringi))
suppressPackageStartupMessages(library(textclean))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(wordcloud))


N_gram_table_list = list(readRDS("oneGramTable.rds"),
                         readRDS("twoGramTable.rds"), 
                         readRDS("threeGramTable.rds"), 
                         readRDS("fourGramTable.rds"), 
                         readRDS("fiveGramTable.rds"))

getLastTerms = function(inputString, num = 3, collapse = "_"){
        # Preprocessing
        inputString = gsub("[[:space:]]+", " ", stringr::str_trim(tolower(inputString)))
        
        # Now, ready!
        words = unlist(strsplit(inputString, " "))
        
        if (length(words) < num){
                words = c("this", "is", "weird", "shit")
                #stop("Number of Last Terms: Insufficient!")
        }
        
        from = length(words)-num+1
        to = length(words)
        tempWords = words[from:to]
        
        paste(tempWords, collapse = collapse)
}

getPredictionTable = function(userInput, resultTable, nGramTable, lamda = 1, result_length){
        #N_gram_table_list is in the global environment
        
        #Base case: hitting oneGramTable
        if (nGramTable == 1){
                stopifnot(nrow(resultTable) < result_length)
                current_NGramTable = copy(N_gram_table_list[[nGramTable]][order(-frequency)])
                one_gram_sum_freq = current_NGramTable[, sum(frequency)]
                current_NGramTable = current_NGramTable[!(lastTerm %in% resultTable[,Prediction])]
                current_NGramTable = current_NGramTable[, Score := lamda * frequency / one_gram_sum_freq]
                resultTable = rbindlist(list(resultTable, current_NGramTable[, .(lastTerm, Score)]))
                return(resultTable[,head(.SD, result_length)]) 
        }
        
        current_NGramTable = copy(N_gram_table_list[[nGramTable]][userInput])
        #skip any word that are already added from higher N-gram table(s)
        current_NGramTable = current_NGramTable[!(lastTerm %in% resultTable[,Prediction])] 
        current_NGramTable = current_NGramTable[, SScore := SScore * lamda]
        current_NGramTable = na.omit(current_NGramTable)
        resultTable = rbindlist(list(resultTable, current_NGramTable[, .(lastTerm, SScore)]))
        if (nrow(resultTable) >= result_length){
                resultTable = resultTable[order(-Score)]
                return(resultTable[,head(.SD, result_length)])  
        }
        
        userInput = stri_replace_first(str = userInput, replacement = "", regex = "[a-z]+\\_")
        resultTable = resultTable[order(-Score)]
        getPredictionTable(userInput, 
                           resultTable, 
                           nGramTable - 1, 
                           lamda = lamda * .4, 
                           result_length)
}

Capstone_Prediction = function(userInput, result_length = 10){
        if (userInput == "") return(data.table(Prediction = c("please", "enter", "something"), 
                                               Score = rep(10^-3,3)))
        #Pre-process
        userInput = replace_non_ascii(userInput, remove.nonconverted = TRUE)
        userInput = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", userInput)
        userInput =  replace_contraction(userInput)
        userInput =  gsub("[[:punct:][:blank:]]+", " ", userInput)
        userInput = tolower(userInput)
        if (stri_count_words(userInput) > 4){
                userInput =  getLastTerms(inputString = userInput, 
                                          num = 4, collapse = " ") #this does tolower as well
        }
        word_count = stri_count_words(userInput)
        userInput =  gsub(" ", "_", userInput)
        
        resultTable = data.table(Prediction = character(), 
                                 Score = numeric())
        getPredictionTable(userInput, 
                           resultTable, 
                           nGramTable = word_count + 1, 
                           result_length = result_length)
}