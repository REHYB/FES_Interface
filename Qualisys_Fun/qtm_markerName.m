function s = qtm_markerName(d)

s1 = strfind(d,'<Name>')';
s2 = strfind(d,'</Name>')';

for i = 1:length(s1)
   s{i} = d(s1(i)+6:s2(i)-1);
end