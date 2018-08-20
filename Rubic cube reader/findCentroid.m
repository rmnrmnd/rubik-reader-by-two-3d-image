function [nearstPixId,err] = findCentroid(inImage)

err = 0;


imgLabel = bwlabel(inImage,4);
imgProps = regionprops(imgLabel, 'Orientation', 'Centroid');


orientations = zeros(length(imgProps),1);

for i = 1:length(imgProps)
    orientations(i) = imgProps(i).Orientation;
end

if length(orientations) < 12
    err = 1;
    centroid1 = 0;
    centroid2 = 0;
    centroid3 = 0;
    nearstPixId = 0;
    return
end

side = clusterdata(orientations,3);
a = 1; b = 1; c = 1;
centroid1 = zeros(length(find(side == 1)),2);
centroid2 = zeros(length(find(side == 2)),2);
centroid3 = zeros(length(find(side == 3)),2);
for i = 1:length(imgProps)
    idx = find(imgLabel == i);
    inImage(idx) = side(i)*9;
    if side(i) == 1
        centroid1(a,:) = imgProps(i).Centroid;
        a = a + 1;
    elseif side(i) == 2
        centroid2(b,:) = imgProps(i).Centroid;
        b = b + 1;
    else
        centroid3(c,:) = imgProps(i).Centroid;
        c = c + 1;
    end
end


nearstPixDist = sum((centroid1(1,:)-centroid2(1,:)).^2)+sum((centroid1(1,:)-centroid3(1,:)).^2)+sum((centroid2(1,:)-centroid3(1,:)).^2);
nearstPixId = [1 1 1];
for a = 1:length(find(side == 1))
    for b = 1:length(find(side == 2))
        for c = 1:length(find(side == 3))
            total_dist = sum((centroid1(a,:)-centroid2(b,:)).^2)+sum((centroid1(a,:)-centroid3(c,:)).^2)+sum((centroid2(b,:)-centroid3(c,:)).^2);
            if total_dist < nearstPixDist
                nearstPixDist = total_dist;
                nearstPixId = [a b c];
            end
        end
    end
end
dist1 = sum((centroid1(nearstPixId(1),:)-centroid2(nearstPixId(2),:)).^2);
dist2 = sum((centroid1(nearstPixId(1),:)-centroid3(nearstPixId(3),:)).^2);
dist3 = sum((centroid2(nearstPixId(2),:)-centroid3(nearstPixId(3),:)).^2);
meandist = mean([dist1 dist2 dist3]);
if abs(dist1-meandist) > 0.2*meandist || abs(dist2-meandist) > 0.2*meandist || abs(dist3-meandist) > 0.2*meandist
    err = 1;
end

%%%%reordering sides
	if err==0
		if centroid2(nearstPixId(2),2) < centroid1(nearstPixId(1),2)
			centroid4 = centroid2;
			centroid2 = centroid1;
			centroid1 = centroid4;
			a = nearstPixId(2);
			nearstPixId(2) = nearstPixId(1);
			nearstPixId(1) = a;
		end
		if centroid3(nearstPixId(3),2) < centroid1(nearstPixId(1),2)
			centroid4 = centroid3;
			centroid3 = centroid1;
			centroid1 = centroid4;
			a = nearstPixId(3);
			nearstPixId(3) = nearstPixId(1);
			nearstPixId(1) = a;
		end
		if centroid2(nearstPixId(2),1) < centroid3(nearstPixId(3),1)
			centroid4 = centroid3;
			centroid3 = centroid2;
			centroid2 = centroid4;
			a = nearstPixId(3);
			nearstPixId(3) = nearstPixId(2);
			nearstPixId(2) = a;
		end
	end

save('centers','centroid1','centroid2','centroid3');