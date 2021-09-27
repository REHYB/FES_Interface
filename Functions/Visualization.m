%%
function Visualization(i,A,g,Angle,handles,diszshow,disx,Rtheta)
global G
%     G.h1(1).XData = [0:0.01:G.t];
%     G.h1(2).XData = [0:0.01:G.t];
%     G.h1(3).XData = [0:0.01:G.t];
%     G.h2(1).XData = [0:0.01:G.t];
%     G.h2(2).XData = [0:0.01:G.t];
%     G.h2(3).XData = [0:0.01:G.t];

tstart=(G.t>=10)*(G.t-10);
if(mod(i,floor(128/G.PlotUpdateFreq))==0)
    if G.ShowDataFlg==1
        ShowData(G.t,A,g,Angle,handles);
    end
    tspan=[tstart tstart+12];
    % Sp=[(G.c(end)>=100)*(G.c(end)-100)+1:G.c(end)];
    Sp=[1:G.c(end)];
    
    if G.Plot.ForceDataFlg==1
        xlim(G.s1,tspan);
        xlim(G.s2,tspan);
        
        %                 ylim(G.s1,[0 3]);
        
        
        %             G.h1.XData = [G.t-1/128*(BuffSize(i)-1):1/128:G.t];
        %             G.h1.YData = (D(:,1) + D(:,2))/2.0;
        
        
        
        
        if ~G.Force_point
            G.h1.XData = G.t_r(Sp)';
            G.h1.YData = (G.data(Sp,1) + G.data(Sp,2))/2.0;
        else
            G.h1.XData = G.t_r(Sp(end))';
            G.h1.YData = (G.data(Sp(end),1) + G.data(Sp(end),2))/2.0;
        end
        %                     if G.StartFlg==1 && G.plotforceflg==0
        %                         a=1;
        %                         G.plotforceflg=1;
        %                         G.ejecttry=G.ejecttry+1;
        %                         G.h0.XData =  G.t_r(G.c(1):end)';
        %                         G.h0.YData =  Force*ones(1,length(G.t_r(G.c(1):end)'));
        %                         %                 subplot(2,2,1); hold on;
        %                         %                 plot(t_ref(G.c(1):end)', Force*ones(1,length(t_ref(G.c(1):end)')))
        %                         leg2=sprintf('Critical Grip Force (%d)',G.ejecttry);
        %                         l0.String(2)={leg2};
        %                     end
        G.h0.XData =  G.t_r(Sp)';
        G.h0.YData = G.Force.D.H(Sp);
        
        
        G.h2.XData = G.t_r(Sp)';
        G.h2.YData = G.data(Sp,3);
    end
    %             xlim(s3,tspan);
    %             G.h3(1).XData = t_ref(Sp)';
    %             G.h3(2).XData = t_ref(Sp)';
    %             G.h3(3).XData = t_ref(Sp)';
    %
    %             G.h3(1).YData = G.data(Sp,4);
    %             G.h3(2).YData = G.data(Sp,5);
    %             G.h3(3).YData = G.data(Sp,6);
    
    
    if exist('Force')
        G.Force0=Force;
    end
    
    
    y=diszshow;
    x=disx/10;
    if G.Plot.Cube2DFlg==1
        G.Force0=G.Force.D.H(Sp(end));
        NF=mean(G.data(G.c,1) + G.data(G.c,2))/2.0/G.Force0;
        
        r=(NF<=1)*(2-NF)*G.r0 + (NF>1)*exp(-(NF-1));
        %             G.h4(1).XData = G.r0 * cos(th) + x;
        %             G.h4(1).YData = G.r0 * sin(th) + y;
        %
        %             G.h4(2).XData = r * cos(th) + x;
        %             G.h4(2).YData = r * sin(th) + y;
        
        aaa=Rtheta.'*[0.05*[-1 -1 1 1 -1];[0 0 0 0 0];0.1*[-1 1 1 -1 -1]];
        G.h4(1).XData =  aaa(1,:)+ x*ones(1,5);
        G.h4(1).YData = -aaa(3,:)+ y*ones(1,5);
        G.h4(2).XData =  r *aaa(1,:) + x*ones(1,5);
        G.h4(2).YData = -r *aaa(3,:) + y*ones(1,5);
        
        %                 G.h4(1).XData = 0.05*[-1 -1 1 1 -1] + x*ones(1,5);
        %                 G.h4(1).YData = 0.1*[-1 1 1 -1 -1] + y*ones(1,5);
        
        %                 G.h4(2).XData = r *0.05*[-1 -1 1 1 -1] + x*ones(1,5);
        %                 G.h4(2).YData = r *0.1*[-1 1 1 -1 -1] + y*ones(1,5);
        
        %             G.h1.YData = (G.data(:,1) + G.data(:,2))/2.0;
        %             G.h2.YData = G.data(:,3);
        %
        %             G.h3(1).YData = G.data(:,4);
        %             G.h3(2).YData = G.data(:,5);
        %             G.h3(3).YData = G.data(:,6);
        G.h3(1).XData = 0.5*[-1 -1 1 1 -1] ;
        G.h3(1).YData = [-1 1 1 -1 -1] ;
        
        G.h3(2).XData = r *0.5*[-1 -1 1 1 -1] ;
        G.h3(2).YData = r *[-1 1 1 -1 -1] ;
    end
    
    if G.Plot.Cube3DFlg==1
        if mean(G.data(G.c,1) + G.data(G.c,2))/2.0< 0.2
            surf_c='k';
        else
            surf_c='r';
        end
        
        %PlotCube3D(position,Angle.theta,Angle.phi,surf_c)
        PlotCube3D([0;0;y],-Angle.phi,-Angle.theta,surf_c);
        
        if handles.VelecStimOn.Value==1 && y>0.1 && mean(G.data(G.c,3))<1
            G.stopcontrol=1;
            %             handles.VelecStimOn.Value=0;
            %             FESControlCommand_Callback(0, 0, handles)
        end
    end
    if G.Plot.ControlDataFlg==1
        for j=1:16
            %Sp
            G.h6(j).XData = G.t_r(1:G.realtimev(end))';
            G.h6(j).YData = G.AmpHistory(1:G.realtimev(end),j);
            xlim(G.s6(j),tspan);
        end
    end
    if G.Plot.BallandBeamFlg==1
        %                     r=G.ball.radious;l=G.beam.length;
        G.tetaball=G.tetaball+0.01/180*pi*1/128*G.c(end)*10*sign(-Angle.theta)*max(abs(-Angle.theta*10)^2,1)*(abs(Angle.theta)>2.0/180*pi);
        
        if G.des>0
            if (G.tetaball-Angle.theta)>0.95*G.des0
                G.des=G.des*-1;
            end
        else
            if (G.tetaball-Angle.theta)<-0.95*G.des0
                G.des=G.des*-1;
            end
        end
        
        
        BallandBeam(G.tetaball-Angle.theta,Angle.theta,G.des);
    end
    
    
    
    if G.Plot.SKGameFlg==1 && G.c(1)>0
        fSK=mean(G.data(G.c,1) + G.data(G.c,2))/2.0;
        SKGameFun(handles,G.t,fSK);
    end
    
    drawnow
    
    
end
end