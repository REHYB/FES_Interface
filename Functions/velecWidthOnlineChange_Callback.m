
%%
function velecWidthOnlineChange_Callback(hObject, eventdata, handles)
global G

ActiveNo=str2num(eventdata.Source.Parent.Title);

index=find( G.Elecorder==ActiveNo );


if (strcmp(hObject.Style,'edit')==1)
    
    if str2num(handles.VelecNewVal(index,7).String)>G.MaxWidth
        handles.VelecNewVal(index,7).String = num2str(G.MaxWidth);
        handles.VelecNew(4,4).String=sprintf("MaxWidth:%d",G.MaxWidth);
        handles.VelecNew(4,4).ForegroundColor='r';
    elseif str2num(handles.VelecNewVal(index,7).String)<G.MinWidth
        handles.VelecNewVal(index,7).String = num2str(G.MinWidth);
        handles.VelecNew(4,4).String=sprintf("MinWidth:%d",G.MinWidth);
        handles.VelecNew(4,4).ForegroundColor='r';
    else
        handles.VelecNew(4,4).String='';
    end
    
    handles.VelecNewVal(index,8).Value= (str2num(handles.VelecNewVal(index,7).String));
elseif (strcmp(hObject.Style,'slider')==1)
    handles.VelecNewVal(index,7).String=sprintf('%d',floor(eventdata.Source.Value));
end

if handles.VelecNew(4,2).Value== 1 && G.FESStimOn.Flg==1
    if strcmp(G.FESStimOn.Name , handles.VelecNew(1,2).String) && strcmp(G.FESStimOn.ID , handles.VelecNew(2,2).String)
        
        width=handles.VelecNewVal(index,7).String;
        
        n=G.SelectedVelecNo-1;
        G.Elec(n).WidthUpdate(ActiveNo)=str2num(width);
        %         G.Elec(n).WidthUpdate
        
        %         cmd=sprintf("velec %s *width 1=%d,2=%d,3=%d,4=%d,5=%d,6=%d,7=%d,8=%d,9=%d,10=%d,11=%d,12=%d,13=%d,14=%d,15=%d,16=%d",G.FESStimOn.ID, G.Elec(n).WidthUpdate);
        %         writeline(G.deviceFES,cmd);
        %         ReceiveFESData(handles);
        
        FESCommand(G.FESStimOn.ID,'width',G.Elec(n).WidthUpdate)
        
        handles.VelecNew(4,4).String='Width changed';
        handles.VelecNew(4,4).ForegroundColor='g';
        
        %         cmd=sprintf("velec %s *width %s=%s",G.FESStimOn.ID, eventdata.Source.Parent.Title, width);
        %         writeline(G.deviceFES,cmd);
        %         ReceiveFESData(handles);
        
    end
end
end