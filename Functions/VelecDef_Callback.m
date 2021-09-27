%%
function VelecDef_Callback(hObject, eventdata, handles)
global G

if strcmp(handles.f2.Visible,'off')
    handles.f2.Visible='on';
else
    handles.f2.Visible='off';
end

end