function D = orient_sides(D)

imgProps = regionprops(D, 'Centroid');
Edge1 = [2 4 6 8];
Edge2 = Edge1+9;
Edge3 = Edge1+18;
distances = zeros(4,4);

for x = 1:4
    for y = 1:4
        distances(x,y) = sum((imgProps(Edge1(x)).Centroid - imgProps(Edge2(y)).Centroid).^2);
    end
end
[x,y] = find(distances == min(distances(:)));
if x == 4
    indx = find(D == 2);
    indx2 = find(D == 4);
    D(indx) = 4;
    D(indx2) = 2;
        
    indx = find(D == 6);
    indx2 = find(D == 8);
    D(indx) = 8;
    D(indx2) = 6;
        
    indx = find(D == 3);
    indx2 = find(D == 7);
    D(indx) = 7;
    D(indx2) = 3;
end

if y == 3
    indx = find(D == 2+9);
    indx2 = find(D == 4+9);
    D(indx) = 4+9;
    D(indx2) = 2+9;
    
    indx = find(D == 6+9);
    indx2 = find(D == 8+9);
    D(indx) = 8+9;
    D(indx2) = 6+9;
        
    indx = find(D == 3+9);
    indx2 = find(D == 7+9);
    D(indx) = 7+9;
    D(indx2) = 3+9;
end

imgProps = regionprops(D, 'Centroid');

for x = 1:4
    for y = 1:4
        distances(x,y) = sum((imgProps(Edge2(x)).Centroid - imgProps(Edge3(y)).Centroid).^2);
    end
end
[x,y] = find(distances == min(distances(:)));

if y == 3
    indx = find(D == 2+18);
    indx2 = find(D == 4+18);
    D(indx) = 4+18;
    D(indx2) = 2+18;
        
    indx = find(D == 6+18);
    indx2 = find(D == 8+18);
    D(indx) = 8+18;
    D(indx2) = 6+18;
        
    indx = find(D == 3+18);
    indx2 = find(D == 7+18);
    D(indx) = 7+18;
    D(indx2) = 3+18;
end