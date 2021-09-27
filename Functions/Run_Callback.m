%% Main Loop
function Run_Callback(hObject, eventdata, handles)
global G

initialization(handles);
% handles.Record.B.Enable='on';
i=1;
G.ActPanel.LoopIndicator=zeros(16,1);
G.realtimev=1;
G.fff=0;
ValidDataFlg=0;

G.ActPanel.Amp=nan(16,1);
G.fff=1;
G.Auto.Flg=-1;
G.Auto.k=1;
G.CurrentlyDeactive=0;
G.tpreviouselec=G.t;


G.Auto.MaxThreshold=zeros(size(G.Auto.cathod,1),1);
G.Record.fileIsOpen=nan(3,1);

ii=1;
if G.Qualisys.Flg
    %write(G.Q.qtm,G.Q.qtm_h.stream);
    flush(G.Q.qtm);
end

while(G.Terminate==0 && ishandle(handles.f))
    tt=(floor(G.t*G.freq));
    if tt==0
        tt=1;
    end
    G.realtimev=[G.realtimev(end):tt];
    %     length(G.realtimev)
    if (G.stop==0)
        %% Data Acquisition GFBox
        if (isfield(G,'deviceForce')==1)
            [D,ValidDataFlg]=DataAcquisitionGFBox(handles);
        end
        %% Sensor Data Analysis
        if (ValidDataFlg==1)
            SensorDataAnalysis(D);
        end
        
        %% Control
        if (G.t>G.tCalibration && G.Control.Active)
            ContorlMainLoop();
        end
        
        %% Auto Amplitude change
        if (G.Auto.Flg==1)
            % FESAuto(4,'edit',0,11,handles,1);
            FESAutoAll(G.Auto.cathod{G.Auto.k},'togglebutton',4,1,handles,1);
            % FESAuto(G.Auto.cathod(G.Auto.k),'togglebutton',4,1,handles,1);
            G.Auto.Flg=2;
            G.tpreviouselec=G.t + G.Timeoutamp;
            G.CurrentlyActive=G.Auto.cathod{G.Auto.k};
        end
        
        if G.Auto.Flg==2 && (G.t > (G.tpreviouselec +G.Auto.timedelay)) && G.Auto.k<=size(G.Auto.cathod,1)
            
            if ~isequal(G.CurrentlyDeactive,G.CurrentlyActive)
                G.Auto.MaxThreshold(G.Auto.k)=G.MaxAmp;
            end
            
            if G.Auto.k<size(G.Auto.cathod,1)
                G.Auto.k=G.Auto.k+1;
                G.tpreviouselec= G.t + G.Timeoutamp;
                FESAutoAll(G.Auto.cathod{G.Auto.k},'togglebutton',4,1,handles,1);
                %                 FESAuto(G.Auto.cathod(G.Auto.k),'togglebutton',4,1,handles,1);
                G.CurrentlyActive=G.Auto.cathod{G.Auto.k};
            end
        end
        
        
        if (ValidDataFlg && G.Auto.Flg>0)
            if mean(G.data(G.c,1) + G.data(G.c,2))/2.0 > 5 && ~isequal(G.CurrentlyDeactive,G.CurrentlyActive)
                FESAutoAll(G.CurrentlyActive,'togglebutton',1,1,handles,1);
                %                 FESAuto(G.CurrentlyActive,'togglebutton',1,1,handles,1);
                G.CurrentlyDeactive=G.CurrentlyActive;
                G.tpreviouselec=G.t;
            end
        end
        
        %%
        %             FESAuto(4,'togglebutton',4,1,handles,1);
        %             FESAuto(3,'togglebutton',4,1,handles,1);
        %% Actuator Panel
        if G.velecAmpOnlineChangeInLoopFlg
            ActuatorPanelFun(handles);
            
            
            if G.fff==1
                if ~G.tempflg && ~G.Control.Active
                    FESAmpChangeFun(handles);
                end
                for j=1:16
                    G.AmpHistory(G.realtimev,j)=G.ActPanel.Amp(j);
                end
            else
                for j=1:16
                    G.AmpHistory(G.realtimev,j)=0;
                end
            end
        end
        
        %         if handles.Record.B.Value
        %         G.Record.GF.t=
        %         G.Record.GF.F=
        %         G.Record.Amp.t=G.realtimev(1);
        %         G.Record.amp.F=
        %         end
        %% Qualisys
        
        if G.Qualisys.Flg && ishandle(G.Q.f1)
            if G.t>=G.Q.x(ii) && G.t<=G.Q.x(end)
                QualisysLoop(ii);
                ii = ii+1;
            end
        end
        
        %% Visualization
        %         G.disx=0;
        %         G.diszshow=0;
        %         G.Angle=0;
        
        G.Rtheta=[1 0 0;0 1 0;0 0 1];
        
        %         if (ValidDataFlg==1)
        Visualization(i,G.A,G.g,G.Angle,handles,G.diszshow,G.disx,G.Rtheta);
        i=i+1;
        %         end
        
        %clear D;
        G.t = toc;
    else % when G.stop==1
        pause(0.01);
    end
end

end