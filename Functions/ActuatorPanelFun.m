%%
function ActuatorPanelFun(handles)
global G

for j=1:16   % j:ActiveNo
    if ( G.ActPanel.LoopIndicator(j)>0 && G.FESStimOn.Flg)
        %         G.t=toc;
        
        ActiveNo(G.ActPanel.ActiveNo)=G.ActPanel.ActiveNo;
        %         G.index(G.ActPanel.ActiveNo)=G.ActPanel.index;
        
        if  G.ActPanel.LoopIndicator(j)==1 || ( ( G.ActPanel.LoopIndicator(j)==2 ||  G.ActPanel.LoopIndicator(j)==3) && ((G.t-G.ActPanel.told(j))>G.ActPanel.tstep || G.ActPanel.first(j)) ) || ( G.ActPanel.LoopIndicator(j)==4 && ((G.t-G.ActPanel.told(j))>G.ActPanel.first(j)/10||G.ActPanel.first(j)) )
            G.ActPanel.told(j)=G.t;
            G.ActPanel.first(j)=0;
            
            if G.t > G.ActPanel.tstart(j) + G.Timeoutamp
                G.ActPanel.LoopIndicator(j)=0;
                handles.VelecNewVal(G.index(j),4).String=num2str(G.DefAmp);
                handles.VelecNewVal(G.index(j),5).Value = G.DefAmp;
                handles.VelecNewVal(G.index(j),1).ShadowColor=[0.7 0.7 0.7];
            end
            
            if  G.ActPanel.LoopIndicator(j)==1
                G.ActPanel.LoopIndicator(j)=0;
            elseif  G.ActPanel.LoopIndicator(j)==2
                if G.ActPanel.amptemp(j)<=G.MaxAmp
                    %             pause(0.5);
                    if get(handles.VelecNewVal(G.index(j),13),'Value')==0
                        %             handles.VelecNewVal(G.index(j),4).String=num2str(G.DefAmp);
                        %             handles.VelecNewVal(G.index(j),5).Value = G.DefAmp;
                        break;
                    end
                    handles.VelecNewVal(G.index(j),4).String=num2str(G.ActPanel.amptemp(j));
                    handles.VelecNewVal(G.index(j),5).Value = G.ActPanel.amptemp(j);
                    G.ActPanel.amptemp(j)=G.ActPanel.amptemp(j)+1;
                end
                if G.ActPanel.amptemp(j)>G.MaxAmp && G.t > G.Timeoutamp + G.ActPanel.tstart(j)
                    G.ActPanel.LoopIndicator(j)=0;
                end
            elseif   G.ActPanel.LoopIndicator(j)==3
                %         if G.ActPanel.amptemp(j)<=G.MaxAmp
                %         pause(0.5);
                if get(handles.VelecNewVal(G.index(j),14),'Value')==0
                    %             handles.VelecNewVal(G.index(j),4).String=num2str(G.DefAmp);
                    %             handles.VelecNewVal(G.index(j),5).Value = G.DefAmp;
                    break;
                end
                handles.VelecNewVal(G.index(j),4).String=num2str(G.ActPanel.amptemp(j));
                handles.VelecNewVal(G.index(j),5).Value = G.ActPanel.amptemp(j);
                G.ActPanel.amptemp(j)=G.ActPanel.amptemp(j)+G.ActPanel.amptempm(j);
                %         end
                if G.ActPanel.amptemp(j)>=G.MaxAmp || G.ActPanel.amptemp(j)<=G.MinAmp
                    G.ActPanel.amptempm(j)=G.ActPanel.amptempm(j)*-1;
                    %            G.ActPanel.amptemp(j)=G.MaxAmp;
                end
            elseif   G.ActPanel.LoopIndicator(j)==4
                if get(handles.VelecNewVal(G.index(j),15),'Value')==0
                    break;
                end
                handles.VelecNewVal(G.index(j),4).String=num2str(G.ActPanel.amptemp(j));
                handles.VelecNewVal(G.index(j),5).Value = G.ActPanel.amptemp(j);
                G.ActPanel.amptemp(j)=floor((G.MaxAmp+G.MinAmp)/2*(1+sin(2*pi*(G.t-G.ActPanel.tstart(j))/G.Timeamp)));
            end
            %  drawnow;
            
            %  FESAmpChangeFun(handles,G.index(j),ActiveNo(j));
            G.fff=1;
        end
        
    end
end
%            drawnow;
end