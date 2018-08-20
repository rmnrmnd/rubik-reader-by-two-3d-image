function E = my_sharpen(A,bw_thresh)

[x,y,ch] = size(A);

B = zeros(size(A,1),size(A,2));

C=abs(double(A(1:x-4,:,:))-double(A(5:x,:,:)))<50;
D = A;
D(3:x-2,:,:) = double(D(3:x-2,:,:)).*double(C);

C=abs(double(A(:,1:y-4,:))-double(A(:,5:y,:)))<50;
E = A;
E(:,3:y-2,:) = double(E(:,3:y-2,:)).*double(C);

D = D > 0;
E = E > 0;
A = uint8(D).*A;
A = uint8(E).*A;

C = (double(A(:,:,1) >= A(:,:,2)) + double(A(:,:,1) >= A(:,:,3)))==2;
D = (double(A(:,:,2) >= A(:,:,1)) + double(A(:,:,2) >= A(:,:,3)))==2;
F = (double(A(:,:,3) >= A(:,:,1)) + double(A(:,:,3) >= A(:,:,2)))==2;
G = double(C).*double(A(:,:,1))+double(D).*double(A(:,:,2))+double(F).*double(A(:,:,3));
G = G ./(double(C)+double(D)+double(F));
G = rgb2gray(A);
E = G > 255*bw_thresh;
