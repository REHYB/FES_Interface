
function FESAuto(ActiveNo,type,inp3,inp4,handles,mode)
global G

% ActiveNo=str2num(eventdata.AffectedObject.Parent.Title);

index=find( G.Elecorder==ActiveNo );

if mode==1
    if strcmp(type,'edit')==1
        handles.VelecNewVal(index,4).String=inp4;
    elseif (strcmp(type,'pushbutton')==1 || strcmp(type,'togglebutton')==1 )
        switch inp3
            case 1
                handles.VelecNewVal(index,10).Value=inp4;
            case 2
                handles.VelecNewVal(index,11).Value=inp4;
            case 3
                handles.VelecNewVal(index,12).Value=inp4;
            case 4
                handles.VelecNewVal(index,13).Value=inp4;
            case 5
                handles.VelecNewVal(index,14).Value=inp4;
            case 6
                handles.VelecNewVal(index,15).Value=inp4;
        end
    end
end

G.ActPanel.LoopIndicator(ActiveNo)=1;


if (strcmp(type,'edit')==1)
    
    if str2num(handles.VelecNewVal(index,4).String)>G.MaxAmp
        handles.VelecNewVal(index,4).String = num2str(G.MaxAmp);
        handles.VelecNew(4,4).String=sprintf("MaxAmp:%d",G.MaxAmp);
        handles.VelecNew(4,4).ForegroundColor='r';
    elseif str2num(handles.VelecNewVal(index,4).String)<G.MinAmp
        handles.VelecNewVal(index,4).String = num2str(G.MinAmp);
        handles.VelecNew(4,4).String=sprintf("MinAmp:%d",G.MinAmp);
        handles.VelecNew(4,4).ForegroundColor='r';
    else
        handles.VelecNew(4,4).String='';
    end
    
    handles.VelecNewVal(index,5).Value= str2num(handles.VelecNewVal(index,4).String);
elseif (strcmp(type,'slider')==1)
    handles.VelecNewVal(index,4).String=sprintf('%d',floor(handles.VelecNewVal(index,5).Value));
    %     handles.VelecNewVal(index,4).String=sprintf('%d',floor(eventdata.AffectedObject.Value*G.MaxAmp));
elseif  (strcmp(type,'pushbutton')==1 || strcmp(type,'togglebutton')==1 )
    if handles.VelecNewVal(index,10).Value==1
        G.Auto.MaxThreshold(G.Auto.k)=str2num(handles.VelecNewVal(index,4).String);
        handles.VelecNewVal(index,10).Value=0;
        handles.VelecNewVal(index,13).Value=0;
        handles.VelecNewVal(index,14).Value=0;
        handles.VelecNewVal(index,15).Value=0;
        resetflg=1;
        handles.VelecNewVal(index,4).String=num2str(G.DefAmp);
        handles.VelecNewVal(index,5).Value = G.DefAmp;
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
        
        handles.VelecNewVal(index,1).ShadowColor=[0.7 0.7 0.7];
        
    elseif handles.VelecNewVal(index,11).Value==1
        handles.VelecNewVal(index,11).Value=0;
        handles.VelecNewVal(index,4).String=num2str(floor(G.MaxAmp/2));
        handles.VelecNewVal(index,5).Value = floor(G.MaxAmp/2);
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
        handles.VelecNewVal(index,1).ShadowColor='r';
    elseif handles.VelecNewVal(index,12).Value==1
        handles.VelecNewVal(index,12).Value=0;
        handles.VelecNewVal(index,4).String=num2str(G.MaxAmp);
        handles.VelecNewVal(index,5).Value = G.MaxAmp;
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
        handles.VelecNewVal(index,1).ShadowColor='r';
    elseif handles.VelecNewVal(index,13).Value==1
        %         handles.VelecNewVal(index,13).Value=0;
        G.ActPanel.LoopIndicator(ActiveNo)=2;
        handles.VelecNewVal(index,1).ShadowColor='r';
    elseif handles.VelecNewVal(index,14).Value==1
        %         handles.VelecNewVal(index,14).Value=0;
        G.ActPanel.LoopIndicator(ActiveNo)=3;
        handles.VelecNewVal(index,1).ShadowColor='r';
    elseif handles.VelecNewVal(index,15).Value==1
        %         handles.VelecNewVal(index,15).Value=0;
        G.ActPanel.LoopIndicator(ActiveNo)=4;
        handles.VelecNewVal(index,1).ShadowColor='r';
        
    end
end



G.ActPanel.told(ActiveNo)=G.t;
G.ActPanel.first(ActiveNo)=1;
G.ActPanel.tstep=G.Timeamp/(G.MaxAmp-G.MinAmp);
G.ActPanel.amptemp(ActiveNo)=G.MinAmp;
G.ActPanel.amptempm(ActiveNo)=1;

G.ActPanel.index=index;
G.ActPanel.ActiveNo=ActiveNo;

G.index(G.ActPanel.ActiveNo)=G.ActPanel.index;

G.ActPanel.tstart(ActiveNo)=G.t;
end