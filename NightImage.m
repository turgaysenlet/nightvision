function night = NightImage(image)
noiseAmount = 0.1;
lowerBound = -0.1;
upperBound = 0.2;

g=rgb2gray(image); 
g(:,:,2)=g; 
g(:,:,1)=g(:,:,2)/2.5; 
g(:,:,3)=g(:,:,2)/3.1;

%% Resize
night0 = im2single(g * 2.1 - 50) .^ single(0.5);

night = imresize(night0,.5);
night = imresize(night,2);
night(size(image,1),size(image,2),1) = image(size(image,1),size(image,2),1);
night = night(1:size(image,1),1:size(image,2),:);

H = fspecial('unsharp',0.1);
night1 = imfilter(night0,H,'replicate');
alpha2 = 0.15;
night = night * (1-alpha2) + night1 * alpha2;

% Fix size, if it has been crooped due to rounding
% Before noise
% g = exp(night(:,:,2))/exp(1);
% s = strel('disk',50);
% h = exp(night(:,:,2)*1.5)/exp(1)>0.99;
% gr = rgb2gray(im2double(image));
% t = ((gr .* (gr > 0.8))-0.8)*(1/(1-0.8));
% j = double(imdilate(t.*(t>0),s));
% H = fspecial('gaussian',50,10)/2;
% p = imfilter(j,H);
% n = night * 0.8 + gray2rgb(p)* 0.5;
% imshow([night n  gray2rgb(p)])
% night = n;
%% Noise
noise = randn([size(night,1) size(night,2)]) * noiseAmount;
noise = min(max(noise,lowerBound),upperBound);

night(:,:,1) = night(:,:,1) + noise / 2;
night(:,:,2) = night(:,:,2) + noise;
night(:,:,3) = night(:,:,3) + noise / 2;
%% Brightness glare
a=size(night,1);b=size(night,2);f=fspecial('gaussian',[a b],a*30); d=imnormalize(min(f(:))/20000+f-min(f(:)));%mesh(g);axis([0 b 0 a 0 1]);
night(:,:,1) = night(:,:,1) .* d;
night(:,:,2) = night(:,:,2) .* d;
night(:,:,3) = night(:,:,3) .* d;
%% Circular degredation
% After noise
%night2 = zeros([size(night,1),size(night,2)],'double');
%night2(floor(size(night2,1)/2),floor(size(night2,2)/2)) = 1;

end
