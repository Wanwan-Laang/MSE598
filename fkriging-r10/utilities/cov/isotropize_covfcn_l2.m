function [covfcn_iso, h] = isotropize_covfcn_l2(cov_fcn, hList)

distL2 = sqrt(cov_fcn(:,:,2).^2 + cov_fcn(:,:,3).^2);
cov2d = cov_fcn(:,:,1);
count2d = cov_fcn(:,:,4);

binNum = length(hList)-1;
covh_bin = zeros(binNum,3); % mean,var,np
hList0 = [0 hList hList(end)];

for ii=1:binNum
	
	iii = ii+1;	% hList(ii) == hList0(iii)
    binIdx = (distL2>=(hList0(iii-1)+hList0(iii))/2) & ...
			 (distL2<(hList0(iii)+hList0(iii+1))/2) & (~isnan(cov2d));
	 
    binCov = cov2d(binIdx);
    binCount = count2d(binIdx);

    covh_bin(ii,1) = sum(binCov.*binCount) / sum(binCount);
    covh_bin(ii,2) = var(binCov);
    covh_bin(ii,3) = sum(binCount);
end

idxValid = ~isnan(covh_bin(:,1));
covfcn_iso = covh_bin(idxValid,:);
h = hList(idxValid);

end