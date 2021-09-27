%%
function initialization(handles)
global G
G.stopcontrol=0;
G.ControlStartwithdelay=0;
G.tControlStartwithdelay=0;
G.SKGame.Start=0;
G.SKGame.fileIsOpen=0;
handles.Report(1,2).String=sprintf('Task started...\n');
drawnow;
handles.mitem(3,3).Enable='on';
handles.mitem(3,4).Enable='on';
G.Terminate=0;
G.stop=0;
handles.mitem(3,2).Text='Reset and Start again';
handles.mitem(3,3).Text='Stop';

handles.mitem(4,1).Enable='on';

handles.f.HandleVisibility='off';
handles.f2.HandleVisibility='off';
handles.f3.HandleVisibility='off';
handles.f10(1).HandleVisibility='off';
handles.f10(2).HandleVisibility='off';
G.Q.f1.HandleVisibility='off';
close all, clc
handles.f.HandleVisibility='on';
handles.f2.HandleVisibility='on';
handles.f3.HandleVisibility='on';
handles.f10(1).HandleVisibility='on';
handles.f10(2).HandleVisibility='on';
G.Q.f1.HandleVisibility='on';
G.firstCube=1;

G.freq = 128; % hz
tfinal = 3600*2;
G.t_r = 0:1/G.freq:tfinal+1;
n = size(G.t_r,2);
G.data = nan(n,6);
G.AmpHistory=nan(n,16);
% G.Force.D.H=nan(n,16);
G.Force.D.H=3.0 + 0*2*(mod(floor(G.t_r/10),2)==1) + 0*2.5*sin(0.5*G.t_r);



if G.Plot.Cube2DFlg==1
    f2=figure;f2.Name='Test_Simulation'; f2.Units='normalized';%f2.Position=[0    0.0463    1.0000    0.8667];
    %     f2.Position=[1.4115    0.7843    0.8365    1.1157];
    set(f2,'color','w');
    % s3=subplot(2,2,3);
    % G.h3 = plot(t_ref'.*ones(1,3),G.data(:,4:6)); % plot nans
    % ylim(s3,[-2 2]);hold on
    % xlim(s3,[0 td])
    % grid on;
    
    s3=subplot(2,2,1);
    x=0;y=0;
    xunit = 0.5*[-1 -1 1 1 -1] + x*ones(1,5);
    yunit = [-1 1 1 -1 -1] + y*ones(1,5);
    xunit2 = 2*0.5*[-1 -1 1 1 -1] + x*ones(1,5);
    yunit2 = 2*[-1 1 1 -1 -1] + y*ones(1,5);
    
    G.h3 = plot([xunit' xunit2'], [yunit' yunit2']);
    G.h3(1).Color='r';
    G.h3(2).Color='b';
    G.h3(2).LineStyle='--';
    ylim(s3,[-2 2]);hold on
    xlim(s3,[-2 2]);
    axis equal;
    
    if ~G.Plot.Cube2DFlg
        G.stext=subplot(2,2,3);
        %     G.s1=subplot(2,2,3);
        % stext.YTick=[];stext.XTick=[];
        G.stext.XColor='non';
        G.stext.YColor='non';
        aa=text(0.45,0.5,'');
    else
        G.s1=subplot(2,2,3);
        up=max(G.Force.D.H/1.4);
        G.s1_1=fill([0;4000;4000;0;0]',[-0.5;-0.5;up;up;-0.5]','b');hold on
        G.s1_1.FaceColor='y';
        G.s1_1.EdgeColor='y';
        G.s1_2=fill([0;4000;4000;0;0]',[up;up;up*2.25;up*2.25;up]','b');
        G.s1_2.FaceColor='g';
        G.s1_2.EdgeColor='g';
        if ~G.Force_point
            G.h1 = plot(G.t_r',(G.data(:,1:1)+G.data(:,1:1))/2.0);
            G.h1.LineWidth=1.5;
        else
            G.h1 = plot(G.t_r(1)',(G.data(1,1:1)+G.data(1,1:1))/2.0,'bo');
            %         G.h1.LineWidth=1.5;
        end
        hold on;
        G.h0 = plot(G.t_r',nan(n,1));
        G.h0.LineWidth=1.5;
        % G.h1 = plot(0,0,'.');
        % ylim(G.s1,[-3 3]);
        xlim(G.s1,[0 tfinal]);
        grid on; hold on
        % legend('Grip Force');
        l0=legend('Sliding','without Sliding','Grip Force','Desirable');
        % l0=legend('Grip Force');
        l0.Location='west';
        G.s1.YLabel.String='Grip Force(N)';
        ylim(G.s1,[-0.2 2.25*up]);
    end
    
    
    s4=subplot(1,2,2);
    th = 0:pi/50:2*pi;
    G.r0=1;x=0.0;y=0.0;
    % xunit = G.r0 * cos(th) + x;
    % yunit = G.r0 * sin(th) + y;
    % xunit2 = 2*G.r0 * cos(th) + x;
    % yunit2 = 2*G.r0 * sin(th) + y;
    
    xunit = 0.05*[-1 -1 1 1 -1] + x*ones(1,5);
    yunit = 0.1*[-1 1 1 -1 -1] + y*ones(1,5);
    
    xunit2 = 2*0.05*[-1 -1 1 1 -1] + x*ones(1,5);
    yunit2 = 2*0.1*[-1 1 1 -1 -1] + y*ones(1,5);
    
    G.h4 = plot([xunit' xunit2'], [yunit' yunit2']);
    G.h4(1).Color='r';
    G.h4(2).Color='b';
    G.h4(2).LineStyle='--';
    ylim(s4,[-0.2 0.8]);hold on
    xlim(s4,0.5*[-1 1]);
    % axis equal;
    grid on
    hold on
    ground=plot([-1 1],[-0.1 -0.1],'k');
    ground.LineWidth=3;
    %     Top=plot([-1 1],0.25*[1 1],'k');
    %     Top.LineWidth=3;
    tt=text(0.33,-0.1,'Table');
    tt.Units='normalized';
    tt.VerticalAlignment='bottom';
    G.h4(1).Parent.XTick=[];
    G.h4(1).Parent.YTick=[];
    G.h3(1).Parent.XTick=[];
    G.h3(1).Parent.YTick=[];
    
    
end
if G.Plot.Cube3DFlg==1
    %PlotCube3D(position,G.Angle.theta,G.Angle.phi,surf_c)
    PlotCube3D([0;0;0],0,0,'k');
end
if G.Plot.ForceDataFlg==1
    f1=figure;f1.Name='ForceData'; f1.Units='normalized';%f1.Position=[-1.1182    1.4083    0.3646    0.4861];
    set(f1,'color','w');
    
    if ~G.Plot.Cube2DFlg
        G.s1=subplot(2,1,1);
        
        G.h1 = plot(G.t_r',(G.data(:,1:1)+G.data(:,1:1))/2.0);
        hold on;
        G.h0 = plot(G.t_r',nan(n,1));
        % G.h1 = plot(0,0,'.');
        % ylim(G.s1,[-3 3]);
        xlim(G.s1,[0 tfinal]);
        grid on; hold on
        % legend('Grip Force');
        l0=legend('Grip Force','');
        % l0=legend('Grip Force');
        G.s1.YLabel.String='Grip Force(N)';
    end
    
    G.s2=subplot(2,1,2);
    
    G.h2 = plot(G.t_r',G.data(:,3));
    % ylim(G.s2,[-5 5]);
    xlim(G.s2,[0 tfinal]);
    grid on;hold on
    legend('Load');
    G.s2.YLabel.String='Load(N)';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if G.Plot.ControlDataFlg==1
    f4=figure;f4.Name='ControlData'; f4.Units='normalized';%f4.Position = f1.Position - [f1.Position(3) 0 0 0];
    %     f4.Position = [0.9885    1.2926    0.4229    0.6074];
    set(f4,'color','w');
    for i=1:16
        G.s6(i)=subplot(4,4,i);
        G.h6(i) = plot(G.t_r',G.AmpHistory(:,i));
        G.h6(i).LineWidth=2;
        G.h6(i).Color='r';
        grid on;
        hold on;
        xlim(G.s6(i),[0 tfinal]);
        G.s6(i).YLabel.String=sprintf('Elec %d:Amp(mA)',i);
    end
    
end
if G.HKRDesktop
    f1.Position = [-1.4172    1.4046    0.3646    0.4861];
    f4.Position = [-1.1260    0.8204    0.3646    0.4861];
end
%%%%%%%%%%%%%%%%%%%%%%
if G.Plot.BallandBeamFlg==1
    G.firstBallandBeam=1;
    BallandBeam(0,0,0);
    % BallandBeam(0,0,0);
end

if G.Plot.SKGameFlg==1
    handles.f10(1).Visible='on';
    handles.f10(2).Visible='on';
end
%%%%%%%%%%%%%%%%%%%%
% if G.Plot.SKGameFlg==1
%     handles.f2.Visible='on';
% end
%%%%%%%%%%%%%%%%%%%%%
drawnow
%%


G.MaxLoad=0;
G.timea_old=0;
G.startCnt=0;
G.StartFlg=0;
G.plotforceflg=0;
G.atotal=0;

% G.A.time=0;
G.vz=0;
G.vx=0;
G.disz=0;
G.diszshow=0;
G.disx=0;
G.azave=0;
G.astepfilt=0;
G.abodymean=[0;0;0];
G.A.b.vectorMean=[0;0;0];
G.muav=0;
G.muCnt=0;
G.Angle.phi=0;
G.Angle.theta=0;
G.g=9.81;
G.GripForce=0;
% G.dm = [];

G.c = 0;


G.int1=0;


G.ejecttry=0;
G.Force0=max(G.Force.D.H);

if (isfield(G,'deviceForce')==1)
    if G.force_sensor_protocol==1
        flushinput(G.deviceForce);
    elseif G.force_sensor_protocol==2
        flush(G.deviceForce);
    elseif G.force_sensor_protocol==3
        flush(G.deviceForce);
    end
end



G.ZeroByteCnt=1;
G.ForceSensorConnection=1;

G.BadDataCnt=0;
G.tCalibration=10; % sec.
G.control.FirstTime=1;
G.tetaball=0;
G.des0=2;
G.des=G.des0;
G.ZeroByteCnt=0;
G.CinpOld=0;

G.Cnt=1;
G.BuffSizeMean=0;
G.BadDataCnt=0;
G.CorrectDataCnt=0;

% %% Qualisys
% if G.Qualisys.Flg
%     addpath('Qualisys_Fun');
%     QualisysInit();
% end
%%

tic
G.t = toc;
G.t_connection=G.t;

G.velecAmpOnlineChangeInLoopFlg=1;
if G.velecAmpOnlineChangeInLoopFlg==1
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback;
else
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback0;
end
for i=1:16
    handles.VelecNewVal(i,4).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,5).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,10).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,11).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,12).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,13).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,14).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,15).Callback={velecAmpOnlineChangeFun,handles};
end
end