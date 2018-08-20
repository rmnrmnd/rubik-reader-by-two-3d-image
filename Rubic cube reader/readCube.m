function [Map,Neighborhood,err] = readCube(half1,half2)

%finding cube overall place as an binary map
[half1Image,labelsMap1,err1] = locate(half1);
[half2Image,labelsMap2,err2] = locate(half2);

%refering each pixel to a color
colorsMap1 = readColor(half1Image,labelsMap1);
colorsMap2 = readColor(half2Image,labelsMap2);

%displaying
figure;

subplot(2,3,1);imshow(half1Image);
subplot(2,3,4);imshow(half2Image);

if (err1+err2) == 0
    subplot(2,3,2);imshow(labelsMap1);
    subplot(2,3,5);imshow(labelsMap2);
    
    [Map,Neighborhood] = calculateMap(colorsMap1, colorsMap2);
	subplot(2,3,3);R=compileCube(Map,Neighborhood,1);
else
    if err1 == 0
    subplot(2,3,2);imshow(labelsMap1);
    end
    if err2 == 0
    subplot(2,3,5);imshow(labelsMap2);
    end
    Map = 1;
    Neighborhood = 1;
end

err = err1+err2;
