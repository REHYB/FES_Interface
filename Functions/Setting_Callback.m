
%%
% Setting_Callback
function Setting_Callback(hObject, eventdata, handles)
global G;
if handles.VelecNew(4,11).Value==1
    handles.VelecNew(4,11).String=sprintf("<<");
    handles.p1.Visible='on';
else
    handles.VelecNew(4,11).String=sprintf(">>");
    handles.p1.Visible='off';
end

handles.c100 = uicontrol(handles.p1,'Style','popupmenu');
handles.c100.String=G.Setting_Name;
handles.c100.FontUnits='normalized';
handles.c100.Position = [0.01    0.05    0.3    0.85];
handles.c100.FontSize=0.5;
handles.c100.Callback=@Setting_Popup1;

handles.c104 = uicontrol(handles.p1,'Style','pushbutton');
handles.c104.String='X';
handles.c104.FontUnits='normalized';
% handles.c100.Position = [0.01    0.05    0.3    0.85];
handles.c104.FontSize=0.5;
handles.c104.Position = [0.98    0.75    0.015   0.25];
handles.c104.ForegroundColor='r';
handles.c104.Callback=@Exit_Setting;

    function Setting_Popup1(src,event)
        
        handles.c102.Visible='off';
        %         handles.c102.Enable='off';
        handles.c103.Visible='off';
        handles.c101.Visible='off';
        
        if handles.c100.Value>1
            handles.c101 = uicontrol(handles.p1,'Style','popupmenu');
            handles.c101.String=G.Setting(handles.c100.Value).Popname;
            handles.c101.FontUnits='normalized';
            handles.c101.FontSize=0.5;
            handles.c101.Position = [0.32    0.05    0.3    0.85];
            handles.c101.Callback=@Setting_Popup2;
            handles.c101.String=G.Setting(handles.c100.Value).Popname;
        end
        
    end

    function Setting_Popup2(src,event)
        
        if handles.c101.Value==1
            handles.c102.Visible='off';
            handles.c103.Visible='off';
        else
            handles.c102 = uicontrol(handles.p1,'Style',cell2mat(G.Setting(handles.c100.Value).Type(handles.c101.Value)));
            
            if strcmp(handles.c102.Style,'edit')~=1
                handles.c102.String=G.Setting(handles.c100.Value).TypeName{handles.c101.Value};
                handles.c102.Value=G.Setting(handles.c100.Value).Value(handles.c101.Value);
            else
                handles.c102.String=G.Setting(handles.c100.Value).Value(handles.c101.Value);
            end
            
            handles.c102.FontUnits='normalized';
            handles.c102.FontSize=0.5;
            handles.c102.Position = [0.63    0.05    0.2    0.85];
            
            handles.c103 = uicontrol(handles.p1,'Style','pushbutton');
            handles.c103.String='Save';
            handles.c103.FontUnits='normalized';
            handles.c103.FontSize=0.5;
            handles.c103.Position = [0.84    0.05    0.10    0.85];
            handles.c103.Callback=@Save_Data;
        end
    end

    function Save_Data(src,event)
        if strcmp(handles.c102.Style,'edit')==1
            G.Setting(handles.c100.Value).Value(handles.c101.Value)=str2num(handles.c102.String);
        else
            G.Setting(handles.c100.Value).Value(handles.c101.Value)=handles.c102.Value;
        end
        Initialized_Parameters_and_Setting();
    end

    function Exit_Setting(src,event)
        handles.p1.Visible='off';
        handles.VelecNew(4,11).String=sprintf(">>");
        handles.VelecNew(4,11).Value=0;
    end

end