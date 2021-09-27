function D = qtm_unpack(pkg,markerName)
n = length(pkg); % total packet size
D.Size = 0;
i = 1;
c = 1;
while sum(D.Size)<n
    d_size = bin2dec(qtm_dec2bin(pkg(c:c+3)));
    data = pkg(c:d_size+c-1);
    
    D.Size(i,1) = bin2dec(qtm_dec2bin(data(1:4)));
    D.Type(i,1) = bin2dec(qtm_dec2bin(data(5:8)));
    D.Timestamp(i,1) = bin2dec(qtm_dec2bin(data(9:16)));
    D.FrameNumber(i,1) = bin2dec(qtm_dec2bin(data(17:20)));
    D.ComponentCount(i,1) = bin2dec(qtm_dec2bin(data(21:24)));
    
    cmp = data(25:D.Size(i,1));
    
    D.ComponentSize(i,1) = bin2dec(qtm_dec2bin(cmp(1:4)));
    D.ComponentType(i,1) = bin2dec(qtm_dec2bin(cmp(5:8)));
    D.MarkerCount(i,1) = bin2dec(qtm_dec2bin(cmp(9:12)));
    D.drop2D(i,1) = bin2dec(qtm_dec2bin(cmp(13:14)));
    D.sync2D(i,1) = bin2dec(qtm_dec2bin(cmp(15:16)));
    
    
    if D.ComponentType(i,1)==1 % 3D
        for j = 1:D.MarkerCount(i,1)
            c_mk = 17+24*(j-1);
            D.(markerName{j}).X(i,1) = ieee754(cmp(c_mk:c_mk+7));
            D.(markerName{j}).Y(i,1) = ieee754(cmp(c_mk+8:c_mk+15));
            D.(markerName{j}).Z(i,1) = ieee754(cmp(c_mk+16:c_mk+23));
        end
    elseif D.ComponentType(i,1) == 2 % 3DNolabel
        for j = 1:D.MarkerCount(i,1)
            c_mk = 17+32*(j-1);
            D.Marker.X(i,j) = ieee754(cmp(c_mk:c_mk+7));
            D.Marker.Y(i,j) = ieee754(cmp(c_mk+8:c_mk+15));
            D.Marker.Z(i,j) = ieee754(cmp(c_mk+16:c_mk+23));
            D.MarerID(i,j) = bin2dec(qtm_dec2bin(cmp(c_mk+24:c_mk+27)));
        end
    end

    i = i+1;
    c = c+d_size;
end
