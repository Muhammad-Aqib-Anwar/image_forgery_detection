function PHOG_result=Do_PHOG_Texture(im)
%



%%%% Parameter settings %%%%
image=imread(im);
bin = 40;
angle = 360;
L=1;
roi = [1;size(image,1);1;size(image,2)];

%%%%%%%%% Compute P HOG uptill L %%%%%%%%%
p = anna_phog(image,bin,angle,L,roi);

descriptor_points=p;




PHOG_result=descriptor_points;
