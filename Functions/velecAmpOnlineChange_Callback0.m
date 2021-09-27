%%
function velecAmpOnlineChange_Callback0(hObject, eventdata, handles)
global G

G.ActPanel.LoopIndicator=1;
ActiveNo=str2num(eventdata.Source.Parent.Title);
% ActiveNo=str2num(eventdata.AffectedObject.Parent.Title);
index=find( G.Elecorder==ActiveNo );
if (strcmp(hObject.Style,'edit')==1)
    
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
elseif (strcmp(hObject.Style,'slider')==1)
    handles.VelecNewVal(index,4).String=sprintf('%d',floor(eventdata.Source.Value));
    %     handles.VelecNewVal(index,4).String=sprintf('%d',floor(eventdata.AffectedObject.Value*G.MaxAmp));
elseif  (strcmp(hObject.Style,'pushbutton')==1 || strcmp(hObject.Style,'togglebutton')==1 )
    if handles.VelecNewVal(index,10).Value==1
        handles.VelecNewVal(index,10).Value=0;
        handles.VelecNewVal(index,13).Value=0;
        handles.VelecNewVal(index,14).Value=0;
        handles.VelecNewVal(index,15).Value=0;
        resetflg=1;
        handles.VelecNewVal(index,4).String=num2str(G.DefAmp);
        handles.VelecNewVal(index,5).Value = G.DefAmp;
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
    elseif handles.VelecNewVal(index,11).Value==1
        handles.VelecNewVal(index,11).Value=0;
        handles.VelecNewVal(index,4).String=num2str(floor(G.MaxAmp/2));
        handles.VelecNewVal(index,5).Value = floor(G.MaxAmp/2);
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
    elseif handles.VelecNewVal(index,12).Value==1
        handles.VelecNewVal(index,12).Value=0;
        handles.VelecNewVal(index,4).String=num2str(G.MaxAmp);
        handles.VelecNewVal(index,5).Value = G.MaxAmp;
        handles.VelecNewVal(index,7).String=num2str(G.DefWidth);
        handles.VelecNewVal(index,8).Value = G.DefWidth;
    elseif handles.VelecNewVal(index,13).Value==1
        %         handles.VelecNewVal(index,13).Value=0;
        G.ActPanel.LoopIndicator=2;
    elseif handles.VelecNewVal(index,14).Value==1
        %         handles.VelecNewVal(index,14).Value=0;
        G.ActPanel.LoopIndicator=3;
    elseif handles.VelecNewVal(index,15).Value==1
        %         handles.VelecNewVal(index,15).Value=0;
        G.ActPanel.LoopIndicator=4;
        
    end
end

amptemp=G.MinAmp;
amptempm=1;
tic
told=toc;
first=1;
tstep=G.Timeamp/(G.MaxAmp-G.MinAmp);
while ( G.ActPanel.LoopIndicator>0)
    G.tAmp=toc;
    drawnow;
    
    if  G.ActPanel.LoopIndicator==1 || ( ( G.ActPanel.LoopIndicator==2 ||  G.ActPanel.LoopIndicator==3) && ((G.tAmp-told)>tstep || first) ) || ( G.ActPanel.LoopIndicator==4 && ((G.tAmp-told)>first/10||first) )
        told=G.tAmp;
        first=0;
        
        if G.tAmp > G.Timeoutamp
            G.ActPanel.LoopIndicator=0;
            handles.VelecNewVal(index,4).String=num2str(G.DefAmp);
            handles.VelecNewVal(index,5).Value = G.DefAmp;
        end
        
        if  G.ActPanel.LoopIndicator==1
            G.ActPanel.LoopIndicator=0;
        elseif  G.ActPanel.LoopIndicator==2
            if amptemp<=G.MaxAmp
                %             pause(0.5);
                if get(handles.VelecNewVal(index,13),'Value')==0
                    %             handles.VelecNewVal(index,4).String=num2str(G.DefAmp);
                    %             handles.VelecNewVal(index,5).Value = G.DefAmp;
                    break;
                end
                handles.VelecNewVal(index,4).String=num2str(amptemp);
                handles.VelecNewVal(index,5).Value = amptemp;
                amptemp=amptemp+1;
            end
            if amptemp>G.MaxAmp && G.tAmp > G.Timeoutamp
                G.ActPanel.LoopIndicator=0;
            end
        elseif   G.ActPanel.LoopIndicator==3
            %         if amptemp<=G.MaxAmp
            %         pause(0.5);
            if get(handles.VelecNewVal(index,14),'Value')==0
                %             handles.VelecNewVal(index,4).String=num2str(G.DefAmp);
                %             handles.VelecNewVal(index,5).Value = G.DefAmp;
                break;
            end
            handles.VelecNewVal(index,4).String=num2str(amptemp);
            handles.VelecNewVal(index,5).Value = amptemp;
            amptemp=amptemp+amptempm;
            %         end
            if amptemp>=G.MaxAmp || amptemp<=G.MinAmp
                amptempm=amptempm*-1;
                %            amptemp=G.MaxAmp;
            end
        elseif   G.ActPanel.LoopIndicator==4
            if get(handles.VelecNewVal(index,15),'Value')==0
                break;
            end
            handles.VelecNewVal(index,4).String=num2str(amptemp);
            handles.VelecNewVal(index,5).Value = amptemp;
            amptemp=floor((G.MaxAmp+G.MinAmp)/2*(1+sin(2*pi*G.tAmp/G.Timeamp)));
        end
        drawnow;
        
        
        
        
        
        
        
        if handles.VelecNew(4,2).Value== 1 && G.FESStimOn.Flg==1
            if strcmp(G.FESStimOn.Name , handles.VelecNew(1,2).String) && strcmp(G.FESStimOn.ID , handles.VelecNew(2,2).String)
                
                
                amp=handles.VelecNewVal(index,4).String;
                
                %         cmd=sprintf("velec %s *amp %s=%s",G.FESStimOn.ID, eventdata.Source.Parent.Title, amp);
                %         writeline(G.deviceFES,cmd);
                %         ReceiveFESData(handles);
                
                n=G.SelectedVelecNo-1;
                
                G.Elec(n).AmpUpdate(ActiveNo)=str2num(amp);
                
                
                %         cmd=sprintf("velec %s *amp 1=%d,2=%d,3=%d,4=%d,5=%d,6=%d,7=%d,8=%d,9=%d,10=%d,11=%d,12=%d,13=%d,14=%d,15=%d,16=%d",G.FESStimOn.ID, G.Elec(n).AmpUpdate);
                %         writeline(G.deviceFES,cmd);
                %         ReceiveFESData(handles);
                
                FESCommand(G.FESStimOn.ID,'amp',G.Elec(n).AmpUpdate)
                
                handles.VelecNew(4,4).String='Amp changed';
                handles.VelecNew(4,4).ForegroundColor='g';
                
            end
        end
    end
end

end