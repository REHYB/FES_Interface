%% Connection
function ConnectForceSensor_Callback(hObject, eventdata, handles)
global G;
if exist('G')==1
    if (isfield(G,'deviceForce')==1)
        if G.force_sensor_protocol==1
            fclose(G.deviceForce);
        elseif G.force_sensor_protocol==2
            
        elseif G.force_sensor_protocol==3
            delete(G.deviceForce);
        end
    end
end
handles.Report(1,2).String=sprintf('Please wait for conncetion ...\n');
drawnow;
if G.force_sensor_protocol==1
    G.deviceForce = Bluetooth("GF-Box-3 (SN13)",1);
    % % % % % device = serialport("COM7",57600,"Timeout",5);
    % % % % % data = read(device,16,"uint32");
    fopen(G.deviceForce);
elseif G.force_sensor_protocol==2
    
elseif G.force_sensor_protocol==3
    if G.deviceForce_findmode==1
        [status,cmdout] =system('listComPorts.exe');
        cmdouts=split(cmdout,'COM');
        for i=1:length(cmdouts)
            %         porttemp=cell2mat(extractBetween(cmdouts(i),'COM','0012F306B122'));
            if contains(cmdouts(i),G.deviceForce_ID)==1
                temp1=cell2mat(cmdouts(i));
                G.deviceForce_com=sprintf('COM%d',str2num(temp1(1:2)));
            end
        end
    elseif G.deviceForce_findmode==2
        G.deviceForce_com=findport(G.deviceForce_ID, G.deviceForce_Name,G.deviceForce_findmode);
    else
        G.deviceForce_com=G.deviceForce_com;
    end
    
end

if G.force_sensor_protocol==3
    temp=1;
    
    StopTry = uicontrol(handles.f,'Style', 'ToggleButton', ...
        'String', 'Stop Trying ...');
    StopTry.Position=[0.01    0.24    0.2    0.05];
    while temp>0
        try
            G.deviceForce = serialport(G.deviceForce_com,115200);
            handles.Indicator(1,1).BackgroundColor='g';
            handles.mitem(3,1).Enable='on';
            handles.Report(1,2).String=sprintf('Device is connected successfully, you can now start the task.\n');
            temp=0;
            delete(StopTry);
        catch
            handles.Report(1,2).String=sprintf('Try No. %d:Problem in Opening Force Sensor Port (%s), trying again...\n',temp,G.deviceForce_com);
            
            temp=temp+1;
            drawnow;
            if get(StopTry,'Value')
                temp=0;
                handles.Report(1,2).String=sprintf('Please Select Connect (Force Sensor) through Setting Tab.\n');
                delete(StopTry);
            end
        end
        
        
    end
end
end