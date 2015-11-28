function outputs = rpca_mask_execute(wavinmix, parm)
    %% parameters
    lambda = parm.lambda;
    nFFT = parm.nFFT;
    winsize = parm.windowsize;
    masktype = parm.masktype;
    gain = parm.gain;
    power = parm.power;
    Fs = parm.fs;
    outputname = parm.outname;

    hop = winsize / 4;
    scf = 2 / 3;
    S = scf * stft(wavinmix, nFFT, winsize, hop);
   %% use inexact_alm_rpca to run RPCA
    try                
        [A_mag, E_mag] = inexact_alm_rpca(abs(S) .^ power', ...
            lambda / sqrt(max(size(S))));
        PHASE = angle(S');            
    catch error
        [A_mag, E_mag] = inexact_alm_rpca(abs(S) .^ power, ...
            lambda / sqrt(max(size(S))));
        PHASE = angle(S);
    end    
    A = A_mag .* exp(1i .* PHASE);
    E = E_mag .* exp(1i .* PHASE);
    %% binary mask, no mask
    switch masktype
      case 1 % binary mask + median filter
        mask = double(abs(E) > (gain * abs(A)));
        try  
            Emask = mask .* S;
            Amask = S - Emask;
        catch error
            Emask = mask .* S';
            Amask = S' - Emask;
        end        
      case 2 % no mask
        Emask = E;
        Amask = A;
      otherwise 
        fprintf('masktype error\n');
    end
    %% do istft
    try 
        wavoutE = istft(Emask', nFFT, winsize, hop)';   
        wavoutA = istft(Amask', nFFT, winsize, hop)';
    catch error
        wavoutE = istft(Emask, nFFT, winsize, hop)';   
        wavoutA = istft(Amask, nFFT, winsize, hop)';
    end
    wavoutE = wavoutE / max(abs(wavoutE));
    audiowrite([outputname,'_E.wav'], wavoutE, Fs);

    wavoutA = wavoutA / max(abs(wavoutA));
    audiowrite([outputname,'_A.wav'], wavoutA, Fs);

    outputs.wavoutA = wavoutA;
    outputs.wavoutE = wavoutE;