%%
function Load_Saved_Velec_Callback(hObject, eventdata, handles)
global G
n=handles.VelecNew(5,2).Value-1;
if n==0
    handles.VelecNew(1,2).String = '';
    handles.VelecNew(2,2).String = '';
    handles.VelecNew(3,2).String = '';
    handles.VelecNew(6,2).String = '';
    for i=1:16
        ii=G.Elecorder(i);
        for j=3:15
            handles.VelecNewVal(i,j).Visible='off';
        end
        
        handles.VelecNewVal(i,2).Value=1;
        handles.VelecNewVal(i,16).Visible='off';
        handles.VelecNewVal(i,17).Visible='on';
    end
    
else
    handles.VelecNew(1,2).String = G.Load.Elec(n).Name;
    handles.VelecNew(2,2).String = G.Load.Elec(n).ID;
    handles.VelecNew(3,2).String = G.Load.Elec(n).Freq;
    handles.VelecNew(6,2).String = G.Load.Elec(n).Note;
    handles.VelecNew(4,10).String= sprintf("%.1f,%.1f,%.1f,%.1f",str2num(G.Load.Elec(n).StimFeasure(1:end-2)));
    for i=1:16
        ii=G.Elecorder(i);
        handles.VelecNewVal(i,4).String=G.Load.Elec(n).Amp(ii,1);
        if G.Load.Elec(n).SelectedcathodeBinary(ii,1)==1
            handles.VelecNewVal(i,2).Value=2;
            for j=3:15
                handles.VelecNewVal(i,j).Visible='on';
                if j==4
                    handles.VelecNewVal(i,j).String = num2str( G.Load.Elec(n).Amp(ii,1));
                    handles.VelecNewVal(i,j+1).Value = G.Load.Elec(n).Amp(ii,1);
                elseif j==7
                    handles.VelecNewVal(i,j).String = num2str( G.Load.Elec(n).Width(ii,1));
                    handles.VelecNewVal(i,j+1).Value = G.Load.Elec(n).Width(ii,1);
                end
            end
            handles.VelecNewVal(i,16).Visible='off';
            handles.VelecNewVal(i,17).Visible='off';
            
        else
            for j=3:15
                handles.VelecNewVal(i,j).Visible='off';
            end
            if G.Load.Elec(n).SelectedanodeBinary(ii,1)==1
                handles.VelecNewVal(i,2).Value=3;
                handles.VelecNewVal(i,16).Visible='on';
                handles.VelecNewVal(i,17).Visible='off';
            else
                handles.VelecNewVal(i,2).Value=1;
                handles.VelecNewVal(i,16).Visible='off';
                handles.VelecNewVal(i,17).Visible='on';
            end
        end
    end
    
end
end