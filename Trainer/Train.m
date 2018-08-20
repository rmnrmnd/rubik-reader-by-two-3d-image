for i = 1:size(file_list,1)
    imgTrain = imread(file_list{i});
    imgTrainMask = imread([file_list{i}(1:length(file_list{i})-4) '_mask.png']);
    if hsv==1
        imgTrain=rgb2hsv(imgTrain);
    elseif yuv==1
        imageTrain=rgb2yuv(imgTrain);
        
    end
    
       
    [height, width, channels] = size(imgTrain);
    for y = 1:height
        for x = 1:width
            pix = imgTrain(y,x,:);
            for c = 1:3
                [minDist, idxRGB(c)] = min(abs(double(pix(c))-centroids1D));
            end
            countsFace3D(idxRGB(1), idxRGB(2),idxRGB(3), imgTrainMask(y,x)+1) = countsFace3D(idxRGB(1), idxRGB(2),idxRGB(3),imgTrainMask(y,x)+1) + 1;
        end
    end
end

centroidClass = zeros(numCentroids1D,numCentroids1D,numCentroids1D);
for x = 1:numCentroids1D
    for y = 1:numCentroids1D
        for z = 1:numCentroids1D
            a=find(countsFace3D(x,y,z,:)==max(countsFace3D(x,y,z,2:7)));
            if length(a) > 1
                centroidClass(x,y,z) = 1;
            else
                centroidClass(x,y,z) = a;
            end
        end
    end
end

countsFace3D_sum = zeros(size(countsFace3D,1),size(countsFace3D,2),size(countsFace3D,3));
for x = 1:size(countsFace3D,1)
    for y = 1:size(countsFace3D,2)
        for z = 1:size(countsFace3D,3)
            countsFace3D_sum(x,y,z) = sum(countsFace3D(x,y,z,:));
        end
    end
end
