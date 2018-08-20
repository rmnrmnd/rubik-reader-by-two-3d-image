clear
restart_training = 1;

color_balancing = 0;

file_list = {'Training\1.jpg';
    'Training\2.jpg';
    'Training\3.jpg';
    'Training\4.jpg';
    'Training\5.jpg';
    'Training\6.jpg';
    'Training\7.jpg';
    'Training\8.jpg';
    'Training\9.jpg';
    'Training\10.jpg';
    'Training\11.jpg';
    'Training\12.jpg';};

if restart_training == 1
    hsv = 0;
    yuv = 1;
    numCentroids1D = 9;
    if hsv==0
        centroids1D = 256*(linspace(1/numCentroids1D,1,numCentroids1D)-1/(2*numCentroids1D));
    else
        centroids1D = linspace(1/numCentroids1D,1,numCentroids1D)-1/(2*numCentroids1D);
    end
    countsFace3D = zeros(numCentroids1D,numCentroids1D,numCentroids1D,7);
    Train
else
    yuv = 1;
    load('training_results');
    Train
end

save('training_results','centroidClass','centroids1D','color_balancing','countsFace3D','hsv','numCentroids1D');


