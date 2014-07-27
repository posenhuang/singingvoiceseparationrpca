This package contains the Matlab codes implementing the RPCA source separation algorithm described in 
"Singing-Voice Separation From Monaural Recordings Using Robust Principal Component Analysis," ICASSP 2012.

Our algorithm is composed of the following parts:
a. STFT, masking
b. Robust Principal Component solved by using inexact augmented Lagrange multiplier (ALM) Method
   Reference: http://perception.csl.uiuc.edu/matrix-rank/sample_code.html
c. ISTFT
d. BSS Eval toolbox Version 2.1
   Reference: http://bass-db.gforge.inria.fr/bss_eval/

The algorithm achieves the state-of-the-art performance on MIR-1K Dataset in an unsupervised way.
Reference: https://sites.google.com/site/unvoicedsoundseparation/mir-1k


Run rpca_mask_run.m to see how the functions are called. 
For demo, please check: https://sites.google.com/site/singingvoiceseparationrpca/
For any questions, please email to Po-Sen Huang: huang146@illinois.edu
