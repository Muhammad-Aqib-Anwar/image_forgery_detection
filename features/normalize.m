% Input:       A color image array of size N * M * 3
% Output:      An array of the same size
% Description: Approximately scales each color channel’s
%              pixel values into the output range -0.5 to 0.5.


function out = normalize(in)
    out = in./255.0 + 1;
end