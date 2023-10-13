%     Generate list files as inputs into CaPTk software

% Since naming conventions and organization for datasets can vary, it's
% easier to make this code expect an Excel sheet with the patient ID, image directory,
% and mask directory in each column of the sheet (in this order).

%       ####### User inputted information below #########

% define function inputs:
sheet_file = 'Z:\home\user\data_directories_example.xlsx';
sheet_num = 5; % which sheet in the Excel file?
sheet_range = 'A2:C76'; % what range of cells to load?
listdir = 'Z:\home\user\captk_experiment_example'; %where to save the lists
outdir = 'Z:\home\user\captk_results)example'; % where to save outputs
listlab = 'testing'; % suffix to be used in the list names when saving
outlab = 'dataset_1_example'; % label to attach to output file names when saving

%       ####### User inputted information above #########

% RUN THE COMMAND:
write_captk_lists(sheet_file, sheet_num, sheet_range, outdir, listdir, listlab, outlab)

function write_captk_lists(sheet_file, sheet_num, sheet_range, outdir, listdir, listlab, outlab)

%purpose: generate input, mask, and output lists for use with captk scripts
%output: Four lists (text files) containing case IDs, image directories,
%mask directories, and output csv file names for ultimately saving the
%captk features for each case

%Inputs:
% -sheet_file: spreadsheet that contains [PIDs, Image Directory, Mask Directory} 
% -sheet_num: which sheet in the Excel spreadsheet to load (if you have multiple, else just put 1)?
% -sheet_range: the range of cells in the sheet
% -outdir: directory in which to save your results
% -listdir: directory in which to store the list files (suggest same as
% outdir)
% -listlab: identifying suffix for the list (e.g. _dataset1, _breastData) 
% -outlab: identifying suffix for the processed images (e.g. _dataset1,_breastData,_radius1)


% load the sheet with directories
[~,~,sheet_loaded] = xlsread(sheet_file,sheet_num,sheet_range);

% pull out columns from the sheet
cases = sheet_loaded(1:end,1);
imdirs = sheet_loaded(1:end,2);
maskdirs = sheet_loaded(1:end,3);

% open four different text files (input images, masks, outputs, case IDs)
fileinput=fopen([listdir,'\input_',listlab,'.list'], 'w');
filemask=fopen([listdir,'\mask_',listlab,'.list'], 'w');
fileoutput=fopen([listdir,'\output_',listlab,'.list'], 'w');
fileids=fopen([listdir,'\id_',listlab,'.list'], 'w');

for i = 1:length(cases) %loop through the cases
    case_id = num2str(cases{i});
     
    % write the image directory to each line of the file
    imfilename = imdirs{i};
    fprintf(fileinput, '%s\n', imfilename);

    % write the mask directory to each line of the file
    maskfilename = maskdirs{i};
    fprintf(filemask, '%s\n', maskfilename);

    % write the output image directory to each line of the text file
    outfilename=[outdir, '\', 'case_',case_id, '_features_', outlab,'.csv'];
    fprintf(fileoutput, '%s\n',outfilename);
    
    
    % write the case number to each line (just the number)
    idfilename = case_id;
    fprintf(fileids, '%s\n',idfilename);
end

fclose(fileinput);
fclose(fileoutput);
fclose(fileids);
fclose(filemask);

end


