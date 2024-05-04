% Input:       An array of size 1 * 1 * D
% Output:      An array of the same size
% Description: Take a vector of arbitrary real numbers and
%              converts them into numbers that can be viewed
%              as probabilities, that is, all will lie between
%              0 and 1 and sum up to 1.

function out = softmax(in)
	a = max(in(1,1,:));
	s = sum(exp(in(1,1,:)-a));
	out = exp(in(1,1,:)-a)/s;
end
