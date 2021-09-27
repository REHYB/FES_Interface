function data = ieee754(pkg)

bin = qtm_dec2bin(pkg);

v = bin(:)'-'0';
n = length(v);
if n ==32
    offset_pow = 127;
    n_pow = 8;
elseif n==64
    offset_pow = 1023;
    n_pow = 11;
else
    data = [];
    return
end

fcr_idx = n_pow+2:length(v);
frc = 1+sum(v(fcr_idx).*2.^(-1:-1:-length(fcr_idx)));
pow = sum(v(2:n_pow+1).*2.^(n_pow-1:-1:0))-offset_pow;

sgn = (-1)^v(1);
data = sgn * frc * 2^pow;
end