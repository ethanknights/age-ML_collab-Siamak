%% Create ./data/<CCID>_fMRI_timeseries.csv: ROIs x Timeseries 
%% Timeseries is the volume (mean across voxels)
%%
%% Atlas Version = Craddock atlas
%%
%% ./key-ROI_<atlas>.csv assigns each ROI to a network based on mask from 
%% Geerligs et al. 2015 -
%% See https://github.com/ethanknights/functional-segregation_fMRI-MEG 
%% Ethan Knights 04/04/2022.
%% ========================================================================

%% Write Key
%%-------------------------------------------------------------------------
!cp /imaging/camcan/sandbox/ek03/projects/functional-segregation_fMRI-MEG/fMRI_craddock/data/001_getAtlas/craddock/atlasInfo.mat ./

load atlasInfo.mat
tmpD = atlasInfo.networkLabel_str;
WriteCellArraytoCSV(tmpD,'key-ROI_craddock.csv');
clear

%% Write Timeseries files
mkdir data
expected_nROIs = 840;
expected_nVols = 261;

dirCont = dir('/imaging/camcan/cc700/mri/pipeline/release004/data_fMRI_Unsmooth_Craddock/aamod_roi_extract_epi_00002/CC*/Rest/ROI_epi.mat');

for s = 1:length(dirCont)
  
  CCID = cell2mat( regexp(dirCont(s).folder,'CC\d*','match') );
  fN = fullfile(dirCont(s).folder,'ROI_epi.mat');
  
  try
    load(fN);
    
    for r = 1:expected_nROIs
      tmpD(r,:) = ROI(r).mean';
    end
    
    assert(size(tmpD,1) == expected_nROIs,'wrongNROIS!? %s\n%s',CCID, fN)
    assert(size(tmpD,2) == expected_nVols,'wrongNROIS!? %s\n%s',CCID, fN)

    oN = fullfile('data',[CCID,'_timeseries-fMRI_atlas-craddock.csv'])
    
    csvwrite(oN,tmpD)
    
  catch
    error('file missing!? %s\n%s',CCID, fN)
  end

end
