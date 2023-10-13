%% Extract features using CaPTk 
% Purpose: To loop through cases and sequentially run CaPTk 

clear all

%       ####### User inputted information below #########

%read file paths from the lists outputted from generate_captk_lists.m 
listdir = 'C:\home\list_directory';
ids_list = fullfile(listdir,'id_list_example.list');
img_list = fullfile(listdir,'input_list_example.list');
mask_list = fullfile(listdir,'mask_list_example.list');
output_list = fullfile(listdir,'output_list_example.list');

% define the CaPTk parameter file path (informs different parameters that
% CaPTk uses to extract features)
param_file = fullfile(listdir,'params_default_v190.csv');

% define CaPTk exec FeatureExtraction file path
captk_cmd = 'C:\CaPTk_Full\1.9.0\bin\FeatureExtraction.exe';

%       ####### User inputted information above #########

% RUN THE COMMAND:
runCaPTK_MATLAB(ids_list, img_list, mask_list, output_list, param_file, captk_cmd)

function runCaPTK_MATLAB(ids_list, img_list, mask_list, output_list, param_file, captk_cmd)
%purpose: run captk to extract features for al cases in the lists
%output: one csv file of features for each case (if you have N=100 cases,
%you'll end up with 100 csv files with the names in output_list)

% import data from the .list files
ids = importdata(ids_list);
imgs = importdata(img_list);
masks = importdata(mask_list);
outs = importdata(output_list);
num = numel(ids); %number of cases

%% Run CaPTk commands for each subject
for k = 1:numel(ids)
    id_k = ids(k);
    img_k = imgs{k};
    mask_k = masks{k};
    out_k = outs{k};
    
    disp(['Extracting features for case ' num2str(id_k) '...'])
    cmd=[captk_cmd ' -n ' num2str(id_k) ' -i ' img_k ' -t T1 ' ' -r 1 -m ' mask_k ' -l E -p ' param_file ' -o ' out_k];
    system(cmd)
    disp(['Saving featues in ' out_k '...'])
end
end



