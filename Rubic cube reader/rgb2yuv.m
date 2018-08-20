function [out]=rgb2yuv(in)

%constants
wr=0.299;
wb=0.114;
wg=1-wr-wb;
umax = 0.5;
vmax = 0.5;

in = double(in);
r=in(:,:,1);
g=in(:,:,2);
b=in(:,:,3);

Y= wr*r +wg*g+wb*b;
U= umax*((b-Y)/(1-wb));
V=vmax* ((r-Y)/(1-wr));
U = U + 127.5;
V = V + 127.5;

out(:,:,1)=Y;
out(:,:,2)=U;
out(:,:,3)=V;