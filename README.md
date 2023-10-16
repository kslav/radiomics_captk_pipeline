# Radiomics CaPTk Pipeline
This is a MATLAB wrapper pipeline for executing The Cancer Imaging Phenomics Toolkit (CaPTk) (*Pati et al.*)on medical images to extract radiomic features (See *Singh et al.* for a nice review). This pipeline includes four scripts intended to be executed in the following order:
1. `a_generate_captk_lists.m`
  * Purpose: To generate input text files for CaPTk
  * Output: four text files with `.list ` extensions (one each for case IDs, image directories, segmentation directories, and output file names for storing extracted features)
2. `b_runCaPTk_locally_script.m`
  * Purpose: To run CaPTk sequentially on a dataset with N samples
  * Output: N csv files containing extracted features for each case
3. `c_compile_features_script.m`
  * Purpose: To compile the N csv files from (3) into one spreadsheet (rows: cases, columns: features)
  * Output: 1 csv file containing all N cases and their features
4. `d_feature_processing_script.m`
  * Purpose: To process raw features by removing NaN and constant features, pruning undesired features, z-score normalizing, and sign-adjusting for increasing order of heterogeneity
  * Output: 1 csv file containing processed features
Note: It is ideal to harmonize processed features to remove batch effects. See *Horng et al.* for more information.

# Prerequisites
1. CaPTk 1.9.0 (available at https://www.nitrc.org/frs/?group_id=1059)
2. MATLAB 2018b
3. (Optional) For harmonization of processed features outputted from `d_feature_processing_script.m`, OPNestedComBat by *Horng et al.* is a suitable tool (available at https://github.com/hannah-horng/opnested-combat.git)

# Example from I-SPY2
In the `Example` folder you will find one MRI and a corresponding tumor segmentation from the I-SPY2 trial, made publicly available on The Cancer Imaging Archive (TCIA), as well as the default parameter file from the CaPTk installation. 

References for I-SPY2:
1. Li, W., Newitt, D. C., Gibbs, J., Wilmes, L. J., Jones, E. F., Arasu, V. A., Strand, F., Onishi, N., Nguyen, A. A.-T., Kornak, J., Joe, B. N., Price, E. R., Ojeda-Fournier, H., Eghtedari, M., Zamora, K. W., Woodard, S. A., Umphrey, H., Bernreuter, W., Nelson, M., … Hylton, N. M. (2022). I-SPY 2 Breast Dynamic Contrast Enhanced MRI Trial (ISPY2)  (Version 1) [Data set]. The Cancer Imaging Archive. https://doi.org/10.7937/TCIA.D8Z0-9T85
2. Newitt, D. C., Partridge, S. C., Zhang, Z., Gibbs, J., Chenevert, T., Rosen, M., Bolan, P., Marques, H., Romanoff, J., Cimino, L., Joe, B. N., Umphrey, H., Ojeda-Fournier, H., Dogan, B., Oh, K. Y., Abe, H., Drukteinis, J., Esserman, L. J., & Hylton, N. M. (2021). ACRIN 6698/I-SPY2 Breast DWI [Data set]. The Cancer Imaging Archive. https://doi.org/10.7937/TCIA.KK02-6D95
3. Li, W., Newitt, D. C., Gibbs, J., Wilmes, L. J., Jones, E. F., Arasu, V. A., Strand, F., Onishi, N., Nguyen, A. A.-T., Kornak, J., Joe, B. N., Price, E. R., Ojeda-Fournier, H., Eghtedari, M., Zamora, K. W., Woodard, S. A., Umphrey, H., Bernreuter, W., Nelson, M., … Hylton, N. M. (2020). Predicting breast cancer response to neoadjuvant treatment using multi-feature MRI: results from the I-SPY 2 TRIAL. In npj Breast Cancer (Vol. 6, Issue 1). Springer Science and Business Media LLC. https://doi.org/10.1038/s41523-020-00203-7
4. Clark, K., Vendt, B., Smith, K., Freymann, J., Kirby, J., Koppel, P., Moore, S., Phillips, S., Maffitt, D., Pringle, M., Tarbox, L., & Prior, F. (2013). The Cancer Imaging Archive (TCIA): Maintaining and Operating a Public Information Repository. In Journal of Digital Imaging (Vol. 26, Issue 6, pp. 1045–1057). Springer Science and Business Media LLC. https://doi.org/10.1007/s10278-013-9622-7
5. Data usage policy as required by TCIA: https://wiki.cancerimagingarchive.net/display/Public/Data+Usage+Policies+and+Restrictions

# References
* Pati S, Singh A, Rathore S, et al. The Cancer Imaging Phenomics Toolkit (CaPTk): Technical Overview. Brainlesion. 2020;11993:380-394. doi:10.1007/978-3-030-46643-5_38 (link: https://doi.org/10.1007/978-3-030-46643-5_38)
* Singh A, Chitalia R, Kontos D. Radiogenomics in brain, breast, and lung cancer: opportunities and challenges. J Med Imaging (Bellingham). 2021;8(3):031907. doi:10.1117/1.JMI.8.3.031907 (link: https://doi.org/10.1117/1.jmi.8.3.031907)
* Horng H, Singh A, Yousefi B, et al. Improved generalized ComBat methods for harmonization of radiomic features. Sci Rep. 2022;12(1):19009. Published 2022 Nov 8. doi:10.1038/s41598-022-23328-0 (link: https://doi.org/10.1038/s41598-022-23328-0)

