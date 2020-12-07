clear all; close all; clc;
%%Image 1 begins here
clc;clear;
I = imread("noisy1.png");
%The histogram is not fitting anything, and there is a periodic noise in
%the picture. So , I need to fourier transform.
% Fourier transform
[M N]=size(I);
F=fftshift(fft2(I))
[Hnp,Hnr] = NotchPassAndRejectFilters('butterworth',M,N,80,40,30,2);%butterworth is the best case for output.
G=Hnp.*F;
G2=abs((ifft2((G))));
Final=uint8(255*mat2gray(G2)); %Convert G2 to proper type

figure(1);imshow(I);title('Original');figure(2);imshow(G2,[]);title('Cleaner');figure(3);imshow(Final);title('G2');
% The noisy image seemed like no edge because of noise.
figure;edge(G2,[]);title('Edge of reconstructed');
figure;edge(I);title('Edge of noisy');
imwrite(Final,'recovered1.png');

%% Image 2 begins here
clear all; close all; clc;
I = imread("noisy2.png");
%The histogram is not fitting anything, and there is a periodic noise in
%the picture. So , I need to fourier transform.
% Fourier transform
[M N]=size(I);
F=fftshift(fft2(I))
[Hnp,Hnr] = NotchPassAndRejectFilters('ideal',M,N,120,70,30,2); %ideal is the best case for output.
G=Hnp.*F;
G2=abs((ifft2((G))));
Final=uint8(255*mat2gray(G2)); %Convert G2 to proper type
figure(1);imshow(I);title('Original');figure(2);imshow(G2,[]);title('Cleaner');
% The edges of reconstructed image is more clear.
figure;edge(G2,[]);title('Edge of reconstructed');
figure;edge(I);title('Edge of noisy');
imwrite(Final,'recovered2.png');

%% Image 3 begins here
clear all; close all; clc;
img = imread('noisy3.png');
size=size(img); % gets the size of image
row=size(1) % first value of size is row
column = size(2); % second value of size is column
crop_img=imcrop(img);
imwrite(crop_img,'cropped.png');
crop_img=imread('cropped.png');
hist=imhist(crop_img);
figure;imshow(crop_img);
figure;imshow(hist);
img2=img;


%From the histogram , I understood that it is uniform noise.I though that 
%harmonic mean filter will be best for this image.
filter=zeros(3,3);
summ=0;
for i=2:row-1
    for j=2:column-1
         filter(1,1)= img(i-1,j-1);filter(2,1)= img(i,j-1);filter(3,1)= img(i+1,j-1);filter(1,2)= img(i-1,j);filter(2,2)= img(i,j);filter(3,2)= img(i+1,j);filter(1,3)= img(i-1,j+1);filter(2,3)= img(i,j+1);filter(3,3)= img(i+1,j+1);
         array=[filter(1,:),filter(2,:),filter(3,:)];%concenate the filter point for making them an array
         summ=1/filter(1,1)+1/filter(1,2)+1/filter(1,3)+1/filter(2,1)+1/filter(2,2)+1/filter(2,3)+1/filter(3,1)+1/filter(3,2)+1/filter(3,3) %sum the point for the formula
         img2(i,j) =9/summ; % Then i change the pixel with formula value in harmonic mean
    end
end

figure;imshow(img2);title("imnoise");
figure;imshow(img);title("noisy");
figure;edge(img2);title('Edge of reconstructed');
figure;edge(img);title('Edge of noisy');
imwrite(img2,'recovered3.png');


%% Image 4 begins here
clear all; close all; clc;
img = imread('noisy4.png');
size1=size(img); % gets the size of image
row=size1(1) % first value of size is row
column = size1(2); % second value of size is column
crop_img=imcrop(img);
imwrite(crop_img,'cropped.png');
crop_img=imread('cropped.png');
hist=imhist(crop_img);
figure;imshow(crop_img);
figure;imhist(crop_img);
img2=img;
%From the histogram , I understood that it is uniform noise.I though that 
%mid point filter will be best for this image.
filter=zeros(3,3);
for i=2:row-1
    for j=2:column-1
        % Filter gets the neighboor and the own of the pixel
         filter(1,1)= img(i-1,j-1);filter(2,1)= img(i,j-1);filter(3,1)= img(i+1,j-1);filter(1,2)= img(i-1,j);filter(2,2)= img(i,j);filter(3,2)= img(i+1,j);filter(1,3)= img(i-1,j+1);filter(2,3)= img(i,j+1);filter(3,3)= img(i+1,j+1);
         array=[filter(1,:),filter(2,:),filter(3,:)]; %concenate the filter point for making them an array
         minimum=min(array); %find the min value.
         maks=max(array);%find the max value.
         
        img2(i,j) = (minimum+maks)/2; % Then i change the pixel with median value
    end
end

figure;imshow(img2);title("imnoise");
figure;imshow(img);title("noisy");

% With reconstructed image there less white dots in the blank side of the image.
% Blank side became more smooth, but there were no change in the cat.

figure;edge(img2);title('Edge of reconstructed');
figure;edge(img);title('Edge of noisy');
imwrite(img2,'recovered4.png');



%% Image 5 begins here
clear all; close all; clc;
img = imread('noisy5.png');
size1=size(img); % gets the size of image
row=size1(1) % first value of size is row
column = size1(2); % second value of size is column
img2=img; %temporary for storing the original image

crop_img=imcrop(img);
imwrite(crop_img,'cropped.png');
crop_img=imread('cropped.png');

size2=size(crop_img); % gets the size of image
row_c=size(1) % first value of size is row
column_c = size(2); % second value of size is column
hist=imhist(crop_img);
figure;imshow(crop_img);imhist(crop_img);


%From the histogram , I estimated that it is rayleigh noise. And also
%there are some salt-pepper noises. I though that min filter will be best
%for this image. I used contraharmonic filter also but best result came from
%this filter
filter=zeros(3,3);
%The code below does min filter
for i=2:row-1 
    for j=2:column-1
        
        %Get the filter from image
         filter(1,1)= img(i-1,j-1);filter(2,1)= img(i,j-1);filter(3,1)= img(i+1,j-1);filter(1,2)= img(i-1,j);filter(2,2)= img(i,j);filter(3,2)= img(i+1,j);filter(1,3)= img(i-1,j+1);filter(2,3)= img(i,j+1);filter(3,3)= img(i+1,j+1);
         array=[filter(1,:),filter(2,:),filter(3,:)];%concenate the filter point for making them an array
         minimum=min(array); %find the min value.
        img2(i,j) = minimum; % Change pixel value with the min 
    end
end

figure;imshow(img2);title("reconstructed");
figure;imshow(img);title("noisy");

%There are more white dots on noisy images, that's because of the noise.
%When I reduced the noise, new edges became less complex with white dots
%The upper line, upper shape of elephant became more visible

figure;edge(img2);title('Edge of reconstructed');
figure;edge(img);title('Edge of noisy');
imwrite(img2,'recovered5.png');
