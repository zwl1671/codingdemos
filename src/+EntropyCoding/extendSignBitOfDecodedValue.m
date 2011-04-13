function [ value ] = extendSignBitOfDecodedValue( V, T )
%DECODEDCVALUE Summary of this function goes here
%   Detailed explanation goes here

% V == DIFF
% T = the DC value category

if T == 0
    value = 0;
else

    % Ref: CCITT Rec. T.81 (1992 E)	p.105, F.12
    
    % Top end of range
    Vt = 2^(T - 1);
    
    if V < Vt
        % Essentially sign extend the value. Must convert to a signed type.
        Vt = double(bitshift(-1, T) + 1);
        value = double(V) + Vt;
    else
        value = double(V);
    end
end

end