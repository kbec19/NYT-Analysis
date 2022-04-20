#Getting Started
#Pulling in the PDF docs
#I have the PDF files in my working directory
#Using the "list.files()" function from the "pdftools" package, I can create a vector of PDF file names, 
#specifying only files that end in ".pdf".
#check the working directory

getwd()

#load libraries

library(pdftools)
library(readtext)
library(readr)
library(tm)
library(quanteda)
library(stringr)
library(MASS)

#extract the text for all pages

nyt_files <- list.files(path = ".", pattern = "pdf$")

#check first headlines

head(nyt_files)

#encoding for UTF-8 to allow the characters to match up for the importing of PDF files

Encoding(nyt_files) <- "UTF-8"

#check first headlines after changing encoding

head(nyt_files)

#This definitely helped with the issue of representing apostrophes like this: "Congressâ€™s"

#pull text and create object

nyt_text <- lapply(nyt_files, pdf_text)

#pull text and create corpus object using a VCorpus instead of Corpus command

nyt_corpus <- VCorpus(URISource(nyt_files),
                      readerControl = list(reader = readPDF))

#checking the length of the corpus (624)

length(nyt_corpus)

#create term document matrix

nyt_tdm <- TermDocumentMatrix(nyt_corpus, control = list(removePunctuation = TRUE, stopwords =  TRUE, tolower = TRUE))

#inspect tdm

inspect(nyt_tdm)

#I want to get a sense of my terms and frequencies, so I'll look at the terms using the "stringr" package. 
#For example, it looks like the word "veteran" appears in 86 of the documents with a word count of 210.

sum(str_detect(nyt_text, "veteran"))
sum(str_count(nyt_corpus, "veteran"))

#Refining further using the "stemming" option, and running the tdm() function, 
#the sparsity remains 98%, with  17,041 terms as compared to 25,648 in the un-stemmed version. 
#The problems is that stemming removes too many of the words I'll want to examine for sentiment analysis, 
#so I will not use that option at this time.

#I'll move on to some basic analysis using the "tm" package functions such as 
#finding the frequently occurring terms, starting with a threshold of 100:

findFreqTerms(nyt_tdm, lowfreq = 100, highfreq = Inf)

#I'll save the result and use it to subset the TDM as "ft", "frequent terms". 
#Looking at the top frequency words in decreasing order, 
#I can beging to get a feel for what questions I need to be ready to ask next.

ft <- findFreqTerms(nyt_tdm, lowfreq = 100, highfreq = Inf)
nyt_tdm_ft <- as.matrix(nyt_tdm[ft,]) 
sort(apply(nyt_tdm_ft, 1, sum), decreasing = TRUE)





