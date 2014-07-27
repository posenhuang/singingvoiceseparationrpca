function Parms=rpca_mask_fun(wavinA,wavinE,wavinmix,parm)
    %% parameters

    lambda = parm.lambda;
    nFFT = parm.nFFT;
    winsize = parm.windowsize;
    masktype = parm.masktype;
    gain = parm.gain;
    power = parm.power;
    Fs= parm.fs;
    outputname = parm.outname;

    hop = winsize/4;
    scf = 2/3;
    S = scf * stft(wavinmix, nFFT ,winsize, hop);

   %% use inexact_alm_rpca to run RPCA
    try                
        [A_mag E_mag] = inexact_alm_rpca(abs(S).^power',lambda/sqrt(max(size(S))));
        PHASE = angle(S');            
    catch err
        [A_mag E_mag] = inexact_alm_rpca(abs(S).^power,lambda/sqrt(max(size(S))));
        PHASE = angle(S);
    end
    
    A = A_mag.*exp(1i.*PHASE);
    E = E_mag.*exp(1i.*PHASE);

    %% binary mask, no mask
    switch masktype                         
      case 1 % binary mask + median filter
        m= double(abs(E)> (gain*abs(A)));                  
        try  
            Emask =m.*S;
            Amask= S-Emask;
        catch err
            Emask =m.*S';
            Amask= S'-Emask;
        end        
      case 2 % no mask
        Emask=E;
        Amask=A;
      otherwise 
          fprintf('masktype error\n');
    end

    %% do istft
    try 
        wavoutE = istft(Emask', nFFT ,winsize, hop)';   
        wavoutA = istft(Amask', nFFT ,winsize, hop)';
    catch err
        wavoutE = istft(Emask, nFFT ,winsize, hop)';   
        wavoutA = istft(Amask, nFFT ,winsize, hop)';
    end

    wavoutE=wavoutE/max(abs(wavoutE));
    wavwrite(wavoutE,Fs,[outputname,'_E']);

    wavoutA=wavoutA/max(abs(wavoutA));
    wavwrite(wavoutA,Fs,[outputname,'_A']);

    %% evaluate
    if length(wavoutA)==length(wavinA)

        sep = [wavoutA , wavoutE]';
        orig = [wavinA , wavinE]';

        for i = 1:size( sep, 1)
               [e1,e2,e3] = bss_decomp_gain( sep(i,:), i, orig);
               [sdr(i),sir(i),sar(i)] = bss_crit( e1, e2, e3);
        end
    else
        minlength=min( length(wavoutE), length(wavinE) );

        sep = [wavoutA(1:minlength) , wavoutE(1:minlength)]';
        orig = [wavinA(1:minlength) , wavinE(1:minlength)]';

        for i = 1:size( sep, 1)
               [e1,e2,e3] = bss_decomp_gain( sep(i,:), i, orig);
               [sdr(i),sir(i),sar(i)] = bss_crit( e1, e2, e3);
        end
    end

    Parms.SDR=sdr(2);
    Parms.SIR=sir(2);
    Parms.SAR=sar(2);
