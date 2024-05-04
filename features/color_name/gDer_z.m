function g = gDer_z( f, sigma_xy, sigma_z,order_z )

if (sigma_xy> 0) 
    f=gDer_MC(f, sigma_xy, 0,0);
end

K = ceil( 3 * sigma_z );
x = -K:K;
Gauss = exp( - x.^2 / (2*sigma_z.^2) );

if(order_z==0)
%     Gs=1;
    Gs = Gauss / sum(Gauss);
elseif(order_z==1)
    Gs  =  -(x/sigma_z^2).*Gauss;
    Gs  =  Gs./(sum(sum(x.*Gs)));
else
    Gs = (x.^2/sigma_z^4-1/sigma_z^2).*Gauss;
    Gs = Gs-sum(Gs)/size(x,2);
    Gs = Gs/sum(0.5*x.*x.*Gs);
end

Gs=reshape(Gs,1,1,length(Gs));
g = imfilter( f, Gs, 'replicate' );