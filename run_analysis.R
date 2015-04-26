library("readr")
library("dplyr")
#
# Download and extract zip data
#
fileurl='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dir.create('data')
download.file(fileurl,destfile='./data/data.zip')
unzip('./data/data.zip', files = NULL, list = FALSE, overwrite = TRUE,junkpaths = FALSE, exdir = './ext', unzip = "internal", setTimes = FALSE)
#
# xx_train is fixze widtj format; record is 8976 char long columns are 16 char long ==> create vector of 561 "16" 
#
nchar=8976
lcol=16
rec=rep(c(lcol),each=nchar/lcol)
#
# read file
#
yy_train=read.csv('./ext/UCI HAR Dataset/train/y_train.txt',header=FALSE)
xx_train=read_fwf('./ext/UCI HAR Dataset/train/x_train.txt',fwf_widths(rec))
yy_test=read.csv('./ext/UCI HAR Dataset/test/y_test.txt',header=FALSE)
xx_test=read_fwf('./ext/UCI HAR Dataset/test/x_test.txt',fwf_widths(rec))
sub_train=read.csv('./ext/UCI HAR Dataset/train/subject_train.txt',sep=" ",header=FALSE)
sub_test=read.csv('./ext/UCI HAR Dataset/test/subject_test.txt',sep=" ",header=FALSE)
activity=read.csv('./ext/UCI HAR Dataset/activity_labels.txt',sep=" ",header=FALSE)
feature=read.csv('./ext/UCI HAR Dataset/features.txt',sep=" ",header=FALSE)
#
# rename columns
#
colnames(sub_train)= c("Subject")
colnames(sub_test)= c("Subject")
colnames(activity) <- c("A_ID","Activity")
colnames(feature) <- c("F_ID","F_LABEL")
#
#  Create data set 
#
train=cbind(sub_train,yy_train,xx_train)
test=cbind(sub_test,yy_test,xx_test)
data=rbind(train,test)
#
#  rename dataset column (replace () by '' and '-' by '_')
#
colnames(data)=c("Subject","A_ID",as.vector(gsub('\\()','',gsub('-','_',feature$F_LABEL))))
#
#  merge activity to get label instead of ID
#
data_m=merge(activity,data,by="A_ID")
#
#  subset dataset to get mean and std
#
data_all=subset(data_m,select = c(2:3                            
                             ,004:009,044:049,084:089,124:129,164:169
                             ,204:205,217:218,230:231,243:244,256:257
                             ,269:274,348:353,427:432
                             ,506:507
                             ))
#
#  create dataset to get mean group by activity and subject
#data_all_mean=data_all %>% group_by(Activity,Subject) %>% summarise_each(z,funs(mean))
#
tmp=group_by(data_all,Activity,Subject)
data_all_mean=summarise_each(tmp,funs(mean))
#
# Write data set in files
#
write.table(data_all,'./activity_data.txt',sep=';',row.name=FALSE)
write.table(data_all_mean,'./mean_activity_data.txt',sep=';',row.name=FALSE)





















