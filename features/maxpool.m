% Input:       An array of size 2N * 2M * D
% Output:      An array of the size N * M * D
% Description: Operates on each channel separately, and assigns
%              output channel values by taking the maximum value
%              in each nonoverlapping 2 * 2 block of the input channel.

function out = maxpool(in)
	a = max(in(1:2:end,1:2:end,:),in(2:2:end,1:2:end,:));
	b = max(in(1:2:end,2:2:end,:),in(2:2:end,2:2:end,:));
	out = max(a,b);
end