%%
function QualisysLoop(i)
global G

qtm_package=read(G.Q.qtm);
Q = qtm_unpack(qtm_package,G.Q.param.qtm.markerName);

if Q.Size~=0
    pos_x = [];
    pos_y = [];
    pos_z = [];
    
    for j = 1:G.Q.NoMarker
        pos_x(:,j) = Q.(G.Q.param.qtm.markerName{j}).X;
        a(i)=length(Q.(G.Q.param.qtm.markerName{j}).X);
        pos_y(:,j) = Q.(G.Q.param.qtm.markerName{j}).Y;
        pos_z(:,j) = Q.(G.Q.param.qtm.markerName{j}).Z;
    end
    
    
    if G.Q.start
        G.saved.X{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_x(end,:);
        G.saved.Y{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_y(end,:);
        G.saved.Z{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_z(end,:);
        G.saved.t{G.Q.SaveCnt}(G.Q.Cnt) = G.t;
        
        G.saved0.X{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_x(end,:);
        G.saved0.Y{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_y(end,:);
        G.saved0.Z{G.Q.SaveCnt}(G.Q.Cnt,:) = pos_z(end,:);
        
        for kk=1:length( pos_x(end,:) )
            if (pos_x(end,kk)==Inf || pos_x(end,kk)==-Inf)
                for jj=G.Q.Cnt-1:-1:1
                    if ~( G.saved.X{G.Q.SaveCnt}(jj,kk)==Inf || G.saved.X{G.Q.SaveCnt}(jj,kk)==-Inf)
                        G.saved0.X{G.Q.SaveCnt}(G.Q.Cnt,kk) = G.saved.X{G.Q.SaveCnt}(jj,kk);
                        G.saved0.Y{G.Q.SaveCnt}(G.Q.Cnt,kk) = G.saved.Y{G.Q.SaveCnt}(jj,kk);
                        G.saved0.Z{G.Q.SaveCnt}(G.Q.Cnt,kk) = G.saved.Z{G.Q.SaveCnt}(jj,kk);
                        break;
                    end
                end
            end
        end
        
        
        if G.Q.calibration
            G.savedcalibration.X{G.Q.SaveCnt}{G.Q.calibrationCnt}(G.Q.Cnt3,:) = G.saved0.X{G.Q.SaveCnt}(G.Q.Cnt,:);
            G.savedcalibration.Y{G.Q.SaveCnt}{G.Q.calibrationCnt}(G.Q.Cnt3,:) = G.saved0.Y{G.Q.SaveCnt}(G.Q.Cnt,:);
            G.savedcalibration.Z{G.Q.SaveCnt}{G.Q.calibrationCnt}(G.Q.Cnt3,:) = G.saved0.Z{G.Q.SaveCnt}(G.Q.Cnt,:);
            G.Q.Cnt3=G.Q.Cnt3+1;
        end
        
        G.Q.Cnt=G.Q.Cnt+1;
        
        if (G.Auto.Flg==2 && G.t <= G.tpreviouselec )
            
            G.saved2.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_x(end,:);
            G.saved2.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_y(end,:);
            G.saved2.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_z(end,:);
            
            %             G.saved3.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_x(end,:);
            %             G.saved3.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_y(end,:);
            %             G.saved3.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = pos_z(end,:);
            
            G.saved3.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = G.saved0.X{G.Q.SaveCnt}(G.Q.Cnt-1,:);
            G.saved3.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = G.saved0.Y{G.Q.SaveCnt}(G.Q.Cnt-1,:);
            G.saved3.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,:) = G.saved0.Z{G.Q.SaveCnt}(G.Q.Cnt-1,:);
            
            G.saved2.t{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2) = G.t;
            
            
            %             for kk=1:length( pos_x(end,:) )
            %                 if (pos_x(end,kk)==Inf || pos_x(end,kk)==-Inf)
            % %                     if G.Q.Cnt2>1
            % %                         G.saved3.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved3.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2-1,kk);
            % %                         G.saved3.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved3.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2-1,kk);
            % %                         G.saved3.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved3.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2-1,kk);
            % %                     else
            %                         for jj=G.Q.Cnt-1:-1:1
            %                             if ~( G.saved.X{G.Q.SaveCnt}(jj,kk)==Inf || G.saved.X{G.Q.SaveCnt}(jj,kk)==-Inf)
            %                                 G.saved3.X{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved.X{G.Q.SaveCnt}(jj,kk);
            %                                 G.saved3.Y{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved.Y{G.Q.SaveCnt}(jj,kk);
            %                                 G.saved3.Z{G.Q.SaveCnt}{G.Auto.k}(G.Q.Cnt2,kk) = G.saved.Z{G.Q.SaveCnt}(jj,kk);
            %                                 break;
            %                             end
            %                         end
            % %                     end
            %                 end
            %             end
            
            G.Q.Cnt2=G.Q.Cnt2+1;
            
        else
            G.Q.Cnt2=1;
        end
    end
    
    if mod(i,G.Q.param.fs/G.Q.plotupdatefreq)==0
        G.Q.p1.XData = pos_x(end,:);
        G.Q.p1.YData = pos_y(end,:);
        G.Q.p1.ZData = pos_z(end,:);
        drawnow
    end
    
end

end