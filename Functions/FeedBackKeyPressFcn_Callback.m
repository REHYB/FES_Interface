%%
function FeedBackKeyPressFcn_Callback(hObject, eventdata, handles)
finger={"Little","Ring","Middle","Index","Thumb"};
% fingerkey={{'subtract','add','return'};...
%     {'multiply','numpad9','numpad6','numpad3','decimal','pageup','rightarrow','pagedown','delete'};...
%     {'divide','numpad8','numpad5','numpad2','uparrow','clear','downarrow'};...
%     {'numlock','numpad7','numpad4','numpad1','home','leftarrow','end'};...
%     {'uparrow','downarrow','rightarrow','leftarrow'}};
fingerkey={{'subtract','add','return'};...
    {'multiply','numpad9','numpad6','numpad3','decimal'};...
    {'divide','numpad8','numpad5','numpad2'};...
    {'numlock','numpad7','numpad4','numpad1'};...
    {'uparrow','downarrow','rightarrow','leftarrow'}};
for i=1:length(fingerkey)
    for j=1:length(fingerkey{i})
        if isequal(eventdata.Key,cell2mat(fingerkey{i}(j)))
            handles.Reportgen.String=sprintf("%s",finger{i});
        end
    end
end

% if isequal(eventdata.Key,'subtract') || isequal(eventdata.Key,'add') || isequal(eventdata.Key,'return') || isequal(eventdata.Key,'return')
%     handles.Reportgen.String=sprintf("L");
% elseif isequal(eventdata.Key,'multiply') || isequal(eventdata.Key,'pageup') || isequal(eventdata.Key,'numpad9') || isequal(eventdata.Key,'return')
%     handles.Reportgen.String=sprintf("R");
% elseif isequal(eventdata.Key,'u')
%     handles.Reportgen.String=sprintf("M");
% elseif isequal(eventdata.Key,'t')
%     handles.Reportgen.String=sprintf("I");
% elseif isequal(eventdata.Key,'space')
%     handles.Reportgen.String=sprintf("T");
% end
drawnow;
end