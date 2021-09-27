%%
function COMPortCheck_Callback(hObject, eventdata, handles)
global G
handles.Reportgen.String='wait...';
drawnow;
G.availablePort=serialportlist("available");
b='Available COMPort';
date=datetime('now');
b=sprintf("%s (Last update:%s):  ",b,datestr(date,30));
for i=1:length(G.availablePort)-1
    b=strcat(b,G.availablePort(i),', ');
end
b=strcat(b,G.availablePort(i+1));
handles.Reportgen.String=b;


end