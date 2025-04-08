function [betaSt, residual] = ols_fit(F, Y)
    % fit Y with F using OLS
    % Y = F*betaSt + residual
    scaleF = 1./ sqrt( sum(F.^2) );
    nPts = size(F,1);
    F = F.* scaleF(ones(nPts,1),:);
    betaSt = (F'*F)\(F'*Y);
    residual = Y - F*betaSt;
    betaSt = betaSt.*(scaleF');
end