# Preprocessing-OCR
The code enclosed is a preprocessong technique for OCR. OCR stands for Optical Character Recognition.
For those who dont know a about OCR follow this link https://en.wikipedia.org/wiki/Optical_character_recognition.

The pre-processing techniques has to tackle many issues. Some of them are image conversion, resize, despeckle, noise removal, de-skew, segmentation etc.
I have worked with Document images. The pre- processing techniques which I have done are Image conversion, Segemtation, Noise removal. Out of them the my new approach was in Noise removal. I have tried to remove the poisson noise.

The math math behind my work is to minimize the following Objective objective function:

E(W,{h_i}) =sum[sum[(−y_ij log(W h_i)_j ) + (W h_i )_j]] + λsum[sum(h_i)-j]]

where, λ is a regularization parameter.

I perform alternating optimization, using projected gradient descent with adaptive step size for each of the two variables

The main code is Q1 code. But to run that you also need other codes of OMP.m , rrmse.m, NNSC.m, psnr.m.

To illustrate I have carried out the expirement on an image peppers256.png. I have added poison noise to the image and the performed the poison denoising on it. The reults are shown in output images 30.png, 60.png, 100.png with peak values of 30, 60, 100 respectively.
