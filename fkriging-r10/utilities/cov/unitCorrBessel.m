function [corr, dC] = unitCorrBessel(dist)
    
corr = besselj0(dist, 1);
% corr = besselj(0,dist*2*pi);

if nargout > 1
    dC = -besselj(1,dist);
end

end