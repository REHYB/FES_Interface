%%
% Stim On
function FESControlCommand_Callback(hObject, eventdata, handles)
global G
clc
if handles.VelecStimOn.Value==0
    G.stopcontrol=0;
    G.ControlStartwithdelay=0;
    G.tControlStartwithdelay=0;
    handles.VelecStimOn.String='on';
    
    writeline(G.deviceFES,"stim off");
    G.FESStimOn.Flg=0;
    G.control.FirstTime=0;
    ReceiveFESData(handles);
    
    if handles.VelecPopup.Value==1
        handles.VelecStimOn.Enable='off';
    end
else
    handles.VelecStimOn.String='off';
    
    if G.SelectedVelecNo>1
        handles.Report(2,2).String=sprintf('Stim on (%s) ...\n',G.SelectedVelecName);
        drawnow;
        writeline(G.deviceFES,strcat("stim ",G.Elec(G.SelectedVelecNo-1).Name));%start continous stimulation
        G.FESStimOn.Flg  =1;
        G.control.FirstTime=1;
        G.FESStimOn.Name =G.Elec(G.SelectedVelecNo-1).Name;
        G.FESStimOn.ID   =G.Elec(G.SelectedVelecNo-1).ID;
        
        ReceiveFESData(handles);
        
        %         writeline(G.deviceFES,"velec 13 *amp 1=0,2=0,3=0,4=7,5=0,6=7,7=0,8=7,9=0,10=0,11=0,12=0,13=0,14=0,15=0,16=0");
        %         ReceiveFESData(handles);
        %         aaaa=1;
    end
end


end