function  [weighted_loss, loss_grad] = weighted_loss_corr(dist,corr,theta,corrfcn)
% corrfcn(d,theta)

idxValid = ~isnan(corr(:,1));
corr = corr(idxValid,:);
dist = dist(idxValid);

idxValid = (dist < 130);
corr = corr(idxValid,:);
dist = dist(idxValid);

[C,dC] = corrfcn(dist,theta); 
% for C - N*M, dC: N*M*lenTheta, here M=1 is required
dC = squeeze(dC);   % dC - N*lenTheta
lenTheta = length(theta);

empirical_corr = corr(:,1);
count = abs(corr(:,2));

err = C - empirical_corr;
% weights = count ./ ((dist+10).^2);
weights = count ./ ((dist+0.1).^2);
weighted_loss = sum( (err.^2) .* weights ) ;

if nargout > 1  % 
    loss_grad = sum( 2 * repmat(err.*weights, 1,lenTheta) .* dC );
    loss_grad = loss_grad';
end

end