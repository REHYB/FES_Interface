%%
function FES_limit_Callback(hObject, eventdata, handles)
global G
temp=str2double(split(handles.VelecNew(4,10).String,','));
G.Timeamp=temp(1);
G.Timeoutamp=temp(2);
if temp(3)<=G.MaxAmpSafety
    G.MaxAmp=temp(3);
else
    G.MaxAmp=G.MaxAmpSafety;
    handles.VelecNew(4,10).String=sprintf("%.1f, %.1f, %.1f, %.1f", G.Timeamp,G.Timeoutamp, G.MaxAmp, G.Auto.timedelay);
end
G.Auto.timedelay=temp(4);
for i=1:16
    handles.VelecNewVal(i,5).Min=G.MinAmp;
    handles.VelecNewVal(i,5).Max=G.MaxAmp;
    if handles.VelecNewVal(i,5).Value>G.MaxAmp
        handles.VelecNewVal(i,5).Value=G.MaxAmp;
    end
    if str2double(handles.VelecNewVal(i,4).String)>G.MaxAmp
        handles.VelecNewVal(i,4).String=num2str(G.MaxAmp);
    end
end

end