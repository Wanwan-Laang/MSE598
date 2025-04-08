function j0 = besselj0(x,approxOrder)

switch approxOrder
    case 1
        qCoef = [1.95 1.00];
        pCoef = [1.10 1.35];
        PCoef = [1.10 1.00];
    case 2
        qCoef = [11.24 12.46 1.000];
        pCoef = [6.343 10.99 3.550];
        PCoef = [6.343 9.406 1.000];
    otherwise  % use third order approximation by default
        qCoef = [2.6424 10.831 10.359 1];
        pCoef = [1.4908 7.0423 9.4658 3.0211];
        PCoef = [1.4908 6.6696 7.8384 1];
end

%% memory saving version
switch approxOrder
    case 1
%         ply = PCoef(2) + PCoef(1)*x;
%         j0 = ply.*cos(x) + (0.35+ply).*sin(x);
%         % notice that pCoef(1)==PCoef(1), 0.35 = pCoef(2)-PCoef(2)
%         % 0.35+ply = pCoef(2) + pCoef(1)*x;
%         ply = (qCoef(2)+qCoef(1)*x);
%         j0 = j0./(  ply.* sqrt(1+x) ); % slightly faster
		
		
		j0 = ( (PCoef(2) + PCoef(1)*x).*cos(x) + (pCoef(2) + pCoef(1)*x).*sin(x) )  ./  (  (qCoef(2)+qCoef(1)*x).* sqrt(1+x) );
		% the fastest without creating the intermediate variable for
		% element-wise computation
        

% %         j0 = j0./ply;
% %         ply = sqrt(1+x);
% %         j0 = j0./ply;
% % %         j0 = j0./(sqrt(1+x));
    otherwise
        ply = polyval(PCoef,x);
        j0 = ply.*cos(x);
        ply = polyval(pCoef,x);
        j0 = j0 + ply.*sin(x);
        ply = polyval(qCoef,x) .* sqrt(1+x);
        j0 = j0./ply;        
end



%% normal version
% sqInv1px = 1./(sqrt(1+x));
% 
% switch approxOrder
%     case 1
%         qx = qCoef(2) + qCoef(1)*x;
%         px = pCoef(2) + pCoef(1)*x;
%         Px = PCoef(2) + PCoef(1)*x;
%     otherwise
%         qx = polyval(qCoef,x);
%         px = polyval(pCoef,x);
%         Px = polyval(PCoef,x);
% end
% 
% j0 = (Px./qx.*cos(x) + px./qx.*sin(x)).* sqInv1px;
% % j0 = (Px.*cos(x) + px.*sin(x))./ qx .* sqInv1px;
