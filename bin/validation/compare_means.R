# TODO: param filename
f<-read.table("output/dataset-latency-Q3.csv", sep=",", header=T)
f<-f[complete.cases(f), ]
attach(f)

#tapply(value, engine, mean)
a<-aov(value ~ engine)
#summary(a)
alpha<-0.05
t<-TukeyHSD(a, conf.level = 1-alpha)
options(scipen = 999)

t
diff_cqels <- t$engine["querystreamer-cqels","diff"]
diff_csparql <- t$engine["querystreamer-csparql","diff"]
p_eq_cqels <- 1-t$engine["querystreamer-cqels","p adj"]
p_eq_csparql <- 1-t$engine["querystreamer-csparql","p adj"]
eq_cqels <- p_eq_cqels < alpha
eq_csparql <- p_eq_csparql < alpha

# Accept H0: equal means if p < 0.05
# diff positive, means that QS has a higher value than cqels/csparql
# TODO: debug
paste("eq_cqels:", eq_cqels, "(", p_eq_cqels, ")")
paste("eq_csparql:", eq_csparql, "(", p_eq_csparql, ")")
paste("diff_cqels:", diff_cqels)
paste("diff_csparql:", diff_csparql)

# CSV-ize output
cat(paste(eq_cqels, ",", p_eq_cqels, ",", eq_csparql, ",", p_eq_csparql, ",", diff_cqels, ",", diff_csparql, "\n", sep=""))

#t[[1]][["p adj"]]
#t
#str(t[[1]][[2]])
