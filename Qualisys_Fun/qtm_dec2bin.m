function bin = qtm_dec2bin(pkg)
a = dec2bin(pkg,8);

if size(pkg,2)==2 %32bit
    bin = [a(1,:),a(2,:)];
elseif size(pkg,2)==4 %32bit
    bin = [a(1,:),a(2,:),a(3,:),a(4,:)];
elseif size(pkg,2)==8 % 64bit
    bin = [a(1,:),a(2,:),a(3,:),a(4,:),a(5,:),a(6,:),a(7,:),a(8,:)];
else
    bin = [];
end