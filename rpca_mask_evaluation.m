function evaluation_results = rpca_mask_evaluation(wavinA, wavinE, outputs)
%% evaluate rpca performance
wavoutA = outputs.wavoutA;
wavoutE = outputs.wavoutE;
if length(wavoutA) == length(wavinA)
    sep = [wavoutA, wavoutE]';
    orig = [wavinA, wavinE]';
    for i = 1 : size(sep, 1)
        [s_target, e_interf, e_artif] = bss_decomp_gain(sep(i, :), i, orig);
        [sdr(i), sir(i), sar(i)] = bss_crit(s_target, e_interf, e_artif);
    end
else
    minlength = min(length(wavoutE), length(wavinE));
    sep = [wavoutA(1 : minlength), wavoutE(1 : minlength)]';
    orig = [wavinA(1 : minlength), wavinE(1 : minlength)]';
    for i = 1 : size(sep, 1)
        [s_target, e_interf, e_artif] = bss_decomp_gain(sep(i, :), i, orig);
        [sdr(i), sir(i), sar(i)] = bss_crit(s_target, e_interf, e_artif);
    end
end
evaluation_results.SDR = sdr(2);
evaluation_results.SIR = sir(2);
evaluation_results.SAR = sar(2);
