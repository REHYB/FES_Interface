%%
function Close_Fig_Callback(hObject, eventdata, handles)

handles.f.HandleVisibility='off';
handles.f2.HandleVisibility='off';
handles.f3.HandleVisibility='off';
close all
handles.f.HandleVisibility='on';
handles.f2.HandleVisibility='on';
handles.f3.HandleVisibility='on';

end