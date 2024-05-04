% Input:       An array of size N * M * D
% Output:      An array of the same size
% Description: A thresholding operation where any negative
%              numbers in the input become 0 in the output.

function out = relu(in)
	out = max(in, 0);
end
