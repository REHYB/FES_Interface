%%
function GeneralInit_Callback(hObject, eventdata, handles)
global G

G.AutoRun.GeneralInit.flg=1;
G.AutoRun.selectedVelecstr='Default1';
delay=1;

% ConnectForceSensor_Callback(hObject, eventdata, handles);
% pause(delay);
ConnectFES_Callback(hObject, eventdata, handles);
pause(delay);
% QualisysInit_Callback(hObject, eventdata, handles);
% drawnow;
% pause(delay);
InitializeFES_Callback(hObject, eventdata, handles);

handles.VelecNew(5,2).Value=G.AutoRun.select;
Load_Saved_Velec_Callback(hObject, eventdata, handles);


SaveNewVelec_Callback(hObject, eventdata, handles);
pause(delay);

handles.VelecPopup.Value=2;
VelecPopup_Callback(hObject, eventdata, handles)


handles.VelecStimOn.Value=1;
FESControlCommand_Callback(hObject, eventdata, handles)
pause(delay);

pause(delay);
Run_Callback(hObject, eventdata, handles)


end
