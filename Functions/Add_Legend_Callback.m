%%
function Add_Legend_Callback(hObject, eventdata, handles)

handles.L1 = uicontrol(handles.f,'Style','edit');
handles.L1.String='leg1,leg2,off,leg4,...';
handles.L1.Position = [0.01 0.05 0.2 0.05];
handles.L1.Callback=@Add_Legend_text;

    function Add_Legend_text(src,event)
        
        add_legend_fun(split(handles.L1.String,','));
        handles.L1.Visible='off';
    end
handles.Reportgen.String=sprintf('Legends added successfully.\n');
drawnow;
end