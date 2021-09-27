%%
function OnlineNewVelecCheckbox_Callback(hObject, eventdata, handles)

if handles.VelecNew(4,2).Value== 1
    handles.VelecNew(4,3).Visible='on';
elseif handles.VelecNew(4,3).Value==0
    handles.VelecNew(4,3).Visible='off';
end

end