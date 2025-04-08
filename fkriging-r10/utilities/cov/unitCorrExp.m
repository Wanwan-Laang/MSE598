% function [corr, dC] = unitCorrExp(dist)
%     
% corr = exp(-dist);
% if nargout > 1
%     dC = -corr;
% end
% 
% end

function [x, dC] = unitCorrExp(x)
% about 5 percent faster than above
    
x = exp(-x);
if nargout > 1
    dC = -x;
end

end