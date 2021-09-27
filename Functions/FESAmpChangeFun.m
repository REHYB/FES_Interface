%%
function FESAmpChangeFun(handles)
global G
if handles.VelecNew(4,2).Value== 1 && G.FESStimOn.Flg==1
    if strcmp(G.FESStimOn.Name , handles.VelecNew(1,2).String) && strcmp(G.FESStimOn.ID , handles.VelecNew(2,2).String)
        
        
        n=G.SelectedVelecNo-1;
        
        for k=1:length(G.Elec(n).Selectedcathode)
            n0=find(G.Elecorder==G.Elec(n).Selectedcathode(k));
            %         amp(k)=handles.VelecNewVal(n0,4).String;
            
            
            %         cmd=sprintf("velec %s *amp %s=%s",G.FESStimOn.ID, eventdata.Source.Parent.Title, amp);
            %         writeline(G.deviceFES,cmd);
            %         ReceiveFESData(handles);
            %         ActiveNo=G.Elecorder(j);
            G.Elec(n).AmpUpdate(G.Elec(n).Selectedcathode(k))=str2num(handles.VelecNewVal(n0,4).String);
        end
        
        
        %         cmd=sprintf("velec %s *amp 1=%d,2=%d,3=%d,4=%d,5=%d,6=%d,7=%d,8=%d,9=%d,10=%d,11=%d,12=%d,13=%d,14=%d,15=%d,16=%d",G.FESStimOn.ID, G.Elec(n).AmpUpdate);
        %         writeline(G.deviceFES,cmd);
        %         ReceiveFESData(handles);
        %         for j=1:16
        G.ActPanel.Amp=G.Elec(n).AmpUpdate;
        %         end
        
        FESCommand(G.FESStimOn.ID,'amp',G.Elec(n).AmpUpdate);
        
        handles.VelecNew(4,4).String='Amp changed';
        handles.VelecNew(4,4).ForegroundColor='g';
        
    end
end
end