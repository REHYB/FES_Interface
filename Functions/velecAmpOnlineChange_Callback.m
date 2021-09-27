
%%
function velecAmpOnlineChange_Callback(hObject, eventdata, handles)
global G

ActiveNo=str2num(eventdata.Source.Parent.Title);
type=hObject.Style;

FESAuto(ActiveNo,type,0,0,handles,0);

end