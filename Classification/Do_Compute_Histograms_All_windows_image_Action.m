function tmp_hist=Do_Compute_Histograms_All_windows_image_Action(rgbImage,mapping5,mapping2,mapping4)
num_levels=3;
% num_levels=1;
tmp_hist=[];
[m n p]      = size(rgbImage);
x_lo = 1; x_hi = n;
y_lo = 1; y_hi = m;
for jj=1:num_levels
    x_step=(x_hi-x_lo)/jj;
    y_step=(y_hi-y_lo)/jj;
    for ll=1:jj
        for kk=1:jj
            x_11=round(x_lo+(kk-1)*x_step);
            x_22=round(x_11+x_step);
            y_11=round(y_lo+(ll-1)*y_step);
            y_22=round(y_11+y_step);
            
            width=x_22-x_11; height=y_22-y_11;
            img_crops = imcrop(rgbImage, [x_11 y_11 width height]);
            fg=Do_Compute_Histograms_each_window_image_Action(img_crops,mapping5,mapping2,mapping4);
        tmp_hist=[tmp_hist,fg];
        end
    end
end