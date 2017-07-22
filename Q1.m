addpath('./omp');

peak = 100;
IMG = imread('peppers256.png');
%img = rgb2gray(IMG);
img = double(IMG);
%imshow(img)
[x1,y1] = size(img1);

img = img * peak / max(img(:));

%selecting image patch
IMG1 = imread('peppers256.png');
%noisyImg = rgb2gray(IMG1);
noisyImg = IMG1 * peak / max(IMG1(:));

R = floor(x1/size(noisyImg,1));
C = floor(y1/size(noisyImg,2));
blank = zeros(size(img));
blank = repmat(noisyImg,R,C);
[x y] = size(repmat(noisyImg,R,C));
for i = x+1:x1
    for j = 1:y1
        if(j-(floor(j/size(noisyImg,2))*size(noisyImg,2)) ~=0)
            var = j-(floor(j/size(noisyImg,2))*size(noisyImg,2));
        else
            var = 1;
        end
        blank(i,j) = noisyImg(i-x,var);
    end
end
for i = 1:x
    for j = y+1:y1
        if(i-(floor(i/size(noisyImg,1))*size(noisyImg,1)) ~=0)
            var1 = i-(floor(i/size(noisyImg,1))*size(noisyImg,1));
        else
            var1 = 1;
        end
        blank(i,j) = noisyImg(var1,j-y);
    end
end

noisyImg = poissrnd(img);
noisyImg = imresize(noisyImg,[x1,y1]);
blank1 = double(blank);

epsilon = norm(img1-blank1,'fro');
%epsilon = 6*10^3;
par = 7;
Y = zeros(49,x1*y1);
k = 0;
for i = 1:(x1-6)
    for j = 1:(y1-6)
        k = k+1;
        Y(:,k) = reshape(img1(i:i+par-1,j:j+par-1), par*par, 1);
    end
end

% Initialize W using kmeans
p = 80; % learning a dictionary of K = 80 columns
[m,n] = size(Y);

% 'Initializing dictionary using kmeans...'
[idx, initW] = kmeans(Y',p);
initW = initW';
initW = normc(initW);
% 'Initializing coefficients...'
initH = zeros(p,size(Y,2));
iter= zeros(size(Y,2),1);

parfor col = 1:size(Y,2)
    col
   [ initH(:,col), iter(col,1) ]= OMP(Y(:,col), initW, epsilon );
end
initH = max(initH,0);

lambda = 3;
maxiter = 1000;
% 'Calling NNSC...'
[ W , H , oldobj , objHistory] = NNSC ( Y , initW , initH , lambda , maxiter );
X = W*H;
initX = initW*initH;

% average the overlapping patches
countImage = zeros(x1,y1)
outImage = zeros(x1,y1);
initImage = zeros(x1,y1);
i = 1; j = 1;
iter = zeros(size(Y,2),1);

% 'Averaging overlapping patches...'
for col = 1:size(Y,2)
    
    initImage(i:i+par-1, j:j+par-1) = initImage(i:i+par-1, j:j+par-1) + reshape(initX(:,col),par,par);
    outImage(i:i+par-1, j:j+par-1) = outImage(i:i+par-1, j:j+par-1) + reshape(X(:,col),par,par);
    countImage(i:i+par-1, j:j+par-1) = countImage(i:i+par-1, j:j+par-1) + 1;
    
    if j == y1-6
        j = 1;
        i = i+1;
    else
        j = j+1;
    end
    
    if i > x1-6
        break;
    end
    
end

outImage = outImage ./ countImage;
diffImage = img - outImage;
diffImage = img1 -outImage;
noisySNR = psnr(noisyImg, img)
outputSNR = psnr(outImage, img1)
rrmse(img,noisyImg)
rrmse(img,outImage)
rrmse(img,initImage*peak/max(initImage(:)))

figure, imagesc(uint8(outImage)); axis equal tight; colormap gray;
imshow(uint8(outImage));
title('Ground Truth, denoised image');
figure, imagesc(outImage); axis equal tight; colormap gray; title('Using overlapping patches');
