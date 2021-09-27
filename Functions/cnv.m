%% Auxiliary Function
%%
function out = cnv(d)
h = char(d); % ascii
x = hex2dec(h); %hex
n = 16; % bit
out = x - (x >= 2.^(n-1)).*2.^n;
end