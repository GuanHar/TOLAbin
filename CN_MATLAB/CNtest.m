clear;close all;
load('w2c_4096.mat');

im=double(imread('pic10.jpg'));%读取图片
%设定11个分类颜色的三通道典型值
color_values =     {  [0 0 0] , [0 0 1] , [.5 .4 .25] , [.5 .5 .5] , [0 1 0] , [1 .8 0] , [1 .5 1] , [1 0 1] , [1 0 0] , [1 1 1 ] , [ 1 1 0 ] };
RR=im(:,:,1);GG=im(:,:,2);BB=im(:,:,3);%拆分三通道为三张图

index_im = 1+floor(RR(:)/16)+16*floor(GG(:)/16)+16*16*floor(BB(:)/16);%计算目标像素的分类值，此处在FPGA中应/17以贴合定点运算，故*65536/17再>>16约等于*3855.05882(3855)>>16
%index_im2 = 1+floor(RR(:,:)/8)  +32*floor(GG(:,:)/8)    +32*32*floor(BB(:,:)/8)   ;
out=im;%定义输出图像
[max1,w2cM]=max(w2c,[],2); %固定步骤，可由此步骤的结果直接生成查询文件
%w2cM2=reshape(w2cM,size(im,1),size(im,2));
out2=reshape(w2cM(index_im(:)),size(im,1),size(im,2));%根据固定结果列查询典型值

%out2=w2cM2(index_im(:,:));
for jj=1:size(im,1)
    for ii=1:size(im,2) 
      out(jj,ii,:)=color_values{out2(jj,ii)}*255;%遍历像素处置为图像输出值
    end
end
out_med=out;
for i = 1:3
    out_med(:,:,i)=medfilt2(out(:,:,i),[5 5]);%自添加步骤，中值55滤波，去掉大片噪点
end


figure(1);%显示输出
subplot(1,2,1);imshow(uint8(im));
subplot(1,2,2);imshow(uint8(out_med));

