setwd("~/Documents/UCDavis/dib/MMETSP/")

transrate<-read.csv("assembly_evaluation_data/transrate_scores_trinity-2.2.0.csv")
transrate_reference<-read.csv("assembly_evaluation_data/transrate_reference_trinity2.2.0_v_ncgr.nt.csv")
transrate_reference_subset<-transrate_reference[,c(24:42)]
busco_scores_euk<-read.csv("assembly_evaluation_data/busco_scores_MMETSP_eukaryota_trinity2.2.0.csv")
colnames(busco_scores_euk)<-c("SampleName","Complete_eukaryotic","Fragmented_eukaryotic","Missing_eukaryotic","Total_eukaryotic","Complete_eukaryotic_BUSCO_perc")
busco_scores_protist<-read.csv("assembly_evaluation_data/busco_scores_MMETSP_protist_trinity2.2.0.csv")
colnames(busco_scores_protist)<-c("SampleName","Complete_protist","Fragmented_protist","Missing_protist","Total_protist","Complete_protist_BUSCO_perc")
reads<-read.table("assembly_evaluation_data/trimmomatic_reads_table.txt",sep="\t",header=TRUE)
unique_kmers<-read.csv("assembly_evaluation_data/unique_kmers.txt",sep="\t",header=TRUE)
colnames(unique_kmers)<-c("SampleName","Unique_kmers")
diginorm_stats<-read.csv("assembly_evaluation_data/fp_rate_diginorm.csv")
colnames(diginorm_stats)<-c("SampleName","num_reads_kept_diginorm","total_reads_before_diginorm","perc_kept_diginorm","num_kmers_reads_diginorm","fp_rate_diginorm")
MMETSP_ncbi<-read.csv("SraRunInfo_719.csv")
colnames(MMETSP_ncbi)
head(MMETSP_ncbi)
MMETSP_ncbi_subset<-MMETSP_ncbi[,c(1:8,10,11,13:16,19:22,24:30,42,43,45:47)]
colnames(MMETSP_ncbi_subset)
mmetsp_id<-read.csv("imicrobe/MMETSP_Table.csv")
imicrobe<-read.csv("imicrobe/Callum_FINAL_biosample_ids.csv")

head(transrate)
colnames(transrate)
dim(transrate)
head(transrate_reference)
colnames(transrate_reference)
dim(transrate_reference)
head(busco_scores_euk)
dim(busco_scores_euk)
head(busco_scores_protist)
dim(busco_scores_protist)
head(reads)
dim(reads)
head(unique_kmers)
dim(unique_kmers)
head(mmetsp_id)
dim(mmetsp_id)
head(MMETSP_ncbi)
dim(MMETSP_ncbi)
head(diginorm_stats)
dim(diginorm_stats)

names_matrix<-merge(MMETSP_ncbi,mmetsp_id,by="SampleName",all.y=TRUE)
dim(names_matrix)

#write.csv(names_matrix,"imicrobe/MMETSP_ncbi_id.csv")
evaluation_matrix_1<-merge(names_matrix,reads,by="Run",all.x=TRUE)
dim(evaluation_matrix_1)
evaluation_matrix_2<-merge(evaluation_matrix_1,transrate,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_2)
evaluation_matrix_3<-merge(evaluation_matrix_2,transrate_reference,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_3)
evaluation_matrix_4<-merge(evaluation_matrix_3,busco_scores_euk,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_4)
evaluation_matrix_5<-merge(evaluation_matrix_4,busco_scores_protist,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_5)
evaluation_matrix_6<-merge(evaluation_matrix_5,unique_kmers,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_5)
evaluation_matrix_7<-merge(evaluation_matrix_6,diginorm_stats,by="SampleName",all.x=TRUE)
dim(evaluation_matrix_7)
colnames(evaluation_matrix_7)
write.csv(evaluation_matrix_7,"assembly_evaluation_data/MMETSP_extra_evaluation_matrix.csv")
data<-evaluation_matrix_7[,c(1:9,11:12,14:17,20:23,25:30,42:43,45:79,82:104,126:142,147:162)]
colnames(data)
write.csv(data,"assembly_evaluation_data/MMETSP_all_evaluation_matrix.csv")
colnames(data)
data_reads<-data[,c(1,2,33,40:42,44:83,86:118)]
head(data_reads)
write.csv(data_reads,"assembly_evaluation_data/MMETSP_plotting_data.csv")
