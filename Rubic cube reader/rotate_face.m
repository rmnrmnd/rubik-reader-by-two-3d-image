function [faces,adjacency_mat] = rotate_face(faces,adjacency_mat,face)

rotations = [1 2 3 4 5 6 7 8 9;
    7 4 1 8 5 2 9 6 3;
    9 8 7 6 5 4 3 2 1;
    3 6 9 2 5 8 1 4 7];
current_orientation = 1;
next_orientation = 2;

face2 = faces(face,:);

for i = 1:9
    faces(face,rotations(current_orientation,i)) = face2(1,rotations(next_orientation,i));
end

adjacency_mat_copy = adjacency_mat(face,:);
for i = 1:4
    adjacency_mat(face,rotations(current_orientation,2*i)/2) = adjacency_mat_copy(1,rotations(next_orientation,2*i)/2);
end

