spm_path = 'C:\Users\lealo\Documents\MatLab\SPM\spm12 (1)\spm12';
baseDir = 'C:\Users\lealo\Documents\Master Cog Neuro\statsproject\'; 
voiCoords = [-40 -40 60]; % coordinates for the left BA2
%voiCoords2 = [44 -40 60] %coordinates for the right BA2

addpath(spm_path);
spm_jobman('initcfg')
spm fmri

% definition of the subjects and conditions
subjects = {'sub-001','sub-002','sub-003','sub-004','sub-005','sub-006','sub-007','sub-008','sub-009','sub-010' }; 
conditions = {'Stim', 'Imag'}; 

%extracting the time series of the VOI for each subject

for i = 1:length(subjects)
    subjectDir = fullfile(baseDir, subjects{i}, '1st_level_good_bad_Imag');
    
    clear matlabbatch;
    matlabbatch{1}.spm.util.voi.spmmat = {fullfile(baseDir, subjects{i},'stats_test', 'SPM.mat')};
    matlabbatch{1}.spm.util.voi.adjust = 0;  % Adjust for effects of interest (0 = no adjustment)
    matlabbatch{1}.spm.util.voi.name = 'BA2';  % name VOI
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = voiCoords;  
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 8;  
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.expression = 'i1';

    %concatenate Y of all runs 

    Y_combined = [];
    Stim_combined = [];
    Imag_combined = [];

    for runIndex = 1:6  % Loop through all runs
        matlabbatch{1}.spm.util.voi.session = runIndex;  
        try
            spm_jobman('run', matlabbatch);
            
            %load and save the VOI-time series for this run
            voiFile = fullfile(baseDir,subjects{i}, 'stats_test', sprintf('VOI_BA2_%d.mat', runIndex));
            load(voiFile)

            % concatenate the VOI time series
            Y_combined = [Y_combined; Y];
            
            % Load SPM.mat to extract psychological variables for the current run
            load(fullfile(baseDir, subjects{i}, 'stats_test', 'SPM.mat'));

            % extract the psychological variables for specific run
            Stim = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 1);  
            Imag = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 2);
            
            %concatenate psychological variables
            Stim_combined = [Stim_combined; Stim];
            Imag_combined = [Imag_combined; Imag];
        catch ME
            fprintf('Error processing subject %s run %d: %s\n', subjects{i}, runIndex, ME.message); %debugging try
            continue;
        end
    end

    % create psychological variable for all runs
    Psych_combined = Stim_combined - Imag_combined;

    % Save combined time series
    save(fullfile(subjectDir, 'BA2_time_series_combined.mat'), 'Y_combined')
    
    % Debugging try 2.0
    fprintf('Size of combined Y for subject %s: %d\n', subjects{i}, length(Y_combined));
    
end

        

% Individual PPI models for each subject
for i = 1:length(subjects)
    subjectDir = fullfile(baseDir, subjects{i}, '1st_level_good_bad_Imag');
    cd(subjectDir)
 
    load('BA2_time_series_combined.mat')
    load(fullfile(baseDir, subjects{i}, 'stats_test', 'SPM.mat'))

    % Define the psych variables
    Stim_combined = [];
    Imag_combined = [];

    for runIndex = 1:6
        Stim = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 1);  
        Imag = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 2);
        
        Stim_combined = [Stim_combined; Stim];
        Imag_combined = [Imag_combined; Imag];
    end

    Psych_combined = Stim_combined - Imag_combined;    % difference between the conditions 

    % create the interaction term
    Interaction_combined = Psych_combined .* Y_combined;

    % create PPI-model
    X = [Psych_combined Y_combined Interaction_combined];

    % predict PPI-Model
    [betas, ~, stats] = glmfit(X, Y_combined);  

    % save results
    save(fullfile(subjectDir, 'PPI_results_combined.mat'), 'betas', 'stats')
end



% Group analysis
groupDir = fullfile(baseDir, 'group_analysis');

contrastFiles = cell(length(subjects), 1);
for i = 1:length(subjects)
    subjectDir = fullfile(baseDir, subjects{i}, '1st_level_good_bad_Imag');
    contrastFiles{i} = fullfile(subjectDir, 'con_0001.nii,1'); 
end

clear matlabbatch;
% Set up the factorial design specification
matlabbatch{1}.spm.stats.factorial_design.dir = {groupDir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = contrastFiles;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% save and run the batch
save(fullfile(groupDir, 'group_GLM_batch.mat'), 'matlabbatch');
spm_jobman('run', matlabbatch);

%estimated manually with the GUI

clear matlabbatch;

%set up contrast manager
matlabbatch{1}.spm.stats.con.spmmat = {fullfile(groupDir, 'SPM.mat')};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'PPI-Interaction';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1; % Adjust the weights as needed
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

% Save and run the batch
save(fullfile(groupDir, 'group_GLM_contrast.mat'), 'matlabbatch');
spm_jobman('run', matlabbatch);

% visualized manually with the SPM GUI

