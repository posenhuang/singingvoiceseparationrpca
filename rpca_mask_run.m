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
filename='titon_2_07';
% filename='yifen_2_01';
wavinA= wavread([filename,'_music.wav']);
wavinE= wavread([filename,'_vocal.wav']);
wavlength=length(wavinA);

[wavinmix,Fs]= wavread([filename,'_SNR5.wav']);
        
%% GNSDR computation
[e1,e2,e3] = bss_decomp_gain( wavinmix', 1, wavinE');
[sdr_,sir_,sar_] = bss_crit( e1, e2, e3);

%% Run RPCA
parm.outname=['example' filesep 'output' filesep filename];
parm.lambda=1;
parm.nFFT=1024;
parm.windowsize=1024;
parm.masktype=1; %1: binary mask, 2: no mask
parm.gain=1;
parm.power=1;
parm.fs=Fs;

Parms=rpca_mask_fun(wavinA,wavinE,wavinmix,parm); % SDR(\hat(v),v),                    

%% NSDR=SDR(estimated voice, voice)-SDR(mixture, voice)
NSDR=Parms.SDR-sdr_;                               
%%                               
fprintf('SDR:%f\nSIR:%f\nSAR:%f\nNSDR:%f\n',Parms.SDR,Parms.SIR,Parms.SAR,NSDR);