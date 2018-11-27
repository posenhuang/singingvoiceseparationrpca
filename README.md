## Singing-Voice Separation From Monaural Recordings Using Robust Principal Component
This package contains the Matlab codes implementing the RPCA source separation algorithm described in
"[Singing-Voice Separation From Monaural Recordings Using Robust Principal Component Analysis](http://posenhuang.github.io/papers/RPCA_Separation_ICASSP2012.pdf)," ICASSP 2012.

Our algorithm is composed of the following parts:
- STFT, masking
- Robust Principal Component solved by using inexact augmented Lagrange multiplier (ALM) Method
   Reference: http://perception.csl.uiuc.edu/matrix-rank/sample_code.html
- ISTFT
- BSS Eval toolbox Version 2.1
   Reference: http://bass-db.gforge.inria.fr/bss_eval/

The algorithm achieves the state-of-the-art performance on [MIR-1K Dataset](https://sites.google.com/site/unvoicedsoundseparation/mir-1k) in an unsupervised way.

## Demo 
Run rpca_mask_demo.m to see how the functions are called.
Change [RUN_EVALUATION = 0](https://github.com/posenhuang/singingvoiceseparationrpca/blob/master/rpca_mask_demo.m#L32) if you don't need evaluation.

For more information, please check: https://sites.google.com/site/singingvoiceseparationrpca/


## License
MIT
