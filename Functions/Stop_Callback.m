%%
function Stop_Callback(hObject, eventdata, handles)
global G;
% pause(1000);
if  G.stop==0
    handles.mitem(3,3).Text='Resume';
    G.stop=1;
    handles.Report(1,2).String=sprintf('Task stopped:\nSelect "Resume" to resume the task.\nSelect "Reset and Start again" to start the task again.\n');
    drawnow;
else
    handles.mitem(3,3).Text='Stop';
    G.stop=0;
    handles.Report(1,2).String=sprintf('Task resumed:\nSelect "Stop" to stop the task.\nSelect "Reset and Start again" to start the task again.\n');
    drawnow;
    %     flushinput(G.deviceForce);
end
end