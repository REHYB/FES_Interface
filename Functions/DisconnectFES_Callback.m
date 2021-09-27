%%
function DisconnectFES_Callback(hObject, eventdata, handles)
global G;
handles.f.HandleVisibility='off';
handles.mitem(2,6).Enable='off';
handles.VelecStimOn.Visible='off';
handles.VelecPopup.Visible='off';
handles.VelecDef.Visible='off';
clc
% configureCallback(G.deviceFES, "off");
if exist('G')==1
    if (isfield(G,'deviceFES')==1)
        delete(G.deviceFES)
    end
end
handles.f.HandleVisibility='on';
% handles.mitem(3,1).Enable='off';

handles.Report(2,2).String=sprintf('FES Device is disconnected successfully, you should connect again if you want to use the FES.\n');
drawnow;
handles.Indicator(2,1).BackgroundColor='r';
end