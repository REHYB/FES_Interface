%% Sensor
function [D,ValidDataFlg]=DataAcquisitionGFBox(handles)
global G

if G.force_sensor_protocol==1
    GFBytNo = G.deviceForce.BytesAvailable;
    fopen(G.deviceForce);
elseif G.force_sensor_protocol==2
    
elseif G.force_sensor_protocol==3
    GFBytNo = G.deviceForce.NumBytesAvailable;
end

if(GFBytNo==0 && (G.t-G.t_connection)>20.0)
    G.ZeroByteCnt= G.ZeroByteCnt +1;
elseif GFBytNo>0
    G.t_connection=G.t;
    G.ZeroByteCnt=0;
    if (G.ForceSensorConnection==0)
        handles.Report(1,2).String=sprintf('Running...\n');
        handles.Indicator(1,1).BackgroundColor='g';
        G.ForceSensorConnection=1;
    end
end
if (G.ZeroByteCnt>0)
    handles.Report(1,2).String=sprintf('There is a problem in Communication with Devices!!!\n');
    pause(0.001);
    handles.Indicator(1,1).BackgroundColor=[0.7 0.7 0.7];
    G.ForceSensorConnection=0;
end

BadData=0;

if (GFBytNo>=29)
    if G.force_sensor_protocol==1
        d = uint8(fread(G.deviceForce,floor(GFBytNo/29)*29));
    elseif G.force_sensor_protocol==2
        
    elseif G.force_sensor_protocol==3
        d = read(G.deviceForce,floor(G.deviceForce.NumBytesAvailable/29)*29,"uint8");
    end
    
    
    d_n = length(d)/29;
    
    dm_temp = reshape(d,29,d_n)';
    
    for ii=1:d_n
        for jj=1:28
            if dm_temp(ii,jj)<48
                BadData=1;
                G.BadDataCnt=G.BadDataCnt+1;
            end
        end
    end
    if (G.BadDataCnt>100)
        G.BadDataCnt=0;
        if G.force_sensor_protocol==1
            flushinput(G.deviceForce);
        elseif G.force_sensor_protocol==2
            flush(G.deviceForce);
        elseif G.force_sensor_protocol==3
            flush(G.deviceForce);
        end
    end
    if BadData==0
        
        G.c = G.c(end)+1:G.c(end)+d_n;
        G.num = cnv(dm_temp(:,1:2)); %
        %                 if size(G.num,1)>=1
        %                                          fprintf('%d\n',size(G.num,1));
        %                 end
        %         BuffSize(i)=size(G.num,1);
        G.BuffSizeMean=(G.BuffSizeMean*(G.Cnt-1)+size(G.num,1))/G.Cnt;
        G.Cnt=G.Cnt+1;
        
        D(:,1) = cnv(dm_temp(:,3:6))/100; % grip1, N
        D(:,2) = cnv(dm_temp(:,7:10))/100; % grip2
        D(:,3) = cnv(dm_temp(:,11:14))/100; % load
        D(:,4) = cnv(dm_temp(:,15:18))/340; %accx g
        D(:,5) = cnv(dm_temp(:,19:22))/340; %accy
        D(:,6) = cnv(dm_temp(:,23:26))/340; %accz
        
        %         G.dm = [G.dm;dm_temp];
        
        for j=1:6
            G.data(G.c,j) = D(:,j);
        end
        
        G.load=mean(D(:,3));
        G.GripForce=mean(D(:,1) + D(:,2))/2.0;
        
        G.CorrectDataCnt=G.CorrectDataCnt+1;
    else
        G.BadDataCnt=G.BadDataCnt+1;
    end
end
% if  exist('D')==0
%     D=0;
% end
if GFBytNo>=29 && BadData==0
    ValidDataFlg=1;
else
    ValidDataFlg=0;
    D=0;
end
end