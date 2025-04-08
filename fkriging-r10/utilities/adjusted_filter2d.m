function X_filtered = adjusted_filter2d(X, filterSpec)

sizeX = size(X);
X_filtered = zeros(sizeX);

envelope = filterSpec.filter;
envlSize = size(envelope);
envlCent = filterSpec.filterCenter;

% % % added for accerlated ver
[envX,envY] = find(filterSpec.filterMask);
envXY = [envX,envY];

for kk=1:prod(sizeX)
	[ii,jj] = ind2sub(sizeX,kk);
	subKK = [ii,jj];
	
	envSubLb = max(1, envlCent + (1-subKK) );
	% lb >=1; [ii,jj] + (lb-envelope_center) >=1;
	envSubUb = min(envlSize, envlCent + (sizeX-subKK) );
	% ub <= sizeEnv; [ii,jj] + (ub-envelope_center) <= sizeX;
	

    idxValid = (envXY >= envSubLb) & (envXY <= envSubUb);
    idxValid = idxValid(:,1) & idxValid(:,2);
    envVldXY = envXY(idxValid,:);
    
    envKK = sub2ind(envlSize, envVldXY(:,1),envVldXY(:,2));
    envVal = envelope(envKK);
    xSubs = subKK + (envVldXY - envlCent);
    xIdxs = sub2ind(sizeX, xSubs(:,1),xSubs(:,2));
    xVal = X(xIdxs);
    
    
% % %     envlEffective = envelope(envSubLb(1):envSubUb(1), envSubLb(2):envSubUb(2));
% % %     [envX,envY,envVal] = find(envlEffective); 
% % %     % find subscripts and values for nonzero vals in filter within the effective range
% % %     % note that envX and envY are with respect to envlEffective!
% % %     envX = envSubLb(1) + (envX - 1);
% % %     envY = envSubLb(2) + (envY - 1);
% % %     % now envX/Y are w.r.t. to envelope origin
% % %     xSubs = subKK + ([envX envY] - envlCent);
% % %     % corresponding subscripts in X
% % %     xIdxs = sub2ind(sizeX, xSubs(:,1),xSubs(:,2));
% % %     xVal = X(xIdxs);

    
    envVal = envVal / sum(envVal);
%     envVal = envVal / sum(envVal,'all');	
	X_filtered(kk) = xVal'*envVal;
% 	X_filtered(kk) = sum( xVal.*envVal, 'all' );

	
end
	
	
	
	