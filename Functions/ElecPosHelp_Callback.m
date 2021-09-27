%%
function ElecPosHelp_Callback(hObject, eventdata, handles)
global G
if handles.VelecNew(4,5).Value== 1
    if (isgraphics(handles.f3))==0
        handles.f3=figure(103);
        imshow(G.background);
        handles.f3.Units='normalized';
        handles.f3.MenuBar='none';handles.f3.NumberTitle='off';handles.f3.Name='ElectrodesPosition';
    end
    handles.f3.Position=handles.f2.Position -[handles.f2.Position(3) 0 0 0];
    handles.f3.Visible='on';
elseif handles.VelecNew(4,5).Value==0
    handles.f3=figure(103);
    handles.f3.Visible='off';
    
end

end