
function [gimage]=image_energy(i)
% i=imread('fake00014.png');

r=i(:,:,1);g=i(:,:,2);b=i(:,:,3);

reng=(sqrt(double(r(:,:).^(2)+g(:,:).^(2)+b(:,:).^(2)))./double(r(:,:)));
geng=(sqrt(double(r(:,:).^(2)+g(:,:).^(2)+b(:,:).^(2)))./double(g(:,:)));
beng=(sqrt(double(r(:,:).^(2)+g(:,:).^(2)+b(:,:).^(2)))./double(b(:,:)));
imgeng=cat(3,reng,geng,beng);
gimage=rgb2gray(imgeng) ;
%r_ent=edge(r,'Canny');
%g_ent=edge(g,'Canny');
%b_ent=edge(b,'Canny');


%imgedge=cat(3,reng,geng,beng);
%imgSet{1}=imgeng;
%imgSet{2}=imgedge;
% dft=real(fft(imgeng));

end