%%
function ControlProportionalGain_Callback(hObject, eventdata, handles)
global G
gain=str2double(split(handles.VelecNew(4,8).String,','));
G.Control.Gain.Proportional=gain(1);
G.Control.Gain.Integral=gain(2);
G.Control.Gain.Derivative=gain(3);
end