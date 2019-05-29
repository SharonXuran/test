%==========================================================================
% Image Quality Assessment (IQA) on Synthesized Sketches
% Nannan Wang
% nnwang@xidian.edu.cn
% 2016.10.26
%==========================================================================

clear;clc;

addpath('Codes');

Database = 'CUFSF';
refSketchpath = 'GT/CUFSF/';
synSketchpath = 'Synthesis Results/CUFSF/';

if strcmp(Database,'CUFS')
    Nim = 338;
else
    Nim = 944;
end

%METHODS = {'MWF','SSD','RSLCR','FCN','GAN','CycleGAN'};
METHODS = {'Proposed'};
    
%% Synthesized Sketch, Reference Sketch
% S_LLE_SSIM = zeros(Nim,1);
% S_MRF_SSIM = zeros(Nim,1);
% S_MWF_SSIM = zeros(Nim,1);
SSIM = zeros(Nim,length(METHODS));
for i = 1:Nim
    
    fprintf('Synthesized Sketches, Reference Sketch, Processing %d/%d\n',i,Nim);
    
    refim = imread([refSketchpath,num2str(i),'.jpg']);
    if size(refim,3) == 3
        refim = rgb2gray(refim);
    end
    refim = double(refim);
    index_width  = 1:200;
    index_height = 1:250;
    for method_id = 1:length(METHODS)
        method_name = METHODS{method_id};
        distSketchpath = [synSketchpath,method_name,'/'];
        if ((method_id == 1) ||(method_id ==14 )||(method_id ==15))
            im = imread([distSketchpath,num2str(i),'.png']);
        else
            im = imread([distSketchpath,num2str(i),'.jpg']);
        end
        if size(im,3) == 3
            im = rgb2gray(im);
        end
        im = double(im);
        SSIM(i,method_id) = FR_SSIM(refim(index_height,index_width),im);
%         method_id
    end  
end

T_SSIM = array2table(SSIM,'VariableNames',METHODS);
T_mean = array2table(mean(SSIM),'VariableNames',METHODS);
save(['Result/IQA_SynSketch_SSIM_CUFSF_Proposed.mat'],'T_SSIM','T_mean');
T_mean