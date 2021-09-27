%% Qualisys
function QualisysInit_Callback(hObject, eventdata, handles)
global G
handles.Report(3,2).String=sprintf('Please wait for conncetion ...\n');
drawnow;
G.Q.param.fs = 1000;
G.Q.param.td = 60*60;

G.Q.x = linspace(0,G.Q.param.td,G.Q.param.td*G.Q.param.fs+1);

%% initiate qualisys
q_cmd.stream = 'StreamFrames Frequency:30 3D';
q_cmd.getParam = 'GetParameters 3D';
q_cmd.close = 'StreamFrames Stop';
addpath('Qualisys_Fun');
G.Q.qtm_h.stream = qtm_cmd(q_cmd.stream);
G.Q.qtm_h.getParam = qtm_cmd(q_cmd.getParam);
G.Q.qtm_h.close = qtm_cmd(q_cmd.close);
port = 22222;
try
    G.Q.qtm = tcpclient('localhost',port);
    
    write(G.Q.qtm,G.Q.qtm_h.getParam)
    pause(1)
    qtm_package = read(G.Q.qtm);
    
    try
        G.Q.param.qtm.markerName = qtm_markerName(cast(qtm_package(9:end),'char')); % find marker names
        handles.Indicator(3,1).BackgroundColor='g';
        handles.Report(3,2).String=sprintf('Device is connected successfully.\n');
        s=sprintf('Marker Label:\n');
        for j=1:length(G.Q.param.qtm.markerName)
            s=sprintf('%s\n%d) %s',s,j,cell2mat(G.Q.param.qtm.markerName(j)));
        end
        handles.Report(3,1).String= s;
        
        G.Qualisys.Flg=1;
    catch
        handles.Report(3,2).String=sprintf('Device is connected successfully; But Markers are not defined. Please try again...\n');
        handles.Indicator(3,1).BackgroundColor=[0.7 0.7 0.7];
    end
    
    
catch
    G.Qualisys.Flg=0;
    handles.Report(3,2).String=sprintf('Problem in Connection, please try again...\n');
    handles.Indicator(3,1).BackgroundColor='r';
end
% pause(1);

%% get marker info
if G.Qualisys.Flg
    
    G.Q.NoMarker = size(G.Q.param.qtm.markerName,2);
    
    G.Q.f1=figure; G.Q.f1.NumberTitle='off';G.Q.f1.Name='Qualysis';
    G.Q.f1.Visible='off';
    G.Q.start=0;
    %     G.Q.SaveCnt=0;
    handles.Q.button=uicontrol(G.Q.f1,'Style','togglebutton');
    handles.Q.button.String='Show';
    G.Q.p1 = plot3(zeros(1,G.Q.NoMarker),zeros(1,G.Q.NoMarker),zeros(1,G.Q.NoMarker),'bo','MarkerFaceColor','b');
    grid on
    axis([-5 5 -5 5 0 2]*1000);
    G.Q.p1.Visible='off';
    G.Q.p1.Parent.Visible='off';
    
    handles.Q.button.Callback={@QualisysPlotShow,handles};
    
    write(G.Q.qtm,G.Q.qtm_h.stream);
end

end