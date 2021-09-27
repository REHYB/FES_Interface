%%
function DisconnectForceSensor_Callback(hObject, eventdata, handles)
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
% handles.mitem(3,1).Enable='off';

handles.Report(1,2).String=sprintf('Device is disconnected successfully, you should connect again for starting the task.\n');
drawnow;
handles.Indicator(1,1).BackgroundColor='r';
end