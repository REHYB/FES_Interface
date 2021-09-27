

%%
function FeedbackSlider_Callback(hObject, eventdata, handles)
global G
for i=1:length(G.Fingers)
    handles.Feedback(i,2).String=G.sensing(floor(handles.Feedback(i,3).Value)+1);
    handles.Feedback(i,2).ForegroundColor=G.sensingColor(floor(handles.Feedback(i,3).Value)+1);
end

end