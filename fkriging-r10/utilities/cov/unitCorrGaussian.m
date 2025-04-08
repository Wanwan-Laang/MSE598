function [corr, dC] = unitCorrGaussian(dist)
    
corr = exp(-dist.^2);
if nargout > 1
    dC = -2 * dist .* corr;
end

end