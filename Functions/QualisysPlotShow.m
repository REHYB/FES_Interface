%%
function QualisysPlotShow(hObject, eventdata, handles)
global G
if handles.Q.button.Value
    handles.Q.button.String='Hide';
    G.Q.p1.Visible='on';
    G.Q.p1.Parent.Visible='on';
    %     G.Q.Cnt=1;
    %     G.Q.SaveCnt=G.Q.SaveCnt+1;
    drawnow;
else
    handles.Q.button.String='Show';
    G.Q.p1.Visible='off';
    G.Q.p1.Parent.Visible='off';
end
end