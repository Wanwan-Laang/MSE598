function F = basis_fcn_trig(coord, period, order)
% coord - N*2, period 2*2, rows - fundamental period vec
% tensor product of [1 cos sin cos2 sin2 ...]

n = 2*order+1;
N = size(coord,1);
% omg = 2*pi./period;
% X = coord * diag(omg);
X = 2*pi*coord * inv(period);

Fx = zeros(N,n);
Fy = zeros(N,n);
Fx(:,1) = 1;
Fy(:,1) = 1;
for ii=1:order
    Fx(:,2*ii) = cos(X(:,1)*ii);
    Fx(:,2*ii+1) = sin(X(:,1)*ii);
    
    Fy(:,2*ii) = cos(X(:,2)*ii);
    Fy(:,2*ii+1) = sin(X(:,2)*ii);
end

Fx = repmat( reshape(Fx,N,n,1), 1,1,n);
Fy = repmat( reshape(Fy,N,1,n), 1,n,1);

F = Fx.*Fy;
F = reshape(F,N,n^2);