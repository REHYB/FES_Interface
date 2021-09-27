%%
function ConnectFES_Callback(hObject, eventdata, handles)
global G;
clc
handles.Report(2,2).String=sprintf('Please wait for FES conncetion ...\n');
drawnow;
if exist('G')==1
    if (isfield(G,'deviceFES')==1)
        delete(G.deviceFES)
    end
end

if G.FES_protocol==3
    if G.deviceFES_findmode==1
        [status,cmdout] =system('listComPorts.exe');
        cmdouts=split(cmdout,'COM');
        for i=1:length(cmdouts)
            %         porttemp=cell2mat(extractBetween(cmdouts(i),'COM','0016A474BDB5'));
            if contains(cmdouts(i),G.deviceFES_ID)==1
                temp2=cell2mat(cmdouts(i));
                G.deviceFES_com=sprintf('COM%d',str2num(temp2(1:2)));
            end
            
        end
    elseif G.deviceFES_findmode==2
        G.deviceFES_com=findport(G.deviceFES_ID, G.deviceFES_Name, G.deviceFES_findmode);
    else
        G.deviceFES_com=G.deviceFES_com;
    end
end
temp=1;

StopTry = uicontrol(handles.f,'Style', 'ToggleButton', ...
    'String', 'Stop Trying ...');
StopTry.Position=[0.341    0.24    0.2    0.05];

while temp>0
    try
        G.deviceFES = serialport(G.deviceFES_com,115200);
        handles.Indicator(2,1).BackgroundColor='g';
        configureTerminator(G.deviceFES,"CR/LF");
        handles.mitem(2,6).Enable='on';
        handles.Report(2,2).String=sprintf('FES Device is connected successfully, you can now select FES Initialization through Setting Tab.\n');
        temp=0;
        delete(StopTry);
    catch
        handles.Report(2,2).String=sprintf('Try No. %d:Problem in Opening FES Port (%s), trying again...\n',temp,G.deviceFES_com);
        drawnow;
        temp=temp+1;
        if get(StopTry,'Value')
            temp=0;
            handles.Report(2,2).String=sprintf('Please Select Connect (FES Device) through Setting Tab.\n');
            delete(StopTry);
        end
    end
    
end

end