
%%
function ControlExportSelectedElec_Callback(hObject, eventdata, handles)
global G;
k=0;

if handles.VelecNew(4,6).Value==1
    G.Control.Active=1;
else
    G.Control.Active=0;
end

G.Control.Cathodes.Flg=zeros(1,16);
for i=1:16
    if handles.VelecNewVal(i,9).Value==1 && handles.VelecNewVal(i,2).Value==2
        k=k+1;
        G.Control.Cathodes.Flg(G.Elecorder(i))=1;
    end
end
G.Control.Cathodes.No  = k ;
G.Control.VElec.Name   = handles.VelecNew(1,2).String ;
G.Control.VElec.ID     = handles.VelecNew(2,2).String;

end