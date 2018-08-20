function [Map,adjacency_mat] = calculateMap(half1, half2)
half1(28:54,1:6) = half2(:,:);
Map = zeros(6,9);
for i = 1:6
    Map(i,5) = i;
end

guess_center_pieces = determine(1,0,half1);

guess_faces=guess_center_pieces;

load('constThreshs')

for j=1:6

%Fill in adjacency matrix for blue side
idx = find(guess_faces == j);
vector = adjacency_mat(idx,:);
side = find(vector==max(vector));
idx2 = find(colores_neighbor_matrix(:,side,j)==guess_faces(vector(side)));
for i = 1:4
    idx3 = find(guess_faces == colores_neighbor_matrix(idx2,i,j));
    adjacency_mat(idx,i) = idx3;
end

end


guess_side_pieces = determine(3,adjacency_mat,half1);
guess_corner_pieces = determine(2,adjacency_mat,half1);

sides = [2 4 6 8];
corners = [1 3 7 9];
for i = 1:6
    Map(i,5) = guess_center_pieces(i);
    for j = 1:4
        Map(i,sides(j)) = guess_side_pieces(i,j);
        Map(i,corners(j)) = guess_corner_pieces(i,j);
    end
end
