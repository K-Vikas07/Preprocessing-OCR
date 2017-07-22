function [peaksnr] = psnr(A, ref)

peakval = max(A(:)) - min(A(:));

err = immse(A,ref);

peaksnr = 10*log10(peakval.^2/err);

end
