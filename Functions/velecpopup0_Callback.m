
%%
function velecpopup_Callback(hObject, eventdata, handles)
global G
for i=1:16
    if handles.VelecNewVal(i,2).Value== 2
        for j=3:15
            handles.VelecNewVal(i,j).Visible='on';
            if j==4
                handles.VelecNewVal(i,j).String = num2str(G.DefAmp);
                handles.VelecNewVal(i,j+1).Value = G.DefAmp;
                
                
            elseif j==7
                handles.VelecNewVal(i,j).String = num2str(G.DefWidth);
                handles.VelecNewVal(i,j+1).Value = G.DefWidth;
            end
        end
        handles.VelecNewVal(i,16).Visible='off';
        handles.VelecNewVal(i,17).Visible='off';
    else
        for j=3:15
            handles.VelecNewVal(i,j).Visible='off';
        end
        if handles.VelecNewVal(i,2).Value== 3
            handles.VelecNewVal(i,16).Visible='on';
            handles.VelecNewVal(i,17).Visible='off';
        elseif handles.VelecNewVal(i,2).Value== 1
            handles.VelecNewVal(i,16).Visible='off';
            handles.VelecNewVal(i,17).Visible='on';
        end
    end
end

end