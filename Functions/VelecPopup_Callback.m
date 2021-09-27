%%
function VelecPopup_Callback(hObject, eventdata, handles)
global G
if handles.VelecPopup.Value>1
    handles.VelecStimOn.Enable='on';
    G.SelectedVelecNo=handles.VelecPopup.Value;
    G.SelectedVelecName=cell2mat(handles.VelecPopup.String(handles.VelecPopup.Value));
elseif handles.VelecStimOn.Value==0
    handles.VelecStimOn.Enable='off';
end
end