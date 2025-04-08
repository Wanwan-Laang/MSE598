function fPThis = filter_fill(hfLen,T0,envlGen)
    fPThis = struct('hfLen',hfLen);
    fPThis.filterCenter = hfLen+1;
    fPThis.filterMask = zeros(hfLen*2+1);
    
    nMax = 20;  % a sufficient large number
    nMax = -nMax:nMax;
    for ii=nMax
        for jj=nMax
            idxIJ = fPThis.filterCenter + [ii jj]*T0;
            idxIJ = round(idxIJ);
            isInLimit = and(idxIJ>=1, idxIJ<=size(fPThis.filterMask));
            if all(isInLimit) % if all nonzero, i.e., within idx limit
%                 disp([ii,jj,idxIJ])
                fPThis.filterMask(idxIJ(1),idxIJ(2)) = 1;
            end
        end
    end
    fPThis.filter = (fPThis.filterMask).*envlGen(hfLen);
end