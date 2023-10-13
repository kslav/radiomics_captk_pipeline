# Radiomics CaPTk Pipeline
This is a MATLAB wrapper pipeline for executing The Cancer Imaging Phenomics Toolkit (CaPTk) on medical images to extract radiomic features and clean them up. This pipeline includes four scripts intended to be executed in the following order:
1. a_generate_captk_lists.m
* Purpose: To generate input text files for CaPTk
* Output: four text files with `.list ` extensions (one each for case IDs, image directories, segmentation directories, and output file names for storing extracted features)
3. b_runCaPTk_locally_script.m
* Purpose: To run CaPTk sequentially on a dataset with N samples
* Output: N csv files containing extracted features for each case
4. c_compile_features_script.m
* Purpose: To compile the N csv files from (3) into one spreadsheet (rows: cases, columns: features)
* Output: 1 csv file containing all N cases and their features
5. d_feature_processing_script.m
* Purpose: To process raw features by removing NaN and constant features, pruning undesired features, z-score normalizing, and sign-adjusting for increasing order of heterogeneity
* Output: 1 csv file containing processed features

# Prerequisites
1. CaPTk 1.9.0 (available at https://www.nitrc.org/frs/?group_id=1059)
2. Matlab 2018b
3. (Optional) For harmonization of processed features outputted from `d_feature_processing_script.m`, OPNestedComBat by *Horng et al.* is a suitable tool (available at https://github.com/hannah-horng/opnested-combat.git) 

# References
* Pati S, Singh A, Rathore S, et al. The Cancer Imaging Phenomics Toolkit (CaPTk): Technical Overview. Brainlesion. 2020;11993:380-394. doi:10.1007/978-3-030-46643-5_38 (link: https://doi.org/10.1007/978-3-030-46643-5_38)
* Singh A, Chitalia R, Kontos D. Radiogenomics in brain, breast, and lung cancer: opportunities and challenges. J Med Imaging (Bellingham). 2021;8(3):031907. doi:10.1117/1.JMI.8.3.031907 (link: https://doi.org/10.1117/1.jmi.8.3.031907)
* Horng H, Singh A, Yousefi B, et al. Improved generalized ComBat methods for harmonization of radiomic features. Sci Rep. 2022;12(1):19009. Published 2022 Nov 8. doi:10.1038/s41598-022-23328-0 (link: https://doi.org/10.1038/s41598-022-23328-0)

