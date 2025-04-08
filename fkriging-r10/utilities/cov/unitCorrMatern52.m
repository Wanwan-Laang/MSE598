function [corr, dC] = unitCorrMatern52(sq5dist)
if nargout > 1
    dC = -(1/3) * (sq5dist + sq5dist.^2).*exp(-sq5dist);
end
corr =  (1+sq5dist + (sq5dist.^2)/3).*exp(-sq5dist);
end



%% ver 0
% function [corr, dC] = unitCorrMatern52(sq5dist)
% 
% expTmp = exp(-sq5dist);
% corr =  (1+sq5dist + (sq5dist.^2)/3).*expTmp;  
% 
% % expTmp = exp(-sqrt(5)*dist);
% % corr =  (1+sqrt(5)*dist + 5/3*dist.^2).*expTmp;  
% 
% if nargout > 1
%     dC = -(1/3) * (sq5dist + sq5dist.^2).*expTmp;
% %     dC = -5/3 * (dist + sqrt(5)*dist.^2).*expTmp;
% end
% 
% end