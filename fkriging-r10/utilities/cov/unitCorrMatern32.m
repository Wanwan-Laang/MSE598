function [corr, dC] = unitCorrMatern32(sq3dist)
corr = (1+sq3dist) .* exp(-sq3dist);
if nargout > 1
    dC = -sq3dist .* exp(-sq3dist);
end
end




% % ver 0
% function [corr, dC] = unitCorrMatern32(sq3dist)
% 
% expTmp = exp(-sq3dist);
% corr = (1+sq3dist) .* expTmp;
% if nargout > 1
%    dC = -sq3dist .* expTmp;
% %    dC = -corr + expTmp;
% end
% 
% end


