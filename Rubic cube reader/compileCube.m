function R = compileCube(faces,adjacency_mat,n)

orientations = [1 5 3;
    1 3 6;
    1 4 5;
    1 6 4;
    2 3 5;
    2 6 3;
    2 5 4;
    2 4 6];

R=zeros(3,3,6);
for n=[1,8]
center(1) = find(faces(:,5)==orientations(n,1));
center(2) = find(faces(:,5)==orientations(n,2));
center(3) = find(faces(:,5)==orientations(n,3));

while adjacency_mat(center(1),4) ~= center(3)
    [faces,adjacency_mat]=rotate_face(faces,adjacency_mat,center(1));
end

while adjacency_mat(center(2),1) ~= center(1)
    [faces,adjacency_mat]=rotate_face(faces,adjacency_mat,center(2));
end

while adjacency_mat(center(3),1) ~= center(1)
    [faces,adjacency_mat]=rotate_face(faces,adjacency_mat,center(3));
end

f1 = faces(center(1),:);
f2 = faces(center(2),:);
f3 = faces(center(3),:);

if n==1
R(:,:,2)=vec2mat(f1,3);
R(:,:,5)=vec2mat(f2,3);
R(:,:,3)=vec2mat(f3,3);
elseif n==8
R(:,:,4)=vec2mat(f1,3);
R(:,:,1)=vec2mat(f2,3);
R(:,:,6)=vec2mat(f3,3);
end
end

R=(R==1)*2+(R==2)*4+(R==3)*3+(R==4)*1+(R==5)*5+(R==6)*6;
disp(R);
rubplot(R);

    