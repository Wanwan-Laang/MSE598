function krigResult = kriging(X,Y,frameSize, corrFcn, basisFcn, batchsize)

t1 = tic;
R = corrFcn(X,X);
linsolveOpts.SYM = true;
% linsolveOpts.POSDEF = true;
fprintf("corr matrix computed in %.2f s, ", toc(t1));


t1 = tic;
RinvY = linsolve(R,Y,linsolveOpts);
if isempty(basisFcn)
    R = []; % free memory
else
    F = basisFcn(X);
    scaledAmpF = sqrt( sum(R(:,1).^2) ); % standardize the norm of cols of F to scaledAmpF
    scaleF = sqrt( sum(F.^2) );
    scaleF = scaledAmpF * (1./scaleF);
    nPts = size(F,1);
    F = F .* scaleF(ones(nPts,1),:); 
    % equivalent basisFcn = basisFcn.*scaleF(ones(nRow,1), :)
    
    RinvF = linsolve(R,F,linsolveOpts);
    R = []; % free memory

    betah = linsolve( (F'*RinvF), (F'*RinvY), linsolveOpts);
    F = [];
    RinvYmFbet = RinvY - RinvF*betah;
end 
fprintf("linear system solved in %.2f s\n", toc(t1));


krigResult = zeros(frameSize);
ll = length(krigResult(:));
t1 = tic;
fprintf("processing batch: ")
for jj=1:ceil(ll/batchsize)
%    textwaitbar(jj,ceil(ll/batchsize),"processing batch");
    fprintf("%d of %d; ", jj,ceil(ll/batchsize));

    idx = ((jj-1)*batchsize+1):(min(jj*batchsize,ll));
    [idx1, idx2] = ind2sub(frameSize,idx);
    subTmp = [idx1', idx2'];

    if isempty(basisFcn)
        krigResult(idx) = corrFcn(subTmp,X)*RinvY;
    else
        fBetah = basisFcn(subTmp) * ( betah.* (scaleF') );
%         fBetah = basisFcn(subTmp) * betah;
        krigResult(idx) = fBetah + corrFcn(subTmp,X)*RinvYmFbet;
    end
end
fprintf("\n kriging completed in %.2f s\n", toc(t1));


end


