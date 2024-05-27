function im = HighPassGaussFilt(im, lx, ly)
%HIGHPASSGAUSSFILT is a function used for high pass space gauss filter
%INPUT:
% im: the field or image you need to filt
% lx: x length of the kenerl
% ly: y length of the kenerl
%OUTPUT:
% im: the filted field or image

    [y, x] = size(im);
    Fim = fft2(im, 2*y, 2*x);
    Fim3 = fftshift(Fim);
    W = zeros(2*y, 2*x);
    
end