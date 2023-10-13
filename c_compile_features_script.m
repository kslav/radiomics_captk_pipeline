clear all
%% Load in CaPTk raw features by case and consolidate into one spreadsheet

% Purpose: To consolidate each case's CaPTk output (basically one
% spreadsheet with a single row) into one big spreadsheet that contains all
% features (columns) for all cases (rows)


%       ####### User inputted information below #########

%read in list of case numbers and captk output files. This code assumes you
%have existing lists that you used to run captk, so you can just use those
%same lists to get the directories of your feature csv files and your IDs

cases = importdata('Z:\home\user\id_list_example.list');
outputs = importdata('Z:\home\user\output_list_example.list');
save_lab = 'dataset_example'; %label to use when saving the consolidated spreadsheet
save_dir = 'Z:\home\user\save_dir';

%       ####### User inputted information above #########
%%
% RUN THE COMMAND:
compile_features(cases,outputs,save_lab, save_dir)

function compile_features(cases,outputs,save_lab, save_dir)
cd(save_dir) % go to results_dir

% start off by making a table from the first case in the list, cases(1)
case_table_all = readtable(outputs{1});

for i = 2:numel(cases) %loop through the remaining cases
    %concatenate features for remaining cases into case_table_all
    case_i = cases(i);
    try
        % try to read the table for a particular case
        case_table = readtable(outputs{i});
        case_table_all = [case_table_all;case_table];

    catch
        % if the results for this case don't exist, give a warning and
        % continue through the loop
        case_i
        warning(sprintf('No features extracted for case %d',case_i))
        continue
    end

end

% save case_table_all as a .csv file using save_lab as part of the name.
% This will save under results_dir since we cd'd to it!
writetable(case_table_all,sprintf("%s_consolidated_features.csv",save_lab))
end



