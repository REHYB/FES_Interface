%%
function Auto_Velec_Callback(hObject, eventdata, handles)
global G

if handles.VelecNew(7,1).Value
    G.Auto.Flg=1;
    G.Auto.k=1;
    %     G.Auto.cathod=str2num(handles.VelecNew(7,2).String);
    a=split(handles.VelecNew(7,2).String,';');
    for i=1:size(a,1)
        b{i}=str2num(a{i});
    end
    G.Auto.cathod=[];
    G.Auto.cathod=b';
else
    G.Auto.Flg=0;
    if ~isequal(G.CurrentlyActive,[0])
        FESAutoAll(G.CurrentlyActive,'togglebutton',1,1,handles,1);
    end
    G.CurrentlyDeactive=G.CurrentlyActive;
    G.tpreviouselec=G.t;
end


end