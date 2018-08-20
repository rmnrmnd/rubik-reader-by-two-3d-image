file_list = {'Test\11.jpg';
    'Test\12.jpg';
    'Test\21.jpg';
    'Test\22.jpg';
    'Test\31.jpg';
    'Test\32.jpg';
    'Test\41.jpg';
    'Test\42.jpg';
    'Test\51.jpg'};
load('training_results');
colors = [0 0 0;
    0 0 185; % Blue
    0 179 0; % Green
    255 128 0; % Orange
    217 0 0; % Red
    255 255 255; % White
    255 255 0]; % Yellow

for i = 1:size(file_list,1)
    imgTest = imread(file_list{i});
    figure;
    subplot(4,2,7);imshow(uint8(imgTest));
    if hsv==1
        imgTest = rgb2hsv(imgTest);
    elseif yuv==1
        imgTest=rgb2yuv(imgTest);
    end
        
    for color = 1:6
    imgMask = zeros(size(imgTest,1), size(imgTest,2),3);
    [height, width, channels] = size(imgTest);
    for y = 1:height
        for x = 1:width
            pix = imgTest(y,x,:);
            for c = 1:3
                [minDist, idxRGB(c)] = min(abs(double(pix(c))-centroids1D));
            end
            if countsFace3D(idxRGB(1), idxRGB(2), idxRGB(3), color+1) > 0
                imgMask(y,x,1) = colors(color+1,1);
                imgMask(y,x,2) = colors(color+1,2);
                imgMask(y,x,3) = colors(color+1,3);
            end
            %{
            imgMask(y,x,1) = colors(centroidClass(idxRGB(1), idxRGB(2), idxRGB(3)),1);
            imgMask(y,x,2) = colors(centroidClass(idxRGB(1), idxRGB(2), idxRGB(3)),2);
            imgMask(y,x,3) = colors(centroidClass(idxRGB(1), idxRGB(2), idxRGB(3)),3);
            %}
        end
    end 
    subplot(4,2,color);imshow(uint8(imgMask));
    end
end
