%%
function InitializeFES_Callback(hObject, eventdata, handles)

global G;

handles.f2.Position = handles.f.Position - [0    1.09*handles.f.Position(4)    0    0];

if G.HKRDesktop
    handles.f2.Position = [0    0.0463    1.0000    0.9269];
end

handles.f2.Visible='on';



Read_All_Saved_Velec(hObject, eventdata, handles);

writeline(G.deviceFES,"iam DESKTOP")
ReceiveFESData(handles);

writeline(G.deviceFES,"battery ? ")
ReceiveFESData(handles);

writeline(G.deviceFES,"elec 1 *pads_qty 16");
ReceiveFESData(handles);

writeline(G.deviceFES,strcat("freq ",num2str(35)));
ReceiveFESData(handles);

%
ElecName=[];
%  if G.Load.DefNo>0;
%     ElecName=[sprintf("%s",G.Load.Elec(G.Load.DefNo).Name)]
%  end
% ElecName=["CloseL06101";"CloseL06102";"CloseL06103";"CloseL06104";"CloseL06105"];
% ElecId=[11;12;13;14;15];
% ElecCathode={[4,6,8];[4,6,8];[4,6,8];[4,6,8];[4,6,8]};
% ElecAmp={[2 2 2];[3 3 3];[4 4 4];[5 5 5];[6 6 6]};
% ElecWid={[300 300 300];[300 300 300];[300 300 300];[300 300 300];[300 300 300]};
% ElecAnode={[2];[2];[2];[2];[2]};

G.VelecPopup.Name(1)={'Select ...'};
for i=1:length(ElecName)
    G.VelecPopup.Name(i+1)={str2mat(strcat(ElecName(i),' (ID: ',num2str(ElecId(i)),')'))};
    G.Elec(i).Name  = ElecName(i);
    G.Elec(i).ID    = ElecId(i);
    G.Elec(i).Selectedcathode = ElecCathode{i};
    G.Elec(i).Selectedanode   =ElecAnode{i};
    G.Elec(i).Amp   = ElecAmp{i};
    G.Elec(i).Width = ElecWid{i};
    
    [G.Elec(i).Cmd,success] = gen_FES_command(G.Elec(i).Selectedanode, G.Elec(i).Selectedcathode,G.Elec(i).Amp,G.Elec(i).Width,G.Elec(i).Name,G.Elec(i).ID); %[electrode], [mA], [pulse width]
    
    
    %     HKR
    %     if success==1
    %         writeline(G.deviceFES,G.Elec(i).Cmd);
    %         ReceiveFESData(handles);
    %     end
    
end

%%
handles.Report(2,2).String=sprintf('FES Device is initialized (%d virtual electrod(s) defined), you can now Define New Velec or turn on available ones.\n',length(ElecName));
drawnow;

handles.VelecStimOn.Visible='on';

handles.VelecPopup.Visible='on';
handles.VelecPopup.Enable='on';
handles.VelecPopup.String=G.VelecPopup.Name;

handles.VelecDef.Enable='on';
handles.VelecDef.Visible='on';

end