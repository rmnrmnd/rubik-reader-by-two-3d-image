function score = score(aim, guess_mat, localMap)
score = 0;
%center
if aim==1

for i = 1:6
    score = score+(1-guess_mat(5+(i-1)*9,localMap(i)))^2;
end
for i=[1,3,5]
	if length(find(localMap(1:3)==i))+length(find(localMap(1:3)==i+1))~=1
		score = score + 100;
	end
	if length(find(localMap(4:6)==i))+length(find(localMap(4:6)==i+1))~=1
		score = score + 100;
	end
end
for i=1:6
	if length(find(localMap==i))~=1
		score = score + 100;
	end
end

%corner
elseif aim==2

corners = [1 3 7 9];
for i = 1:6
    for j = 1:4
        score = score+(1-guess_mat(corners(j)+(i-1)*9,localMap(i,j)))^2;
    end
end

%sides
elseif aim==3

sides = [2 4 6 8];
for i = 1:6
    for j = 1:4
        score = score+(1-guess_mat(sides(j)+(i-1)*9,localMap(i,j)))^2;
    end
end
end