args <- commandArgs(trailingOnly = TRUE)
file<-"output/dataset-completeness-Q1.csv"
file<-args[2]
factor<-as.numeric(args[3])

f<-read.table(file, sep=",", header=T)
f<-f[complete.cases(f), ]
attach(f)

#tapply(value, engine, mean)
a<-aov(value ~ engine)
#summary(a)
alpha<-0.05
t<-TukeyHSD(a, conf.level = 1-alpha)
options(scipen = 999)
options(digits=4)

#t
diff_cqels <- t$engine["querystreamer-cqels","diff"]
diff_csparql<--Inf
tryCatch(diff_csparql <- t$engine["querystreamer-csparql","diff"], error=function(e) diff_csparql<-Inf)
p_eq_cqels <- 1-t$engine["querystreamer-cqels","p adj"]
p_eq_csparql<-1
tryCatch(p_eq_csparql <- 1-t$engine["querystreamer-csparql","p adj"], error=function(e) p_eq_csparql<-1)
eq_cqels <- 1-p_eq_cqels > alpha
eq_csparql <- 1-p_eq_csparql > alpha
good_cqels <- eq_cqels || (factor * diff_cqels) < 0
good_csparql <- eq_csparql || (factor * diff_csparql) < 0

# Accept H0: equal means if p < 0.05, in this case ACCEPT iff adj_p > alpha, REJECT iff adj_p < alpha
# diff positive, means that QS has a higher value than cqels/csparql
#paste("eq_cqels:", eq_cqels, "(", p_eq_cqels, ")")
#paste("eq_csparql:", eq_csparql, "(", p_eq_csparql, ")")
#paste("diff_cqels:", diff_cqels)
#paste("diff_csparql:", diff_csparql)

# CSV-ize output
cat(sprintf(fmt="%s,%.4f,%.2f,%s,%s,%.4f,%.2f,%s\n",eq_cqels,1-p_eq_cqels,diff_cqels,good_cqels,eq_csparql,1-p_eq_csparql,diff_csparql,good_csparql,big.mark=" "))
#cat(paste(eq_cqels, ",", 1-p_eq_cqels, ",", diff_cqels, ",", eq_csparql, ",", 1-p_eq_csparql, ",", diff_csparql, "\n", sep=""))

#t[[1]][["p adj"]]
#t
#str(t[[1]][[2]])
