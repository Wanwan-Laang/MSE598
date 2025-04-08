function cov_fcn = empirical_covfcn2d(X, subsList, range)
% assuming zero-mean
% cov_fcn(:,:,1) - cov fcn value
% cov_fcn(:,:,2:3) - coordinate
% cov_fcn(i,j,2:3) = [i,j]-(range+1) = [hi,hj]
% cov_fcn(:,:,4) - count

X = X-mean(X);
N = length(X);

cov_fcn = zeros([range*2+1,4]);

[gridI,gridJ] = ndgrid(-range(1):range(1), -range(2):range(2));
cov_fcn(:,:,2) = gridI;
cov_fcn(:,:,3) = gridJ;

% % % hI = repmat(subsList(:,1), 1,N) - repmat(subsList(:,1)',N,1);
% % % hJ = repmat(subsList(:,2), 1,N) - repmat(subsList(:,2)',N,1);
% % hI = subsList(:,1) - subsList(:,1)'; % much much faster than the repmat stuff...
% % hJ = subsList(:,2) - subsList(:,2)';
% % hInRange = and(abs(hI)<=range(1), abs(hJ)<=range(2));
% % hI = hI(hInRange);
% % hJ = hJ(hInRange);
% % 
% % hIdx = sub2ind(range*2+1, hI+range(1)+1, hJ+range(2)+1);
% % hI=[]; hJ=[];
% % 
% % XProd = X * X';
% % XProd = XProd(hInRange);
% % % use below instead in order to save memory




hJ = subsList(:,2) - subsList(:,2)'; 
hInRange = abs(hJ)<=range(2);
hJ = hJ(hInRange);

hI = subsList(:,1) - subsList(:,1)';
hI = hI(hInRange);
XProd = X * X';
XProd = XProd(hInRange);


hInRange = abs(hI)<=range(1);
hI = hI(hInRange);
hJ = hJ(hInRange);
XProd = XProd(hInRange);

hIdx = sub2ind(range*2+1, hI+range(1)+1, hJ+range(2)+1);
hI=[]; hJ=[];
hInRange = [];





tmpcov = zeros(range*2+1);
tmpnum = zeros(range*2+1);
    
% for ii = 1:length(hIdx)
%     hh = hIdx(ii);
%     tmpcov(hh) = tmpcov(hh) + XProd(ii);
%     tmpnum(hh) = tmpnum(hh) + 1;
% end
% % use sort to save loop iterations; ~20% improvements

[hIdx,idxOrder] = sort(hIdx);
XProd = XProd(idxOrder);

idxDiff = [1 1+find(diff(hIdx))' length(hIdx)+1];

XProdAcc = zeros(length(idxDiff)-1,1);
countAcc= zeros(length(idxDiff)-1,1);
for ii=1:length(idxDiff)-1
    tmpRange = idxDiff(ii):(idxDiff(ii+1)-1);
    XProdAcc(ii) = sum(XProd(tmpRange));
    countAcc(ii) = idxDiff(ii+1)-idxDiff(ii);
end
hIdx = hIdx(idxDiff(1:end-1));




for ii = 1:length(hIdx)
    hh = hIdx(ii);
    tmpcov(hh) = XProdAcc(ii);
    tmpnum(hh) = countAcc(ii);
end
        



cov_fcn(:,:,1) = tmpcov./tmpnum;
cov_fcn(:,:,4) = tmpnum;

end