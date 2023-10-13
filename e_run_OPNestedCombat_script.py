import pandas as pd
import neuroCombat as nC
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
from scipy.stats import ranksums, ttest_ind, ttest_rel, ks_2samp
import os
import sys
import numpy as np
from itertools import permutations
# you may have to point python to the path where OPNested ComBat is located
sys.path.append('/Users/Kalina/Documents/CBIG/Code/opnested-combat-main/Functions')
import OPNestedComBat as nested
from sklearn.cluster import KMeans as kmeans

### The parts you need to change are all the file paths, spreadhsheet names, and results saving stuff
### Make sure you remove features that have a constant value for all cases as they throw an error!

############# USER INPUT #####################

#establish paths where your spreadsheets (features, clnical, and batch) and code are located
datapath = "Z:\home\slavkovk\project_DCIS\CaPTk_experiments\"
codepath = "Z:\home\slavkovk\Code\opnested-combat-main\"
#this is the spreadsheet that contains your z-scored, sign-adjusted, generally processed features (xls format)
datfile = "first_postcontrast_features_processed_n295_notfiltered.xls"
sheetname_dat = 'processed_noHarm_features'
#this is the spreadsheet that contains your clinical and batch information in two different spreadsheets (xls format)
covfile = "first_postcontrast_allData_n295.xls"
sheetname_cov='clinical covars numeric'
sheetname_batch = 'batch_effects'
#name of the file where your harmonized features will be saved
resultsfolder = "Results"
resultsfile = "features_DCIS_NestedComBat.csv"
#define which clinical variables are categorical and which are continuous
categorical_cols = []
continuous_cols = []

############# CODE EXECUTES BELOW ##############

#read in feature data (change the sheet name as needed)
data_df = pd.read_excel(datapath+datfile, sheet_name=sheetname_dat)
data_df = data_df.rename(columns={"SubjectID": "case"})
data_df.to_csv(codepath+"Results"+"data_df_check_vb.csv")


#read in clinical data (change the sheet name as needed)
covars_df = pd.read_excel(path+covfile, sheet_name=sheetname_cov)
#drop the 'case' column so that you only have the clinical values
covars_df = covars_df.drop(labels='case',axis=1)


#read in batch effects to control for
batch_df = pd.read_excel(path+covfile, sheet_name=sheetname_batch)
batch_df = batch_df.drop(labels='case',axis=1)
#write any batch pre-processing you want to do for your specific example here
batch_df.resolution = kmeans(n_clusters=3, random_state=0).fit(batch_df.resolution.to_numpy().reshape(-1,1)).labels_
batch_df["field_strength"] = (batch_df["field_strength"] <= 1.5).astype(int)
#define the batch variables here
batch_list = batch_df.keys().tolist()
#combine the clinical covars and batch effects into one dataframe called 'covars'
covars = pd.concat([covars_df,batch_df],axis=1) 

#remove nans from any clinical and batch effects (cases that are missing this information)
splitlen = len(batch_list)+len(categorical_cols)+len(continuous_cols)
a = pd.concat([covars,data_df],axis=1).dropna()
#a.to_csv(codepath+"Results"+"/a_check_vb.csv")
print(splitlen)
covars = a.iloc[:, :splitlen].reset_index(drop=True)
data_df = a.iloc[:, splitlen :].reset_index(drop=True)
caseno = data_df['case']
data_df = data_df.drop(labels='case',axis=1)
dat = data_df.T.apply(pd.to_numeric)
#dat.to_csv(codepath+"Results"+"/dat_final_check_vb.csv")

# # FOR GMM COMBAT VARIANTS:
# # Adding GMM Split to batch effects
gmm_df = nested.GMMSplit(dat, caseno, codepath)
#gmm_df.to_csv(codepath+resultsfolder+"/gmm_check_vb.csv")
#gmm_df_merge = covars_df.merge(gmm_df, right_on='Patient',left_on='resolution')
#gmm_df_merge.to_csv(codepath+"Results"+"/gmm_merge_check_vb.csv")
covars['GMM'] = gmm_df['Grouping'] #gmm_df_merge['Grouping']
#covars.to_csv(codepath+"Results"+"/covars_final_check_vb.csv")

#print your categorical and batch info as a final check
print(categorical_cols)
print(continuous_cols)
print(batch_list)


# EXECUTING OPNESTED-GMM COMBAT
# Here we add the newly generated GMM grouping to the list of categorical variables that will be protected during
# harmonization
categorical_cols = categorical_cols + ['GMM']

# Completing Nested ComBat
output_df = nested.OPNestedComBat(dat, covars, batch_list, datapath+resultsfolder, categorical_cols=categorical_cols,
                                  continuous_cols=continuous_cols)
#write the results to a csv file
write_df = pd.concat([caseno, output_df], axis=1) 
write_df.to_csv(datapath+resultsfolder+'/'+resultsfile)

#Compute the AD test p-values to measure harmonziation performance
test = dat.T
#print("dat.T.shape = ",test.shape)
#print("output_df.shape = ",output_df.shape)
#print("covars.shape = ",covars.shape)
#print("batch_list = ",batch_list)

nested.feature_ad(dat.T, output_df, covars, batch_list, datapath+resultsfolder)
# Plot kernel density plots to visualize distributions before and after harmonization
nested.feature_histograms(dat.T, output_df, covars, batch_list, datapath+resultsfolder)
