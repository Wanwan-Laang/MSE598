function [corr_fcn_mix, corr_grad] = corr_scale_mix(dist, corr_fcn_handles, weights, scales)
% scale mixture of n correlation functions with a single scale parameter

sizeDist = size(dist);
nTerms = length(weights);

corr_fcn_mix = zeros(sizeDist);
if nargout > 1
    corr_grad = zeros([sizeDist nTerms*2]);
end

for ii=1:nTerms
    corr_handle = corr_fcn_handles{ii};
    
    if nargout > 1
        distScaled = dist / scales(ii);
        [cII, dcII] = corr_handle(distScaled);
        corr_fcn_mix = corr_fcn_mix + weights(ii) * cII;
        corr_grad(:,:,ii) = cII;
        corr_grad(:,:,ii+nTerms) = -(weights(ii)/scales(ii)) * (dcII .* distScaled);
        
%         [cII, dcII] = corr_handle(dist/scales(ii));
%         corr_fcn_mix = corr_fcn_mix + weights(ii) * cII;
%         corr_grad(:,:,ii) = cII;    % d(CorrMix)/d(Weights)
%         corr_grad(:,:,ii+nTerms) = - weights(ii)*( dcII .* dist / (scales(ii)^2) ); 
%                                     % d(corrMix)/d(Scales)
    else
        distScaled = dist / scales(ii);
        corr_fcn_mix = corr_fcn_mix + weights(ii) * corr_handle(distScaled);
    end
end


end