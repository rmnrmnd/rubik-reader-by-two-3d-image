function results = determine(aim,neighborhood,input)
%center
if aim==1

aproxiorientations = zeros(1,6);

possible_orientations = [1 6 4;
    1 3 6;
    1 5 3;
    1 4 5;
    2 5 4;
    2 3 5;
    2 6 3;
    2 4 6;
    3 1 6;
    3 5 1;
    3 2 5;
    3 6 2;
    4 6 1;
    4 1 5;
    4 5 2;
    4 2 6;
    5 4 2;
    5 1 4;
    5 3 1;
    5 2 3;
    6 2 4;
    6 4 1;
    6 1 3;
    6 3 2];
aproxiorientations = [1 6 4 2 3 5];
score_min = score(1,input,aproxiorientations);
aproxiorientations_2 = zeros(1,6);

for i = 1:24
    for j = 1:24
        if i ~= j
            aproxiorientations_2(1) = possible_orientations(i,1);
            aproxiorientations_2(2) = possible_orientations(i,2);
            aproxiorientations_2(3) = possible_orientations(i,3);
            aproxiorientations_2(4) = possible_orientations(j,1);
            aproxiorientations_2(5) = possible_orientations(j,2);
            aproxiorientations_2(6) = possible_orientations(j,3);
            score_new = score(1,input, aproxiorientations_2);
            if score_new < score_min
                score_min = score_new;
                aproxiorientations = aproxiorientations_2;
            end
        end
    end
end
results=aproxiorientations;

%corners
elseif aim==2
corner_color_poss = zeros(6,6,6);
corner_color_poss(1,3,5) = 1;
corner_color_poss(1,3,6) = 1;
corner_color_poss(1,4,5) = 1;
corner_color_poss(1,4,6) = 1;
corner_color_poss(2,3,5) = 1;
corner_color_poss(2,3,6) = 1;
corner_color_poss(2,4,5) = 1;
corner_color_poss(2,4,6) = 1;

aproxicorner_pieces = zeros(6,4);

orientations = [1 2 3;
    1 3 2;
    2 3 1;
    2 1 3;
    3 1 2;
    3 2 1];

corners = [1 3 7 9];
side(1) = 1;
for i = 4:6
    if isempty(find(neighborhood(1,:)==i, 1))
        side(2) = i;
    end
end

for i = 1:2
    for j = 1:4
        if j == 1
            side1 = neighborhood(side(i),1);
            side2 = neighborhood(side(i),2);
        elseif j == 2
            side1 = neighborhood(side(i),1);
            side2 = neighborhood(side(i),3);
        elseif j == 3
            side1 = neighborhood(side(i),2);
            side2 = neighborhood(side(i),4);
        elseif j == 4
            side1 = neighborhood(side(i),3);
            side2 = neighborhood(side(i),4);
        end
        % Determine side1 corner
        a = find(neighborhood(side1,:)==side(i));
        b = find(neighborhood(side1,:)==side2);
        if (a == 1 && b == 2) || (a == 2 && b == 1)
            k=1;
        elseif (a == 1 && b == 3) || (a == 3 && b == 1)
            k=2;
        elseif (a == 2 && b == 4) || (a == 4 && b == 2)
            k=3;
        elseif (a == 3 && b == 4) || (a == 4 && b == 3)
            k=4;
        end
        % Determine side2 corner
        a = find(neighborhood(side2,:)==side(i));
        b = find(neighborhood(side2,:)==side1);
        if (a == 1 && b == 2) || (a == 2 && b == 1)
            l=1;
        elseif (a == 1 && b == 3) || (a == 3 && b == 1)
            l=2;
        elseif (a == 2 && b == 4) || (a == 4 && b == 2)
            l=3;
        elseif (a == 3 && b == 4) || (a == 4 && b == 3)
            l=4;
        end
        vector1 = input(corners(j)+(side(i)-1)*9,:);
        vector2 = input(corners(k)+(side1-1)*9,:);
        vector3 = input(corners(l)+(side2-1)*9,:);
        vector = zeros(6,6,6);
        for a = 1:6
            for b = 1:6
                for c = 1:6
                    vector(a,b,c) = vector1(a)+vector2(b)+vector3(c);
                end
            end
        end
        found_valid_piece = 0;
        while found_valid_piece == 0
            a = find(vector == max(vector(:)));
            [a,b,c] = ind2sub(size(vector),a(1));
            color_vector = sort([a b c]);
            if corner_color_poss(color_vector(1),color_vector(2),color_vector(3)) == 1
                found_valid_piece = 1;
                corner_color_poss(color_vector(1),color_vector(2),color_vector(3)) = 0;
                aproxicorner_pieces(side(i),j) = a;
                aproxicorner_pieces(side1,k) = b;
                aproxicorner_pieces(side2,l) = c;
            else
                vector(a,b,c) = -1;
            end
        end
    end
end

score_min = score(2,input,aproxicorner_pieces);

found_new_min = 1;
while found_new_min == 1
    found_new_min = 0;
    for i = 1:2
        for j = 1:4
            if j == 1
                side1 = neighborhood(side(i),1);
                side2 = neighborhood(side(i),2);
            elseif j == 2
                side1 = neighborhood(side(i),1);
                side2 = neighborhood(side(i),3);
            elseif j == 3
                side1 = neighborhood(side(i),2);
                side2 = neighborhood(side(i),4);
            elseif j == 4
                side1 = neighborhood(side(i),3);
                side2 = neighborhood(side(i),4);
            end
            a = find(neighborhood(side1,:)==side(i));
            b = find(neighborhood(side1,:)==side2);
            if (a == 1 && b == 2) || (a == 2 && b == 1)
                corner1=1;
            elseif (a == 1 && b == 3) || (a == 3 && b == 1)
                corner1=2;
            elseif (a == 2 && b == 4) || (a == 4 && b == 2)
                corner1=3;
            elseif (a == 3 && b == 4) || (a == 4 && b == 3)
                corner1=4;
            end
            % Determine side2 corner
            a = find(neighborhood(side2,:)==side(i));
            b = find(neighborhood(side2,:)==side1);
            if (a == 1 && b == 2) || (a == 2 && b == 1)
                corner2=1;
            elseif (a == 1 && b == 3) || (a == 3 && b == 1)
                corner2=2;
            elseif (a == 2 && b == 4) || (a == 4 && b == 2)
                corner2=3;
            elseif (a == 3 && b == 4) || (a == 4 && b == 3)
                corner2=4;
            end
            for k = i:2
                for l = 1:4
                    if k ~= i || j ~= l
                        if l == 1
                            side1_2 = neighborhood(side(i),1);
                            side2_2 = neighborhood(side(i),2);
                        elseif l == 2
                            side1_2 = neighborhood(side(i),1);
                            side2_2 = neighborhood(side(i),3);
                        elseif l == 3
                            side1_2 = neighborhood(side(i),2);
                            side2_2 = neighborhood(side(i),4);
                        elseif l == 4
                            side1_2 = neighborhood(side(i),3);
                            side2_2 = neighborhood(side(i),4);
                        end
                        a = find(neighborhood(side1,:)==side(i));
                        b = find(neighborhood(side1,:)==side2);
                        if (a == 1 && b == 2) || (a == 2 && b == 1)
                            corner1_2=1;
                        elseif (a == 1 && b == 3) || (a == 3 && b == 1)
                            corner1_2=2;
                        elseif (a == 2 && b == 4) || (a == 4 && b == 2)
                            corner1_2=3;
                        elseif (a == 3 && b == 4) || (a == 4 && b == 3)
                            corner1_2=4;
                        end
                        % Determine side2 corner
                        a = find(neighborhood(side2,:)==side(i));
                        b = find(neighborhood(side2,:)==side1);
                        if (a == 1 && b == 2) || (a == 2 && b == 1)
                            corner2_2=1;
                        elseif (a == 1 && b == 3) || (a == 3 && b == 1)
                            corner2_2=2;
                        elseif (a == 2 && b == 4) || (a == 4 && b == 2)
                            corner2_2=3;
                        elseif (a == 3 && b == 4) || (a == 4 && b == 3)
                            corner2_2=4;
                        end
                        for m = 1:6
                            for n = 1:6
                                aproxicorner_pieces_2 = aproxicorner_pieces;
                                sides_1 = [side(i) side1 side2];
                                corners_1 = [j corner1 corner2];
                                sides_2 = [side(k) side1_2 side2_2];
                                corners_2 = [l corner1_2 corner2_2];
                                aproxicorner_pieces_2(sides_1(1),corners_1(1)) = aproxicorner_pieces(sides_2(orientations(m,1)),corners_2(orientations(m,1)));
                                aproxicorner_pieces_2(sides_1(2),corners_1(2)) = aproxicorner_pieces(sides_2(orientations(m,2)),corners_2(orientations(m,2)));
                                aproxicorner_pieces_2(sides_1(3),corners_1(3)) = aproxicorner_pieces(sides_2(orientations(m,3)),corners_2(orientations(m,3)));
                                aproxicorner_pieces_2(sides_2(1),corners_2(1)) = aproxicorner_pieces(sides_1(orientations(n,1)),corners_1(orientations(n,1)));
                                aproxicorner_pieces_2(sides_2(2),corners_2(2)) = aproxicorner_pieces(sides_1(orientations(n,2)),corners_1(orientations(n,2)));
                                aproxicorner_pieces_2(sides_2(3),corners_2(3)) = aproxicorner_pieces(sides_1(orientations(n,3)),corners_1(orientations(n,3)));
                                score_new = score(2,input,aproxicorner_pieces_2);
                                if score_new < score_min
                                    score_min = score_new;
                                    aproxicorner_pieces = aproxicorner_pieces_2;
                                    found_new_min = 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
results=aproxicorner_pieces;

%sides
elseif aim==3

side_pieces_possibilities = [0 0 1 1 1 1;
    0 0 1 1 1 1;
    1 1 0 0 1 1;
    1 1 0 0 1 1;
    1 1 1 1 0 0;
    1 1 1 1 0 0];

aproxiside_pieces = zeros(6,4);
sides = [2 4 6 8];
for i = 1:6
    for j = 1:4
        if i < neighborhood(i,j)
            vector1 = input(sides(j)+(i-1)*9,:);
            other_face = neighborhood(i,j);
            other_face_side = find(neighborhood(other_face,:)==i);
            vector2 = input(sides(other_face_side)+(other_face-1)*9,:);
            vector3 = zeros(6,6);
            for k = 1:6
                for l = 1:6
                    vector3(k,l) = vector1(k)+vector2(l);
                end
            end
            found_valid_piece = 0;
            while found_valid_piece == 0
                [a,b] = find(vector3 == max(vector3(:)));
                if side_pieces_possibilities(a(1),b(1)) == 1
                    found_valid_piece = 1;
                    side_pieces_possibilities(a(1),b(1)) = 0;
                    side_pieces_possibilities(b(1),a(1)) = 0;
                    aproxiside_pieces(i,j) = a(1);
                    aproxiside_pieces(other_face,other_face_side) = b(1);
                else
                    vector3(a(1),b(1)) = -1;
                end
            end
        end
    end
end

score_min = score(3,input,aproxiside_pieces);

found_new_min = 1;
while found_new_min == 1
    found_new_min = 0;
    for i = 1:6
        for j = 1:4
            for k = i:6
                for l = 1:4
                    if (i ~= k || j ~= l) && i < neighborhood(i,j) && k < neighborhood(k,l)
                        if found_new_min == 0
                            other_face_1 = neighborhood(i,j);
                            other_face_side_1 = find(neighborhood(other_face_1,:)==i);
                            other_face_2 = neighborhood(k,l);
                            other_face_side_2 = find(neighborhood(other_face_2,:)==k);
                            aproxiside_pieces_2 = aproxiside_pieces;
                            aproxiside_pieces_2(i,j) = aproxiside_pieces(k,l);
                            aproxiside_pieces_2(other_face_1,other_face_side_1) = aproxiside_pieces(other_face_2,other_face_side_2);
                            aproxiside_pieces_2(k,l) = aproxiside_pieces(i,j);
                            aproxiside_pieces_2(other_face_2,other_face_side_2) = aproxiside_pieces(other_face_1,other_face_side_1);
                            score_new = score(3,input, aproxiside_pieces_2);
                            if score_new < score_min
                                score_min = score_new;
                                aproxiside_pieces = aproxiside_pieces_2;
                                found_new_min = 1;
                            end
                        end
                        if found_new_min == 0
                            other_face_1 = neighborhood(i,j);
                            other_face_side_1 = find(neighborhood(other_face_1,:)==i);
                            other_face_2 = neighborhood(k,l);
                            other_face_side_2 = find(neighborhood(other_face_2,:)==k);
                            aproxiside_pieces_2 = aproxiside_pieces;
                            aproxiside_pieces_2(i,j) = aproxiside_pieces(other_face_2,other_face_side_2);
                            aproxiside_pieces_2(other_face_1,other_face_side_1) = aproxiside_pieces(k,l);
                            aproxiside_pieces_2(k,l) = aproxiside_pieces(i,j);
                            aproxiside_pieces_2(other_face_2,other_face_side_2) = aproxiside_pieces(other_face_1,other_face_side_1);
                            score_new = score(3,input, aproxiside_pieces_2);
                            if score_new < score_min
                                score_min = score_new;
                                aproxiside_pieces = aproxiside_pieces_2;
                                found_new_min = 1;
                            end
                        end
                        if found_new_min == 0
                            other_face_1 = neighborhood(i,j);
                            other_face_side_1 = find(neighborhood(other_face_1,:)==i);
                            other_face_2 = neighborhood(k,l);
                            other_face_side_2 = find(neighborhood(other_face_2,:)==k);
                            aproxiside_pieces_2 = aproxiside_pieces;
                            aproxiside_pieces_2(i,j) = aproxiside_pieces(k,l);
                            aproxiside_pieces_2(other_face_1,other_face_side_1) = aproxiside_pieces(other_face_2,other_face_side_2);
                            aproxiside_pieces_2(k,l) = aproxiside_pieces(other_face_1,other_face_side_1);
                            aproxiside_pieces_2(other_face_2,other_face_side_2) = aproxiside_pieces(i,j);
                            score_new = score(3,input, aproxiside_pieces_2);
                            if score_new < score_min
                                score_min = score_new;
                                aproxiside_pieces = aproxiside_pieces_2;
                                found_new_min = 1;
                            end
                        end
                        if found_new_min == 0
                            other_face_1 = neighborhood(i,j);
                            other_face_side_1 = find(neighborhood(other_face_1,:)==i);
                            other_face_2 = neighborhood(k,l);
                            other_face_side_2 = find(neighborhood(other_face_2,:)==k);
                            aproxiside_pieces_2 = aproxiside_pieces;
                            aproxiside_pieces_2(i,j) = aproxiside_pieces(other_face_2,other_face_side_2);
                            aproxiside_pieces_2(other_face_1,other_face_side_1) = aproxiside_pieces(k,l);
                            aproxiside_pieces_2(k,l) = aproxiside_pieces(other_face_1,other_face_side_1);
                            aproxiside_pieces_2(other_face_2,other_face_side_2) = aproxiside_pieces(i,j);
                            score_new = score(3,input, aproxiside_pieces_2);
                            if score_new < score_min
                                score_min = score_new;
                                aproxiside_pieces = aproxiside_pieces_2;
                                found_new_min = 1;
                            end
                        end
                    end
                end
            end
        end
    end
end
results=aproxiside_pieces;

end