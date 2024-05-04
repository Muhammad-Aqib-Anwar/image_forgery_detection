% Input:       An array of size N * M * D1
% Output:      An array of size 1 * 1 * D2
% Description: Apply a filter bank of D2 linear filters
%              and D2 scalar bias values to compute output values.

function out = fullconnect(in,filterbanks,biasvectors)
	out = zeros(1,1,size(filterbanks,4));
	for l = 1:size(filterbanks,4);
		sum = 0;
		for i = 1:size(in,1);
			for j = 1:size(in,2);
				for k = 1:size(in,3);
					sum = sum+filterbanks(i,j,k,l)*in(i,j,k);
				end
			end
		end
		out(:,:,l) = sum+biasvectors(l);
	end