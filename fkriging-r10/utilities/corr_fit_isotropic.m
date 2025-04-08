function corrFit = corr_fit_isotropic(empCov, cfParam, saRatio)
       empCorr = empCov;
       sizeCorr = size(squeeze(empCorr(:,:,1)));
       sizeCorr = (sizeCorr+1)/2;       % assumed symmetric
       empCorr(:,:,1) = empCorr(:,:,1)/empCorr(sizeCorr(1),sizeCorr(2),1);  % standardize

       distL2 = sqrt(empCorr(:,:,2).^2 + empCorr(:,:,3).^2);
       distMax = max(distL2(:)/sqrt(2));
       h = (0:1/3:distMax);
       [corrIso,h] = isotropize_covfcn_l2(empCorr,h);
       % squeeze into bins; approximately equivalent to using
       % the empirical corr directly

       parNum = length(cfParam.handles);
       corrFcn = @(dist,theta) corr_scale_mix(dist,cfParam.handles,...
                            theta(1:parNum),theta(parNum+1:end)); 
       lossFcn = @(th) weighted_loss_corr(h', ...
                            corrIso(:,[1 3]), th, corrFcn);
       
       optTmp = optimoptions('fmincon','display','off','SpecifyObjectiveGradient',true);
       problem = createOptimProblem('fmincon','objective',lossFcn,...
                  'x0',cfParam.init,'Aineq',[],'bineq',[],...
                  'Aeq',[ones(1,parNum) zeros(1,parNum)],'beq',1,...
                  'lb',cfParam.lb,'ub',cfParam.ub,'nonlcon',[],'options',optTmp);
%                    gs = GlobalSearch('Display','iter');
       gs = GlobalSearch('Display','off');
       [thetaSt,~] = run(gs,problem);


       % isotropize for visulaization 
       %(not for simpler fitting, so bins are larger for smoothness)
       binSize = mean(saRatio);
       h = [0 binSize (binSize*2 : (binSize*0.8) : distMax)];
       [corrIso,h] = isotropize_covfcn_l2(empCorr,h);

       corrFit = struct;
       corrFit.mixFcn = cfParam.handles;
       corrFit.mixFcnFast = cfParam.handleFast;
       corrFit.paramFitted = thetaSt;
       corrFit.corrIso = {h, corrIso};

end