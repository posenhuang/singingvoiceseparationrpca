% This is an example code for running the RPCA for source separation
% P.-S. Huang, S. D. Chen, P. Smaragdis, M. Hasegawa-Johnson,
% "Singing-Voice Separation From Monaural Recordings Using Robust Principal Component Analysis," in ICASSP 2012
%
% Written by Po-Sen Huang @ UIUC
% For any questions, please email to huang146@illinois.edu.

%% addpath
clear all; close all;
addpath('bss_eval');
addpath('example');
addpath(genpath('inexact_alm_rpca'));
%% Examples
filename = 'titon_2_07'; % Example 1 - put the file under example folder
% filename = 'yifen_2_01';  % Example 2 - put the file under example folder
[wavinmix, fs] = audioread([filename, '_SNR5.wav']);
%% Run RPCA
parm.outname = ['example', filesep, 'output', filesep, filename];
parm.lambda = 1;
parm.nFFT = 1024;
parm.windowsize = 1024;
parm.masktype = 1; %1: binary mask, 2: no mask
parm.gain = 1;
parm.power = 1;
parm.fs = fs;

outputs = rpca_mask_execute(wavinmix, parm);
fprintf('Output separation results are in %s\n', parm.outname)
fprintf('%s_E is the sparse part and %s_A is the low rank part\n', ...
    parm.outname, parm.outname)
%% Run evaluation
RUN_EVALUATION = 1;  % Set RUN_EVALUATION = 0 if no evaluation is needed.
if RUN_EVALUATION
    wavinA = audioread([filename, '_music.wav']);
    wavinE = audioread([filename, '_vocal.wav']);
    %% GNSDR computation
    [s_target, e_interf, e_artif] = bss_decomp_gain(wavinmix', 1, wavinE');
    [sdr_mixture, sir_mixture, sar_mixture] = bss_crit(s_target, e_interf, e_artif);
    evaluation_results =rpca_mask_evaluation(wavinA, wavinE, outputs);
    %% NSDR = SDR(estimated voice, voice)-SDR(mixture, voice)
    NSDR = evaluation_results.SDR - sdr_mixture;
    fprintf('SDR:%f\nSIR:%f\nSAR:%f\nNSDR:%f\n', ...
        evaluation_results.SDR, evaluation_results.SIR, ...
        evaluation_results.SAR, NSDR);
end
