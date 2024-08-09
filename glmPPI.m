% I ran the script for each subject
clear matlabbatch

sub_dir = 'C:\Users\lealo\Documents\Master Cog Neuro\statsproject\sub-010';
cd(sub_dir)
load all_onsets_goodImag_sub016.mat

sub_folders = dir(fullfile(sub_dir, 'run*'));

matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

for i = 1:length(sub_folders)
    run4D = cellstr(spm_select('FPList',fullfile(sub_dir,sub_folders(i).name),'^ds.*\d{2}\.nii$'));
    run = cellstr(spm_select('Expand', run4D{1}));
  
    onsets_stim = sort([onsets{i,1:3}]);
    onsets_img = sort([onsets{i,4:6}]);
    onsets_null_1 = onsets{i,7};
    onsets_null_2 = onsets{i,8};
    onsets_preCue = onsets{i,9};
    onsets_motion = onsets{i,10};
    onsets_badImg = onsets{i,11}; % Hier hinzufügen

    matlabbatch{1}.spm.stats.fmri_spec.dir = {'C:\Users\lealo\Documents\Master Cog Neuro\statsproject\sub-010\stats_test'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).scans = run;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).name = 'STIM';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).onset = onsets_stim;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(1).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).name = 'IMG';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).onset = onsets_img;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(2).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).name = 'Null_1';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).onset = onsets_null_1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).name = 'Null_2';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).onset = onsets_null_2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(4).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).name = 'preCue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).onset = onsets_preCue;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(5).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).name = 'Motion';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).onset = onsets_motion;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(6).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).name = 'badImg';
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).onset = onsets_badImg;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).duration = 3; % Dauer hinzufügen
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi_reg = {''};

    matlabbatch{1}.spm.stats.fmri_spec.sess(i).hpf = 128;
end

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

spm_jobman('run', matlabbatch);

% I estimated it manually with the SPM GUI for each subject
