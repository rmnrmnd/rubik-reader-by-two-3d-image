function preMap = readColor(inImage,Mask)
load('training_results.mat');

%changing color space
	if yuv==1
		[inImage]=rgb2yuv(inImage);
	elseif hsv==1
		inImage = rgb2hsv(inImage);	
	end
	
	
preMap = zeros(27,6);

for j = 1:27
    [y,x] = find(Mask==j);    
    for z =1:length(y)    
        pix = inImage(y(z),x(z),:);        
        for c = 1:3        
            [minDist, idxRGB(c)] = min(abs(double(pix(c))-centroids1D));            
        end

        if countsFace3D_sum(idxRGB(1), idxRGB(2), idxRGB(3))>0
            for color = 1:6
                preMap(j,color) = preMap(j,color) + countsFace3D(idxRGB(1), idxRGB(2), idxRGB(3), color+1)/countsFace3D_sum(idxRGB(1), idxRGB(2), idxRGB(3)); 
            end
        end
    end
	
    if sum(preMap(j,:)) > 0    
        preMap(j,:) = preMap(j,:)/sum(preMap(j,:));    
    else
        preMap(j,:) = (preMap(j,:)+1)/6;
    end
    
end