function [outImage,Mask,err] = locate(inImageAddress)

outImage = imread(inImageAddress);

load('constThreshs');

err=1;

for i = 1:6
	
	%try to find first available sharpen threshold
	if err==0
		return;
	end
	
	err = 0;
	sharpenedImage= my_sharpen(outImage,0.05*i+0.05);
    
    

    Mask = zeros(size(sharpenedImage,1), size(sharpenedImage,2));
	
	%dilate the sharpend
    sharpenedImage = sharpenedImage.*imfill(~sharpenedImage,'holes');
    sharpenedImage = imfill(sharpenedImage,'holes');
    sharpenedImage = bwareaopen(sharpenedImage,round(areaThresh(1)*size(sharpenedImage,1)*size(sharpenedImage,2)));
	
    
	%filtering by area that centroid covered
	tempImage = zeros(size(sharpenedImage,1),size(sharpenedImage,2));
	areaThresh = areaThresh*size(sharpenedImage,1)*size(sharpenedImage,2);
	imgLabel = bwlabel(sharpenedImage,4);
	imgProps = regionprops(imgLabel, 'Area', 'Centroid','Eccentricity','Solidity');
	% Initial filter by area and centroid
	for nRegion = 1:length(imgProps)
		area = imgProps(nRegion).Area;
		centroid = imgProps(nRegion).Centroid;
		solidity = imgProps(nRegion).Solidity;
		eccentricity = imgProps(nRegion).Eccentricity;
		
		if (area > areaThresh(2) || area < areaThresh(1))
		elseif (centroid(1) < centroidThresh*size(sharpenedImage,2) || centroid(1) > (1-centroidThresh)*size(sharpenedImage,2))
		elseif (centroid(2) < centroidThresh*size(sharpenedImage,1) || centroid(2) > (1-centroidThresh)*size(sharpenedImage,1))
		elseif eccentricity > eccentricityThresh(2) || eccentricity < eccentricityThresh(1)
		elseif solidity < solidityThresh
		else
			idx = find(imgLabel == nRegion);
			tempImage(idx) = 1;
		end
	end
	sharpenedImage=tempImage;
	
	
	
    [nearstPixId, err] = findCentroid(sharpenedImage);
	
	load('centers');
	load('constThreshs');

    
	imgLabel = bwlabel(sharpenedImage);
    imgProps = regionprops(imgLabel,'Centroid');
    
    if err == 0
        for i = 1:3
        eval(sprintf('%s=%s;','centroidi',['centroid' num2str(i)]));
        if length(centroidi) < 4 || err ~= 0
            if err == 0
                err = 2;
            end
        else
            distances = zeros(1,length(centroidi));
            for j = 1:length(centroidi)
                distances(j) = sum((centroidi(nearstPixId(i),:)-centroidi(j,:)).^2);
            end
            [distances, index] = sort(distances);
            direction1 = centroidi(index(2),:)-centroidi(index(1),:);
            direction2 = centroidi(index(3),:)-centroidi(index(1),:);
            direction3 = centroidi(index(4),:)-centroidi(index(1),:);
            directions = [dot(direction1,direction2) dot(direction1,direction3) dot(direction2,direction3)];
            if min(directions) > 0
                if length(centroidi) > 4
                    direction3 = centroidi(index(5),:)-centroidi(index(1),:);
                    directions = [dot(direction1,direction2) dot(direction1,direction3) dot(direction2,direction3)];
                    if min(directions) > 0
                        err = 1;
                    end
                else
                    err = 1;
                end
            end
            if err == 0
                j = find(directions == min(directions));
                if j == 2
                    direction2 = direction3;
                elseif j == 3
                    direction1 = direction3;
                end 
            end


            aproxiCentroid = round([centroidi(index(1),:) + direction1;
									centroidi(index(1),:) + direction1*1.9;
									centroidi(index(1),:) + direction2;
									centroidi(index(1),:) + direction2+direction1;
									centroidi(index(1),:) + direction2+direction1*1.9;
									centroidi(index(1),:) + direction2*1.9;
									centroidi(index(1),:) + direction2*1.9+direction1;
									centroidi(index(1),:) + direction2*1.9+direction1*1.9]);
			real_delta = zeros(1,8);
            
            index = (round(centroidi(index(1),1)-1))*size(sharpenedImage,1)+round(centroidi(index(1),2));
            
            Label = imgLabel(index);
            if Label == 0
                err = 1;
            else
                idx = find(imgLabel == Label);
                Mask(idx) = 9*i;
                E = zeros(size(Mask,1),size(Mask,2));
                E(idx) = 1;
                E = imresize(E, 0.7);
                E = double(E > 0);
                EProps = regionprops(E, 'Centroid');
                Ecentroid = EProps(1).Centroid;
                [Ex,Ey] = find(E == 1);
            end
            for j = 1:8
                z = zeros(1,9);
                for x = 1:3
                    for y = 1:3
                        z((x-1)*3+y) = (aproxiCentroid(j,1)+2-x-1)*size(sharpenedImage,1)+(aproxiCentroid(j,2)+2-y);
                    end
                end
                nRegion = max(imgLabel(z));
                if (nRegion > 0)
                    idx = find(imgLabel == nRegion);
                    aproxiCentroid(j,:) = imgProps(nRegion).Centroid;
                    real_delta(j) = 1;
                    Mask(idx) = 9*i-j;
                end
            end
            if real_delta(5) == 0
                aproxiCentroid(5,:) = (aproxiCentroid(5,:)+aproxiCentroid(2,:)+(aproxiCentroid(4,:)-aproxiCentroid(1,:))+aproxiCentroid(4,:)+(aproxiCentroid(4,:)-aproxiCentroid(3,:)))/3;;
            end
            if real_delta(7) == 0
                aproxiCentroid(7,:) = (aproxiCentroid(7,:)+aproxiCentroid(6,:)+(aproxiCentroid(4,:)-aproxiCentroid(3,:))+aproxiCentroid(4,:)+(aproxiCentroid(4,:)-aproxiCentroid(1,:)))/3;
            end
            if real_delta(8) == 0
                aproxiCentroid(8,:) = (aproxiCentroid(8,:)+aproxiCentroid(7,:)+(aproxiCentroid(7,:)-aproxiCentroid(6,:))+aproxiCentroid(5,:)+(aproxiCentroid(5,:)-aproxiCentroid(2,:)))/3;
            end
            for j = 1:8
                if real_delta(j) == 0
                    E = zeros(size(Mask,1),size(Mask,2));
                    x = round(Ex-(Ecentroid(2))+(aproxiCentroid(j,2)));
                    y = round(Ey-(Ecentroid(1))+(aproxiCentroid(j,1)));
                    index = (y-1)*size(Mask,1)+x;
                    E(index) = 1;
                    Mask = Mask + E*(9*i-j);
                end
            end
			
			couplesVector=[1,2;3,4;4,5;6,7;1,4;4,7;2,5;5,8];
			
			for j = 1:8
            dist(j) = sum((aproxiCentroid(couplesVector(1),:)-aproxiCentroid(couplesVector(2),:)).^2);
			end
			
            if min(dist)/max(dist) < 0.3
                err = 1;
            end
        end
        end
    end
    % Orient cube properly
    if err == 0
        Mask = orient_sides(Mask);
    end
end



