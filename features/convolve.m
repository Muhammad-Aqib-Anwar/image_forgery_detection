% Input:       An array of size N * M * D1
% Output:      An array of size N * M * D2
% Description: Apply a set of predefined linear filters and
%              bias values to the input image to compute each
%              channel of the output image.

function out = convolve(in,filterbanks,biasvectors)
	out = zeros(size(in,1),size(in,2),size(filterbanks,4));
	for l = 1:size(filterbanks,4);   % do D2 times
		sum = double(zeros(size(in,1),size(in,2)));
		for k = 1:size(in,3);
			sum = sum+double(imfilter(in(:,:,k),filterbanks(:,:,k,l),'conv'));
		end
		out(:,:,l) = sum+biasvectors(l);
	end
end
