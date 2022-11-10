clc;
close all
test_image=imread('test17.jpg');
figure, imshow(test_image), title('Original Image')
[row, column, ch]=size(test_image);
alpha=15;
sigma1=15;
sigma2=80;
sigma3=250;
hsv_img=rgb2hsv(test_image);
hue=hsv_img(:,:,1);
saturation=hsv_img(:,:,2);
value=hsv_img(:,:,3);
figure,imshow(hue), title('Hue Image')
figure,imshow(saturation), title('Saturation Image')
figure,imshow(value), title('Intensity Image')
gaussian1 = fspecial('gaussian',alpha,sigma1);
gaussian2 = fspecial('gaussian',alpha,sigma2);
gaussian3 = fspecial('gaussian',alpha,sigma3);
image1=conv2(value,gaussian1,"same");
image2=conv2(value,gaussian2,'same');
image3=conv2(value,gaussian3,'same');

figure, imshow(image1), title('Gaussian image1,sigma=15')
figure, imshow(image2), title('Gaussian image2,sigma=80')
figure, imshow(image3), title('Gaussian image3,sigma=250')

multi_gaussian=1/3*image1+1/3*image2+1/3*image3;
figure, imshow(multi_gaussian), title('Multiscale Gaussian')

alpha1=0.9;
k1=alpha1*sum(saturation(:))/(row*column);
int_new1=value*(1+k1)./(max(value,multi_gaussian)+k1);
figure,imshow(value),title("input image")
figure, imshow(int_new1),title('alpha=0.9');

alpha2=0.7;
k2=alpha2*sum(saturation(:))/(row*column);
int_new2=value*(1+k2)./(max(value,multi_gaussian)+k2);
figure,imshow(int_new2),title('alpha=0.7');

alpha3=0.5;
k3=alpha3*sum(saturation(:))/(row*column);
int_new3=value*(1+k3)./(max(value,multi_gaussian)+k3);
figure,imshow(int_new3),title('alpha=0.5');

alpha4=0.3;
k4=alpha4*sum(saturation(:))/(row*column);
int_new4=value*(1+k4)./(max(value,multi_gaussian)+k4);
figure,imshow(int_new4),title('alpha=0.3');
alpha5=0.1;
k5=alpha5*sum(saturation(:))/(row*column);
int_new5=value*(1+k5)./(max(value,multi_gaussian)+k5);
figure,imshow(int_new5),title('alpha=0.1');

X1=value(:)';
X2=int_new5(:)';
X=[X1 X2];
C=cov(X1,X2);
[V,D] = eig(C);
diagD=diag(D);
if diagD(1)>diagD(2)
    Vnew=V(:,1);
else
    Vnew=V(:,2);
end
disp(C);
disp(V);
disp(D);
disp(Vnew);
weight1=Vnew(1)/(Vnew(1)+Vnew(2));
weight2=Vnew(2)/(Vnew(1)+Vnew(2));
Fused_image=weight1*value+weight2*int_new5;
figure, imshow(Fused_image), title('Fused Image')
output1(:,:,1)=hue;
output1(:,:,2)=saturation;
output1(:,:,3)=Fused_image;
Final_image = hsv2rgb(output1);
figure, imshow(Final_image), title('Output Image')

