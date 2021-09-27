%% Initialize Interface
function Initialize_Interface(hObject, eventdata)
clear all, close all, clc;
global G

G.Control.Cathodes.Flg=zeros(1,16);
% G.availablePort=serialportlist("available");
G.tempflg=0;
G.HKRDesktop=0;
G.Control.Active=0;
G.velecAmpOnlineChangeInLoopFlg=0;
G.AutoRun.GeneralInit.flg=0;
G.Q.SaveCnt=0;
G.Q.calibrationCnt=0;
G.Q.calibration=0;
%  G.Q.Maxd0   = [107.0155  133.2090  134.3033  131.7009  105.4746];%zeros(1,5);
G.Q.Maxd0  = [117.4018  138.5969  155.6246  154.4117  121.2255]; % QFES2


G.force_sensor_protocol=3;
G.FES_protocol=3;


% Finding port number based on name or ID:
G.deviceForce_findmode=3; % 1: based on ID (Name is not important), useful for having several GFbox; 2: based on name (ID is not impotant here); 3: Directly define comport
G.deviceForce_ID='0012F306B122'; % not important when G.deviceForce_findmode==2 or 3
G.deviceForce_Name='GF-Box-3';   % not important when G.deviceForce_findmode==1 or 3
G.deviceForce_com="COM8";        % not important when G.deviceForce_findmode==1 or 2

G.deviceFES_findmode=3; % 1: work based on ID (Name is not inportant), useful for having several FES; 2: based on name (ID is not impotant here)3: Directly define comport
G.deviceFES_ID='0016A474BDB5'; % not important when G.deviceFES_findmode==2 or 3
G.deviceFES_Name='REHYB.2019'; % not important when G.deviceForce_findmode==1 or 3
G.deviceFES_com="COM4";        % not important when G.deviceForce_findmode==1 or 2

comflg=0;
fileIDCom = fopen('FESCOMNo.txt','r');
comtemp=fscanf(fileIDCom,'%s');
if length(comtemp)>3
    if strcmp(comtemp(1:3),'COM')
        G.deviceFES_com=comtemp;
        comflg=1;
    end
end
fclose(fileIDCom);
if ~comflg
    
    msg=sprintf("Please Enter the FES COMport number in FESCOMNo.txt (for instance: COM4) then run the program again.\nIn Windows, after pairing the FES with your computer, you can find comport here:\nSettings>Bluetooth & other devices>More Bluetooth options>Compot tab");
    warndlg(msg,'COMport number missed');
    return
end

%% Plot Option
G.ShowDataFlg=1;
G.PlotUpdateFreq=8; %% Hz
G.Plot.Cube3DFlg=0;
G.Plot.BallandBeamFlg=0;
G.Plot.ForceDataFlg=0;
G.Plot.Cube2DFlg=0;
G.Plot.ControlDataFlg=1;
G.Force_point=0;

G.Plot.SKGameFlg=0;
G.SKGame.PlotTextFlg=0;
G.SKGame.TextCntFlg=1;
G.SKGame.HintTextFlg=1;
G.SKGame.Min=4;
G.SKGame.Max=5;
G.SKGame.No=20;
G.SKGame.fileIsOpen=0;
G.SKGame_BasedOnTimeFlg=1;
G.SKGame.WriteDataMethod=4;%1: Online when plot it (average); 2: Online when plot it (all the remained buffer);3: Online when plot it (all the remained buffer + new line);3: After Pressing Stop (all the data from Start to Stop)



%% Default Value:
G.FESStimOn.Flg=0;

G.MinWidth=100;
G.MaxWidth=400;
G.DefWidth=300;

G.DefFreq=30;
G.DefID=randi([11 15],1);
G.DefName=sprintf("%s",strcat("SKtest",(datestr(now,'yyyymmdd')),"_",sprintf("%d",randi([1 50],1))));

G.MaxAmpSafety=20; % Change it carefully and if you are sure about it

G.MinAmp=0;
G.MaxAmp=12; % can be modified in Interface
if G.MaxAmp> G.MaxAmpSafety
    G.MaxAmp=G.MaxAmpSafety;
end
G.DefAmp=0;
G.Timeamp=5;
G.Timeoutamp=7;
G.Auto.timedelay=2;

G.Feedback.No=1;


G.Control.Gain.Proportional=0;
G.Control.Gain.Integral=0;
G.Control.Gain.Derivative=0;

G.ControlAmpOld=zeros(1,16);

G.ball.radious=0.3;G.beam.length=4;

% Qualisys:
G.Qualisys.Flg=0;
G.Q.plotupdatefreq=100;

% G.Auto.cathod=[4,6,3,1,5,7,8,9,10,11,12,13,14,15];
% G.Auto.cathod=[4,6,3,9,10,11,12,1,5,7,8,13,14,15];
G.Auto.cathod={4;6;3;1;5;7;8;9;10;11;12;13;14;15};
% G.Auto.cathod={1;9;13;4;5;10;14;6;7;11;15;3;8;12};
% G.Auto.cathod={1;5;7;8;9;10;11;12;4;6;3;13;14;15};
% G.Auto.cathod={1;5;7;8;9;10;11;12};
% G.Auto.cathod={[5,6];[4]};
% G.Auto.cathod=[4,6,3,9,10,11,12];
% G.Auto.cathod=[1,5,7,8,13,14,15];
% G.Auto.cathod=[13,14,15];
%% Create User Interference
handles.f=figure(100);
handles.f.Units='normalized';
set(handles.f,'DefaultUicontrolUnits','normalized');
% handles.f.Position = [ -1.42    0.8    0.3    0.4];
% handles.f.Position = [-1.0516    1.4963    0.3000    0.4000];
% handles.f.Position = [-1.7839    1.5269    0.3000    0.4000];
if G.HKRDesktop
    handles.f.Position = [-1.0516    1.4963    0.3000    0.4000];
end

handles.f.MenuBar='none';handles.f.NumberTitle='off';handles.f.Name='FES_GripForce_Control';
handles.mitem(1,1) = uimenu(handles.f,'Text','Init'); handles.mitem(1,1).Enable='on';
handles.mitem(1,2) = uimenu(handles.mitem(1,1),'Text','Initialize Interface Again');
handles.mitem(1,3) = uimenu(handles.mitem(1,1),'Text','COMPort Check');
handles.mitem(2,1) = uimenu(handles.f,'Text','Setting'); handles.mitem(2,1).Enable='on';
handles.mitem(2,2) = uimenu(handles.mitem(2,1),'Text','Connect (Force Sensor)');
handles.mitem(2,3) = uimenu(handles.mitem(2,1),'Text','Disconnect (Force Sensor)');
handles.mitem(2,4) = uimenu(handles.mitem(2,1),'Text','Connect (FES)');
handles.mitem(2,5) = uimenu(handles.mitem(2,1),'Text','Disconnect (FES)');
handles.mitem(2,6) = uimenu(handles.mitem(2,1),'Text','FES Initialization');handles.mitem(2,6).Enable='off';
handles.mitem(2,7) = uimenu(handles.mitem(2,1),'Text','Qualisys Initialization');
handles.mitem(2,8) = uimenu(handles.mitem(2,1),'Text','General Initialization');
handles.mitem(3,1) = uimenu(handles.f,'Text','Run'); %handles.mitem(3,1).Enable='off';
handles.mitem(3,2) = uimenu(handles.mitem(3,1),'Text','Start');
handles.mitem(3,3) = uimenu(handles.mitem(3,1),'Text','Stop');handles.mitem(3,3).Enable='off';
handles.mitem(3,4) = uimenu(handles.mitem(3,1),'Text','Terminate');handles.mitem(3,4).Enable='off';
handles.mitem(4,1) = uimenu(handles.f,'Text','Post Processing'); handles.mitem(4,1).Enable='off';
handles.mitem(4,2) = uimenu(handles.mitem(4,1),'Text','Plot');handles.mitem(4,2).Enable='off';
handles.mitem(4,3) = uimenu(handles.mitem(4,1),'Text','Add Legend');
handles.mitem(4,4) = uimenu(handles.mitem(4,1),'Text','Save Plot');
handles.mitem(4,5) = uimenu(handles.mitem(4,1),'Text','Close Figs');

%% Report
handles.Report(1,1) = uicontrol(handles.f,'Style','text');
handles.Report(1,1).String=sprintf('Time (sec.) = %.3f',0.0);
handles.Report(1,1).BackgroundColor='w';
handles.Report(1,1).HorizontalAlignment='l';
handles.Report(1,1).Position = [0.01    0.43    0.32    0.4];

handles.Report(1,2) = uicontrol(handles.f,'Style','text');
handles.Report(1,2).String=sprintf('Please Select Connect (Force Sensor) through Setting Tab.\n');
handles.Report(1,2).BackgroundColor='w';
handles.Report(1,2).HorizontalAlignment='l';
handles.Report(1,2).Position = [0.01    0.24    0.32    0.18];

handles.Report(2,1) = uicontrol(handles.f,'Style','text');
handles.Report(2,1).String=sprintf('');
handles.Report(2,1).BackgroundColor='w';
handles.Report(2,1).HorizontalAlignment='l';
handles.Report(2,1).Position = [0.34    0.43    0.32    0.4];

handles.Report(2,2) = uicontrol(handles.f,'Style','text');
handles.Report(2,2).String=sprintf('Please Select Connect (FES Device) through Setting Tab.\n');
handles.Report(2,2).BackgroundColor='w';
handles.Report(2,2).HorizontalAlignment='l';
handles.Report(2,2).Position = [0.34    0.24    0.32    0.18];

handles.Report(3,1) = uicontrol(handles.f,'Style','text');
handles.Report(3,1).String=sprintf('');
handles.Report(3,1).BackgroundColor='w';
handles.Report(3,1).HorizontalAlignment='l';
handles.Report(3,1).Position = [0.67    0.43    0.32    0.4];

handles.Report(3,2) = uicontrol(handles.f,'Style','text');
handles.Report(3,2).String=sprintf('Please Select Qualysis Initialization through Setting Tab.\n');
handles.Report(3,2).BackgroundColor='w';
handles.Report(3,2).HorizontalAlignment='l';
handles.Report(3,2).Position = [0.67    0.24    0.32    0.18];

handles.Reportgen = uicontrol(handles.f,'Style','text');
handles.Reportgen.String=sprintf('');
handles.Reportgen.BackgroundColor='w';
handles.Reportgen.HorizontalAlignment='l';
handles.Reportgen.Position = [0.01    0.12    0.98    0.1];

handles.Indicator(1,1) = uicontrol(handles.f,'Style','text');
handles.Indicator(1,1).String=sprintf('');
handles.Indicator(1,1).BackgroundColor='r';
handles.Indicator(1,1).HorizontalAlignment='l';
handles.Indicator(1,1).Position = [0.02    0.97    0.015    0.02];

handles.Indicator(1,2) = uicontrol(handles.f,'Style','text');
handles.Indicator(1,2).String=sprintf('Connection (GFBox)');
handles.Indicator(1,2).BackgroundColor=[0.941 0.941 0.941];
handles.Indicator(1,2).HorizontalAlignment='l';
handles.Indicator(1,2).Position = [0.035    0.96    0.3    0.04];

handles.Indicator(2,1) = uicontrol(handles.f,'Style','text');
handles.Indicator(2,1).String=sprintf('');
handles.Indicator(2,1).BackgroundColor='r';
handles.Indicator(2,1).HorizontalAlignment='l';
handles.Indicator(2,1).Position = [0.33    0.97    0.015    0.02];

handles.Indicator(2,2) = uicontrol(handles.f,'Style','text');
handles.Indicator(2,2).String=sprintf('Connection (FES)');
handles.Indicator(2,2).BackgroundColor=[0.941 0.941 0.941];
handles.Indicator(2,2).HorizontalAlignment='l';
handles.Indicator(2,2).Position = [0.35    0.96    0.3    0.04];

handles.Indicator(3,1) = uicontrol(handles.f,'Style','text');
handles.Indicator(3,1).String=sprintf('');
handles.Indicator(3,1).BackgroundColor='r';
handles.Indicator(3,1).HorizontalAlignment='l';
handles.Indicator(3,1).Position = [0.67    0.97    0.015    0.02];

handles.Indicator(3,2) = uicontrol(handles.f,'Style','text');
handles.Indicator(3,2).String=sprintf('Connection (Qualysis)');
handles.Indicator(3,2).BackgroundColor=[0.941 0.941 0.941];
handles.Indicator(3,2).HorizontalAlignment='l';
handles.Indicator(3,2).Position = [0.69    0.96    0.3    0.04];

for i=1:3
    for j=1:2
        handles.Indicator(i,j).FontUnits='normalized';
        handles.Indicator(i,j).FontSize = 0.8;
    end
end

handles.VelecStimOn = uicontrol(handles.f,'Style','togglebutton');
handles.VelecStimOn.String='on';
handles.VelecStimOn.Position = [0.49    0.88    0.1    0.06];
handles.VelecStimOn.Enable='off';
handles.VelecStimOn.Visible='off';

handles.VelecPopup = uicontrol(handles.f,'Style','popupmenu');
handles.VelecPopup.String={'Select...'};
handles.VelecPopup.Position = [0.34    0.9    0.15    0.04];
handles.VelecPopup.Enable='off';
handles.VelecPopup.Visible='off';
handles.VelecPopup.FontUnits='normalized';
handles.VelecPopup.FontSize = 0.7;

handles.VelecDef = uicontrol(handles.f,'Style','togglebutton');
handles.VelecDef.String='Define New Velec';
handles.VelecDef.Position = [0.34    0.830    0.20    0.05];
handles.VelecDef.Enable='off';
handles.VelecDef.Visible='off';

handles.Record.T = uicontrol(handles.f,'Style','edit');
handles.Record.T.String='File_Name';
handles.Record.T.Position = [0.01    0.01    0.20    0.05];

handles.Record.B = uicontrol(handles.f,'Style','togglebutton');
handles.Record.B.String='Start Recording Data';
handles.Record.B.Position = [0.22    0.01    0.20    0.05];
handles.Record.B.Enable='off';

handles.Record.QCalibration = uicontrol(handles.f,'Style','togglebutton');
handles.Record.QCalibration.String='GraspCalibration';
handles.Record.QCalibration.Position = [0.44    0.01    0.20    0.05];
handles.Record.QCalibration.Enable='off';

handles.f2=figure(101);
handles.f2.Units='normalized';
set(handles.f2,'DefaultUicontrolUnits','normalized');
handles.f2.MenuBar='none';handles.f2.NumberTitle='off';handles.f2.Name='DefineNewVelec';
% handles.f2.Position = [0    0.0463    1.0000    0.9269];
% handles.f2.Position = handles.f.Position - [0    1.09*handles.f.Position(4)    0    0];
handles.f2.Visible='off';


handles.VelecNew(1,1) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(1,1).String='New Velec Name:';
handles.VelecNew(1,1).HorizontalAlignment='left';
handles.VelecNew(1,1).BackgroundColor=[0.941 0.941 0.941];
handles.VelecNew(1,1).Position = [0.17    0.97    0.15    0.03];
handles.VelecNew(1,1).FontUnits='normalized';
handles.VelecNew(1,1).FontSize = 0.8;
handles.VelecNew(1,1).Tooltip  =sprintf("""%s"" is a default name\n You can change it and then Press Enter",sprintf("%s",G.DefName));


handles.VelecNew(1,2) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(1,2).String=sprintf("%s",G.DefName);
handles.VelecNew(1,2).Position = handles.VelecNew(1,1).Position - [0 0.03 0 0];
handles.VelecNew(1,2).FontUnits='normalized';
handles.VelecNew(1,2).FontSize = 0.8;
handles.VelecNew(1,2).Tooltip  =sprintf("""%s"" is a default name\n You can change it and then Press Enter",sprintf("%s",G.DefName));


handles.VelecNew(2,1) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(2,1).String='New Velec ID:';
handles.VelecNew(2,1).HorizontalAlignment='left';
handles.VelecNew(2,1).BackgroundColor=[0.941 0.941 0.941];
handles.VelecNew(2,1).Position = [0.33    0.97    0.15    0.03];
handles.VelecNew(2,1).FontUnits='normalized';
handles.VelecNew(2,1).FontSize = 0.8;
handles.VelecNew(2,1).Tooltip  =sprintf("""%s"" is a default ID\n You can change it and then Press Enter",sprintf("%d",G.DefID));

handles.VelecNew(2,2) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(2,2).String=sprintf("%d",G.DefID);
handles.VelecNew(2,2).Position = handles.VelecNew(2,1).Position - [0 0.03 0 0];
handles.VelecNew(2,2).FontUnits='normalized';
handles.VelecNew(2,2).FontSize = 0.8;
handles.VelecNew(2,2).Tooltip  =sprintf("""%s"" is a default ID\n You can change it and then Press Enter",sprintf("%d",G.DefID));

handles.VelecNew(3,1) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(3,1).String='New Velec Freq:';
handles.VelecNew(3,1).HorizontalAlignment='left';
handles.VelecNew(3,1).BackgroundColor=[0.941 0.941 0.941];
handles.VelecNew(3,1).Position = [0.49    0.97    0.15    0.03];
handles.VelecNew(3,1).FontUnits='normalized';
handles.VelecNew(3,1).FontSize = 0.8;

handles.VelecNew(3,2) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(3,2).String=sprintf("%d",G.DefFreq);
handles.VelecNew(3,2).Position = handles.VelecNew(3,1).Position - [0 0.03 0 0];
handles.VelecNew(3,2).FontUnits='normalized';
handles.VelecNew(3,2).FontSize = 0.8;
handles.VelecNew(3,1).Tooltip  =sprintf("""%d"" is a default Freq.(Hz)\n You can change it and then Press Enter",G.DefFreq);
handles.VelecNew(3,2).Tooltip  =sprintf("""%d"" is a default Freq.(Hz)\n You can change it and then Press Enter",G.DefFreq);

handles.VelecNew(4,1) = uicontrol(handles.f2,'Style','pushbutton');
handles.VelecNew(4,1).String='Save & Send';
handles.VelecNew(4,1).Position = [0.73    0.94    0.12    0.03];
handles.VelecNew(4,1).FontUnits='normalized';
handles.VelecNew(4,1).FontSize = 0.8;
handles.VelecNew(4,1).Tooltip  =sprintf('It will be Send FES and Can be called (turned on) for stimulation\nIt also will be saved for future use\n Do not Save various Virtual Electerod with same ID & Name');

handles.VelecNew(4,2) = uicontrol(handles.f2,'Style','checkbox');
handles.VelecNew(4,2).String='Online';
handles.VelecNew(4,2).Position = [0.73    0.97    0.12    0.03];
handles.VelecNew(4,2).FontUnits='normalized';
handles.VelecNew(4,2).FontSize = 0.8;
handles.VelecNew(4,2).Value=1;

handles.VelecNew(4,3) = uicontrol(handles.f2,'Style','togglebutton');
handles.VelecNew(4,3).String='Stim On';
handles.VelecNew(4,3).Position = [0.86    0.97    0.12    0.03];
handles.VelecNew(4,3).FontUnits='normalized';
handles.VelecNew(4,3).FontSize = 0.8;
handles.VelecNew(4,3).Enable='off';

handles.VelecNew(4,4) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(4,4).String=''; % save condition
handles.VelecNew(4,4).Position = [0.86    0.94    0.14    0.03];
handles.VelecNew(4,4).FontUnits='normalized';
handles.VelecNew(4,4).HorizontalAlignment='left';
handles.VelecNew(4,4).FontSize = 0.8;


handles.VelecNew(4,5) = uicontrol(handles.f2,'Style','togglebutton');
handles.VelecNew(4,5).String='?';
handles.VelecNew(4,5).Position = [0.97    0.97    0.03    0.03];
handles.VelecNew(4,5).FontUnits='normalized';
handles.VelecNew(4,5).FontSize = 0.8;
handles.VelecNew(4,5).Tooltip  = 'Help (Click to see the Electrodes position)';

handles.VelecNew(4,6) = uicontrol(handles.f2,'Style','togglebutton');
handles.VelecNew(4,6).String='Export to Control';
handles.VelecNew(4,6).Position = [0.01    0.91    0.16    0.03];
handles.VelecNew(4,6).FontUnits='normalized';
handles.VelecNew(4,6).HorizontalAlignment='left';
handles.VelecNew(4,6).FontSize = 0.5;
handles.VelecNew(4,6).Tooltip  =sprintf('Use Selected Electrodes in Control\n');
handles.VelecNew(4,6).Enable='off';

handles.VelecNew(4,7) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(4,7).String=sprintf("Control Gain:");
handles.VelecNew(4,7).Position = [0.01    0.88    0.08    0.03];
handles.VelecNew(4,7).FontUnits='normalized';
handles.VelecNew(4,7).FontSize = 0.5;
handles.VelecNew(4,7).HorizontalAlignment='left';
handles.VelecNew(4,7).Tooltip  =sprintf('Control Gain\n Proportional coef., Integral coef., Derivative coef.\nEnter new value and Press Enter');
handles.VelecNew(4,7).Enable='on';

handles.VelecNew(4,8) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(4,8).String=sprintf("%.2f, %.2f, %.2f", G.Control.Gain.Proportional,G.Control.Gain.Integral,G.Control.Gain.Derivative);
handles.VelecNew(4,8).Position = [0.08    0.88    0.09    0.03];
handles.VelecNew(4,8).FontUnits='normalized';
handles.VelecNew(4,8).FontSize = 0.5;
handles.VelecNew(4,8).Tooltip  =sprintf('Control Gain\n Proportional coef., Integral coef., Derivative coef.\nEnter new value and Press Enter');
handles.VelecNew(4,8).Enable='on';

handles.VelecNew(4,9) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(4,9).String=sprintf("Stim Feature:");
handles.VelecNew(4,9).Position = [0.01    0.85    0.07    0.03];
handles.VelecNew(4,9).FontUnits='normalized';
handles.VelecNew(4,9).FontSize = 0.5;
handles.VelecNew(4,9).HorizontalAlignment='left';
handles.VelecNew(4,9).Tooltip  =sprintf('FES intensity and time bound\n Amp period time (for ramp, triangle, & sinusoidal stimulation), Amp time out, Max Amp\nEnter new value and Press Enter');
% handles.VelecNew(4,9).Visible='off';

handles.VelecNew(4,10) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(4,10).String=sprintf("%.1f, %.1f, %.1f, %.1f", G.Timeamp,G.Timeoutamp, G.MaxAmp, G.Auto.timedelay);
handles.VelecNew(4,10).Position = [0.08    0.85    0.09    0.03];
handles.VelecNew(4,10).FontUnits='normalized';
handles.VelecNew(4,10).FontSize = 0.5;
handles.VelecNew(4,10).Tooltip  =sprintf('FES intensity and time bound\n Amp period time (for ramp, triangle, & sinusoidal stimulation), Amp time out, Max Amp \nEnter new value and Press Enter \n\nNote:"Max Amp" cannot be bigger than %d, however if you need Amp>%d and you are sure this amount is safe you can change "G.MaxAmpSafety" directly in the code',G.MaxAmpSafety,G.MaxAmpSafety);
% handles.VelecNew(4,10).Visible='off';

handles.VelecNew(4,11) = uicontrol(handles.f2,'Style','togglebutton');
handles.VelecNew(4,11).String=sprintf(">>");
handles.VelecNew(4,11).Position = [0.25    0.91    0.02    0.03];
handles.VelecNew(4,11).FontUnits='normalized';
handles.VelecNew(4,11).FontSize = 0.7;
handles.VelecNew(4,11).Tooltip  = 'Advance Options';
handles.VelecNew(4,11).Enable='off';

handles.VelecNew(5,1) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(5,1).String='Select:';
handles.VelecNew(5,1).HorizontalAlignment='left';
handles.VelecNew(5,1).BackgroundColor=[0.941 0.941 0.941];
handles.VelecNew(5,1).Position = [0.01    0.97    0.15    0.03];
handles.VelecNew(5,1).FontUnits='normalized';
handles.VelecNew(5,1).FontSize = 0.8;
handles.VelecNew(5,1).Tooltip  =sprintf("Select desirable Velec, you can use/modify previously saved ones or creat new one");


handles.VelecNew(5,2) = uicontrol(handles.f2,'Style','popupmenu');
handles.VelecNew(5,2).String=sprintf("%s",'New');
handles.VelecNew(5,2).Position = handles.VelecNew(5,1).Position - [0 0.03 0 0];
handles.VelecNew(5,2).FontUnits='normalized';
handles.VelecNew(5,2).FontSize = 0.5;
handles.VelecNew(5,2).Tooltip  =sprintf("Select desirable Velec, you can use/modify previously saved ones or creat new one");

handles.VelecNew(6,1) = uicontrol(handles.f2,'Style','text');
handles.VelecNew(6,1).String='Note:';
handles.VelecNew(6,1).HorizontalAlignment='left';
handles.VelecNew(6,1).BackgroundColor=[0.941 0.941 0.941];
handles.VelecNew(6,1).Position = [0.28    0.92    0.3    0.02];
handles.VelecNew(6,1).FontUnits='normalized';
handles.VelecNew(6,1).FontSize = 0.8;
handles.VelecNew(6,1).Tooltip  =sprintf("this note will be saved and you can see it when you load this Velec");


handles.VelecNew(6,2) = uicontrol(handles.f2,'Style','edit');
handles.VelecNew(6,2).Max=100;
handles.VelecNew(6,2).String="";
handles.VelecNew(6,2).HorizontalAlignment='left';
handles.VelecNew(6,2).Position = handles.VelecNew(6,1).Position - [0 0.07 0 -0.05];
handles.VelecNew(6,2).FontUnits='normalized';
handles.VelecNew(6,2).FontSize = 0.25;
handles.VelecNew(6,2).Tooltip  =sprintf("this note will be saved and you can see it when you load this Velec");

handles.VelecNew(7,1) = uicontrol(handles.f2,'Style','togglebutton');
handles.VelecNew(7,1).String=sprintf("Auto");
handles.VelecNew(7,1).Position = [0.265    0.85    0.015    0.025];
handles.VelecNew(7,1).FontUnits='normalized';
handles.VelecNew(7,1).FontSize = 0.35;
handles.VelecNew(7,1).Tooltip  = 'Advance Options';

handles.VelecNew(7,2) = uicontrol(handles.f2,'Style','edit');

for i=1:size(G.Auto.cathod,1)
    tempstr=sprintf('%d,',G.Auto.cathod{i});
    tempstr=tempstr(1:end-1);
    
    if i==1
        tempstr0=tempstr;
    else
        tempstr0=strcat(tempstr0,';',tempstr);
    end
end

handles.VelecNew(7,2).String=tempstr0;
handles.VelecNew(7,2).Position = [0.17    0.875    0.11    0.025];
handles.VelecNew(7,2).FontUnits='normalized';
handles.VelecNew(7,2).FontSize = 0.5;
handles.VelecNew(7,2).Tooltip  = 'Auto cathod';

handles.Feedbackpanel = uipanel(handles.f2,'Title','Feedback','FontSize',8);
handles.Feedbackpanel.FontUnits='normalized';
handles.Feedbackpanel.Position= [0.59    0.85    0.39    0.09];
handles.Feedbackpanel.FontSize=0.1;

G.Fingers=["Thumb","Index","Middle","Ring","Little","General","Grasping","other1","other2"];
G.sensing=["none","sensing","First Mov","Desirable Mov","Max Mov","Pain"];
G.sensingColor=['k','c','b','g','m','r']';
for i=1:length(G.Fingers)
    handles.Feedback(i,1) = uicontrol(handles.Feedbackpanel,'Style','text');
    handles.Feedback(i,1).String=G.Fingers(i);
    handles.Feedback(i,1).HorizontalAlignment='left';
    handles.Feedback(i,1).BackgroundColor=[0.941 0.941 0.941];
    handles.Feedback(i,1).Position = [0.01+ (0.5)*(i>5)    1-0.2*i*(i<=5)-0.2*(i-5)*(i>5)    0.1    0.19];
    handles.Feedback(i,1).FontUnits='normalized';
    handles.Feedback(i,1).FontSize = 0.8;
    handles.Feedback(i,1).Tooltip  =sprintf("You can save your observation in excitation, fingers' movement, and pain (sensing, Min, Max, threshold, pain)");
    
    handles.Feedback(i,2) = uicontrol(handles.Feedbackpanel,'Style','text');
    handles.Feedback(i,2).String='none';
    handles.Feedback(i,2).HorizontalAlignment='left';
    handles.Feedback(i,2).BackgroundColor=[0.941 0.941 0.941];
    handles.Feedback(i,2).ForegroundColor=G.sensingColor(1);
    handles.Feedback(i,2).Position = [0.16+ (0.5)*(i>5)    1-0.2*i*(i<=5)-0.2*(i-5)*(i>5)    0.1    0.19];
    handles.Feedback(i,2).FontUnits='normalized';
    handles.Feedback(i,2).FontSize = 0.8;
    handles.Feedback(i,2).Tooltip  =sprintf("You can save your observation in excitation, fingers' movement, and pain (sensing, Min, Max, threshold, pain)");
    
    handles.Feedback(i,3) = uicontrol(handles.Feedbackpanel,'Style','slider');
    handles.Feedback(i,3).Max=5;
    handles.Feedback(i,3).SliderStep=[0.2 0.2];
    %     handles.Feedback(i,3).String=Fingers(i);
    %     handles.Feedback(i,3).HorizontalAlignment='left';
    handles.Feedback(i,3).BackgroundColor=[0.941 0.941 0.941];
    handles.Feedback(i,3).Position = [0.29+ (0.5)*(i>5)    1-0.2*i*(i<=5)-0.2*(i-5)*(i>5)    0.2    0.19];
    handles.Feedback(i,3).FontUnits='normalized';
    handles.Feedback(i,3).FontSize = 0.8;
    handles.Feedback(i,3).Tooltip  =sprintf("You can save your observation in excitation, fingers' movement, and pain (sensing, Min, Max, threshold, pain)");
    
end
n=length(G.Fingers)+1;

handles.Feedback(n,1) = uicontrol(handles.Feedbackpanel,'Style','edit');
handles.Feedback(n,1).String='';
handles.Feedback(n,1).HorizontalAlignment='left';
handles.Feedback(n,1).Position = [0.51    0    0.1    0.19];
handles.Feedback(n,1).FontUnits='normalized';
handles.Feedback(n,1).FontSize = 0.8;
handles.Feedback(n,1).Tooltip  =sprintf("Enter the Name of File to save the Feedback");

handles.Feedback(n,2) = uicontrol(handles.Feedbackpanel,'Style','edit');
handles.Feedback(n,2).String=G.Feedback.No;
handles.Feedback(n,2).HorizontalAlignment='left';
handles.Feedback(n,2).Position = [0.66    0    0.1    0.19];
handles.Feedback(n,2).FontUnits='normalized';
handles.Feedback(n,2).FontSize = 0.8;
handles.Feedback(n,2).Tooltip  =sprintf("Number of Saved Feedback");

handles.Feedback(n,3) = uicontrol(handles.Feedbackpanel,'Style','pushbutton');
handles.Feedback(n,3).String='Save Feedback';
handles.Feedback(n,3).HorizontalAlignment='left';
handles.Feedback(n,3).Position = [0.79    0    0.2    0.19];
handles.Feedback(n,3).FontUnits='normalized';
handles.Feedback(n,3).FontSize = 0.8;
handles.Feedback(n,3).Tooltip  =sprintf("save your observation");

%
% [G.PicFin1,G.PicFin2,G.PicFin3] = imread('Fingures.png');
% % G.PicFin3=imresize(G.PicFin1, [42 113]);
% % G.background = rgb2gray(G.background);
% % myImage = imread('as.jpg');
% handles.axes1 = axes(handles.Feedbackpanel,'Position',[0.01 0.01 0.1 0.9]);
%
% set(handles.axes1,'Units','pixels');
% resizePos = get(handles.axes1,'Position');
% G.PicFin1= imresize(G.PicFin1, [resizePos(3) resizePos(3)]);
% imshow(G.PicFin1);
% set(handles.axes1,'Units','normalized');


%
G.Elecorder=[2 4 6 3 1 5 7 8 9 10 11 12 13 14 15 16];

for i=1:16
    
    handles.VelecNewVal(i,1) = uipanel(handles.f2,'Position',[0.01 + floor((i-1)/4)*0.25 0.65-(mod((i-1),4))*0.21 0.24 0.2]);
    handles.VelecNewVal(i,1).Title=sprintf('%d',G.Elecorder(i));
    handles.VelecNewVal(i,1).BorderType='etchedin'; % 'none' | 'etchedin' | 'etchedout' | 'beveledin' | 'beveledout' | 'line'.
    
    
    handles.VelecNewVal(i,2) = uicontrol(handles.VelecNewVal(i,1),'Style','popup');
    handles.VelecNewVal(i,2).Position = [0.01    0.80    0.6    0.2];
    handles.VelecNewVal(i,2).String   = {'Disable','Cathod','Anode'};
    
    handles.VelecNewVal(i,3) = uicontrol(handles.VelecNewVal(i,1),'Style','text');
    handles.VelecNewVal(i,3).Position = [0.01    0.35    0.25    0.25];
    handles.VelecNewVal(i,3).String   = 'Amp.';
    handles.VelecNewVal(i,3).HorizontalAlignment='left';
    
    handles.VelecNewVal(i,4) = uicontrol(handles.VelecNewVal(i,1),'Style','edit');
    handles.VelecNewVal(i,4).Position = [0.27    0.35    0.35    0.25];
    handles.VelecNewVal(i,4).Tooltip  = 'Enter Amplitude';
    
    handles.VelecNewVal(i,5) = uicontrol(handles.VelecNewVal(i,1),'Style','slider');
    handles.VelecNewVal(i,5).Position = [0.63    0.40    0.35    0.15];
    handles.VelecNewVal(i,5).Tooltip  = 'Drag Slider to Change Amplitude';
    handles.VelecNewVal(i,5).Min=G.MinAmp;
    handles.VelecNewVal(i,5).Max=G.MaxAmp;
    
    handles.VelecNewVal(i,6) = uicontrol(handles.VelecNewVal(i,1),'Style','text');
    handles.VelecNewVal(i,6).Position = [0.01    0.05    0.25    0.25];
    handles.VelecNewVal(i,6).String   = 'Wid.';
    handles.VelecNewVal(i,6).HorizontalAlignment='left';
    
    handles.VelecNewVal(i,7) = uicontrol(handles.VelecNewVal(i,1),'Style','edit');
    handles.VelecNewVal(i,7).Position = [0.27    0.05    0.35    0.25];
    handles.VelecNewVal(i,7).Tooltip  = 'Enter New width (between 100 & 400)';
    
    handles.VelecNewVal(i,8) = uicontrol(handles.VelecNewVal(i,1),'Style','slider');
    handles.VelecNewVal(i,8).Position = [0.63    0.10    0.35    0.15];
    handles.VelecNewVal(i,8).Tooltip  = 'Drag Slider to Change Width';
    handles.VelecNewVal(i,8).Min=G.MinWidth;
    handles.VelecNewVal(i,8).Max=G.MaxWidth;
    
    handles.VelecNewVal(i,9) = uicontrol(handles.VelecNewVal(i,1),'Style','checkbox');
    handles.VelecNewVal(i,9).Position = [0.65    0.65    0.45    0.15];
    handles.VelecNewVal(i,9).String   = 'Control';
    handles.VelecNewVal(i,9).Tooltip  =sprintf( 'Use this Electrode as Cathode in Closed-Loop Control\nAfter selecting all desirable Electrodes push "Export to Control"\n');
    
    handles.VelecNewVal(i,10) = uicontrol(handles.VelecNewVal(i,1),'Style','pushbutton');
    handles.VelecNewVal(i,10).Position = [0.62    0.85    0.05    0.15];
    handles.VelecNewVal(i,10).String   = 'R';
    handles.VelecNewVal(i,10).Tooltip  = 'Reset';
    
    handles.VelecNewVal(i,11) = uicontrol(handles.VelecNewVal(i,1),'Style','pushbutton');
    handles.VelecNewVal(i,11).Position = [0.68    0.85    0.05    0.15];
    handles.VelecNewVal(i,11).String   = 'h';
    handles.VelecNewVal(i,11).Tooltip  = 'Half of Maximum Amp';
    handles.VelecNewVal(i,11).Tooltip  = sprintf("Half of Maximum Amp:\n. . . . . . . . . . \n. . . . . . . . . . .\n. . . . . . . . . . .\n. . . ***********\n. . . * . . . . . . .\n.**** . . . . . . .");
    
    handles.VelecNewVal(i,12) = uicontrol(handles.VelecNewVal(i,1),'Style','pushbutton');
    handles.VelecNewVal(i,12).Position = [0.74    0.85    0.05    0.15];
    handles.VelecNewVal(i,12).String   = 'M';
    handles.VelecNewVal(i,12).Tooltip  = sprintf("Maximum Amp:\n. . . ********\n. . . * . . . . . . .\n. . . * . . . . . . .\n. . . * . . . . . . .\n. . . * . . . . . . .\n.**** . . . . . . .");
    
    
    handles.VelecNewVal(i,13) = uicontrol(handles.VelecNewVal(i,1),'Style','togglebutton');
    handles.VelecNewVal(i,13).Position = [0.80    0.85    0.05    0.15];
    handles.VelecNewVal(i,13).String   = 'r';
    %     handles.VelecNewVal(i,13).Tooltip  = sprintf("ramp Amp:\n. . . . . . . . . . . ====\n. . . . . . . . . . // . . .\n. . . . . . . . . // . . . .\n. . . . . . . . // . . . . .\n. . . . . . . // . . . . . .\n.==== . . . . . . .");
    handles.VelecNewVal(i,13).Tooltip  = sprintf("ramp Amp:\n. . . . . . . ****\n. . . . . . * . . . .\n. . . . . * . . . . .\n. . . . * . . . . . .\n. . . * . . . . . . .\n.*** . . . . . . . .");
    
    handles.VelecNewVal(i,14) = uicontrol(handles.VelecNewVal(i,1),'Style','togglebutton');
    handles.VelecNewVal(i,14).Position = [0.86    0.85    0.05    0.15];
    handles.VelecNewVal(i,14).String   = 't';
    %     handles.VelecNewVal(i,14).Tooltip  = 'triangle Amp';
    handles.VelecNewVal(i,14).Tooltip  = sprintf("triangle Amp:\n. . . . . . *. . . . .\n. . . . . * . * . . . .\n. . . . * . . . * . . .\n. . . * . . . . . * . . .\n. . * . . . . . . . * . . .\n.* . . . . . . . . . .* . . .");
    
    handles.VelecNewVal(i,15) = uicontrol(handles.VelecNewVal(i,1),'Style','togglebutton');
    handles.VelecNewVal(i,15).Position = [0.92    0.85    0.05    0.15];
    handles.VelecNewVal(i,15).String   = 's';
    handles.VelecNewVal(i,15).Tooltip  = 'sinusoidal Amp';
    %     handles.VelecNewVal(i,15).Tooltip  = sprintf("triangle Amp:\n. . . . . . ** . . . . .\n. . . . * . . . * . . . .\n. . .* . . . . . * . . .\n. . . * . . . . . * . . .\n. . * . . . . . . . * . . .\n.* . . . . . . . . . .* . . .");
    
    handles.VelecNewVal(i,16) = uicontrol(handles.VelecNewVal(i,1),'Style','text');
    handles.VelecNewVal(i,16).String   = 'Anode';
    handles.VelecNewVal(i,16).Position = [0.25    0.2    0.5    0.3];
    handles.VelecNewVal(i,16).HorizontalAlignment='center';
    handles.VelecNewVal(i,16).ForegroundColor='r';
    
    handles.VelecNewVal(i,17) = uicontrol(handles.VelecNewVal(i,1),'Style','text');
    handles.VelecNewVal(i,17).String   = 'Disabled';
    handles.VelecNewVal(i,17).Position = [0.25    0.2    0.5    0.3];
    handles.VelecNewVal(i,17).HorizontalAlignment='center';
    handles.VelecNewVal(i,17).ForegroundColor=[0.5, 0.5, 0.5];
    
    for j=2:17
        handles.VelecNewVal(i,j).FontUnits='normalized';
        handles.VelecNewVal(i,j).FontSize = 0.8;
    end
    
    for j=3:17-1
        handles.VelecNewVal(i,j).Visible='off';
    end
    
end


handles.f3=figure(103);handles.f3.Units='normalized';handles.f3.MenuBar='none';handles.f3.NumberTitle='off';handles.f3.Name='ElectrodesPosition';
handles.f3.Visible='off';
G.background = imread('electrodes.jpg');
% G.background = rgb2gray(G.background);
imshow(G.background);

% handles.f4=figure(104);
% handles.f4.Units='normalized';
% set(handles.f4,'DefaultUicontrolUnits','normalized');
% handles.f4.MenuBar='none';handles.f4.NumberTitle='off';handles.f4.Name='Advance_Options';
% handles.f4.Position = handles.f2.Position - [ handles.f2.Position(3)    0    0    0];
% % handles.f2.Visible='off';
%%
%% Setting Option:
G.Setting_Name={'Select ...','Time','Control Method', 'Desirable Trajectory',...
    'Actuator','Muscle Activation','Muscle Fatigue','Live Plot','Post Processing'};

G.Setting(1).Popname={'...'};

G.Setting(2).Popname={'Select ...','Simulation Time (sec.)','Start of Control (sec.)','End of Control (sec.)'};
G.Setting(2).Type={'edit','edit','edit','edit'};
G.Setting(2).TypeName={'','30','0','30'};
G.Setting(2).Value=[0,30,0,30];

G.Setting(3).Popname={'Select ...','Control Method'};
G.Setting(3).Type={'edit','popupmenu'};
G.Setting(3).TypeName={'',{'Control Method 1 (Arm_SE)';'Control Method 2 (Arm26)'}};
G.Setting(3).Value=[0,2];

G.Setting(4).Popname={'Select ...','Desirable Trajectory'};
G.Setting(4).Type={'edit','popupmenu'};
G.Setting(4).TypeName={'',{'Constant Trajectory';'Sinusoidal Trajectory';'Constant + Sinusoidal Trajectory'}};
G.Setting(4).Value=[0,1];

G.Setting(5).Popname={'Select ...','Actuator Model', 'Actuator Time Constant (sec.)','Actuator delay (sec.)'};
G.Setting(5).Type={'edit','checkbox','edit','edit'};
G.Setting(5).TypeName={'','Active','',''};
G.Setting(5).Value=[0,0,0.001,0];

G.Setting(6).Popname={'Select ...','Muscle Activation Model', 'Muscle Activation Time Constant (sec.)'};
G.Setting(6).Type={'edit','checkbox','edit'};
G.Setting(6).TypeName={'','Active',''};
G.Setting(6).Value=[0,1,0.26];

G.Setting(7).Popname={'Select ...','Muscle Fatigue Model', 'Muscle Fatigue Time Constant (sec.)', 'Muscle recovery Time Constant (sec.)', 'Fatigue_min'};
G.Setting(7).Type={'edit','checkbox','edit','edit','edit'};
G.Setting(7).TypeName={'','Active','',''};
G.Setting(7).Value=[0,0,9.34,68.19,0.0654];

G.Setting(8).Popname={'Select ...','Live Plot'};
G.Setting(8).Type={'edit','checkbox'};
G.Setting(8).TypeName={'','Active'};
G.Setting(8).Value=[0,0];

G.Setting(9).Popname={'Select ...','hold on previous Plot'};
G.Setting(9).Type={'edit','checkbox'};
G.Setting(9).TypeName={'','Active'};
G.Setting(9).Value=[0,1];

handles.p1 = uipanel(handles.f2,'Title','Setting','FontSize',8);
handles.p1.FontUnits='normalized';
handles.p1.Position=[0.28 0.85 0.7 0.09];
handles.p1.FontSize=0.2;
handles.p1.Visible='off';





handles.f10(1)=figure(201);
handles.f10(1).Units='normalized';
set(handles.f10(1),'DefaultUicontrolUnits','normalized');
handles.f10(1).MenuBar='none';handles.f10(1).NumberTitle='off';handles.f10(1).Name='SKGame_Administrator';
handles.f10(1).Visible='off';

G.SKGame.PMax=G.SKGame.Max*1.5;
G.SKGame.PMin=-(G.SKGame.Max-G.SKGame.Min)/2;
G.SKGame.r=(G.SKGame.Max-G.SKGame.Min)/2;
G.SKGame.RScale=1;

G.SKGame.UI.text=["Patient Name","Max Force","Min Force","No. of Stimulation","Rest(beforehand)","Duration","Rest(afterward)","Max y axis","Min y axis", "Radious Scale","Mode","Color/Text"];
G.SKGame.UI.Hint=["Patient Name","Max Desirable Force (N)","Min Desirable Force (N)","Number of Stimulation","Res Time (sec.) Before Each Stimulation (Total Rest=Rest (beforhand) + Rest(afterward))","Duration of Each Stimulation (sec.)","Res Time (sec.) After Each Stimulation  (Total Rest=Rest (beforhand) + Rest(afterward))","Max y Axis","Min y Axis", "Radious of Circle","1: Based on Time (SK version); 2: Based on Time (TUM version); 3: Based on Being in Desirable Region","Color: lb: light blue; b:dark blue; g:green; r:red; c:cyan; m:magenta; y:yellow; k:black; w:white"];
G.SKGame.UI.edit=["Tom",num2str(G.SKGame.Max),num2str(G.SKGame.Min),G.SKGame.No,"2","3","2+3", num2str(G.SKGame.PMax),num2str(G.SKGame.PMin),num2str(G.SKGame.RScale),G.SKGame_BasedOnTimeFlg,"w,r,g,b,Pause,Drücken,Drücken,Öffnen"];

for i=1:length(G.SKGame.UI.text)
    
    handles.SKGame(i,1) = uicontrol(handles.f10(1),'Style','text');
    handles.SKGame(i,1).String=G.SKGame.UI.text(i);
    handles.SKGame(i,1).HorizontalAlignment='left';
    handles.SKGame(i,1).BackgroundColor=[0.941 0.941 0.941];
    handles.SKGame(i,1).Position = [0.01   0.96-0.082*(i-1)    0.25    0.035];
    handles.SKGame(i,1).FontUnits='normalized';
    handles.SKGame(i,1).FontSize = 0.8;
    handles.SKGame(i,1).Tooltip  =G.SKGame.UI.Hint(i);
    
    handles.SKGame(i,2) = uicontrol(handles.f10(1),'Style','edit');
    handles.SKGame(i,2).String=G.SKGame.UI.edit(i);
    handles.SKGame(i,2).HorizontalAlignment='left';
    handles.SKGame(i,2).BackgroundColor=[0.941 0.941 0.941];
    handles.SKGame(i,2).Position = [0.01   0.92-0.082*(i-1)    0.25    0.035];
    handles.SKGame(i,2).FontUnits='normalized';
    handles.SKGame(i,2).FontSize = 0.8;
    handles.SKGame(i,2).Tooltip  =G.SKGame.UI.Hint(i);
end

handles.SKGame(1,3) = uicontrol(handles.f10(1),'Style','togglebutton');
handles.SKGame(1,3).String='Start';
handles.SKGame(1,3).HorizontalAlignment='Center';
handles.SKGame(1,3).Position = [0.55   0.2    0.2    0.1];
handles.SKGame(1,3).FontUnits='normalized';
handles.SKGame(1,3).FontSize = 0.8;
handles.SKGame(1,3).Tooltip  = sprintf("Click to Start\nWhen you click on Start a file with patient name, date, and trial information will be created in Schon_Klinik_Feedback folder.\n Time and force data will be save on this file.\n This file will be closed as you click on Stop )");

handles.SKGame(1,4) = uicontrol(handles.f10(1),'Style','pushbutton');
handles.SKGame(1,4).String='Apply';
handles.SKGame(1,4).HorizontalAlignment='Center';
handles.SKGame(1,4).Position = [0.30   0.01    0.1    0.05];
handles.SKGame(1,4).FontUnits='normalized';
handles.SKGame(1,4).FontSize = 0.8;
handles.SKGame(1,4).Tooltip  = sprintf("Click to Apply change on visualization (Start button also do this before starting task, so Apply button is not essential)");

handles.SKGame(1,5) = uicontrol(handles.f10(1),'Style','text');
handles.SKGame(1,5).String={'Wait for the start ...';'';''};
handles.SKGame(1,5).HorizontalAlignment='left';
handles.SKGame(1,5).BackgroundColor=[1 1 1];
handles.SKGame(1,5).Position = [0.45   0.01    0.4    0.18];
handles.SKGame(1,5).FontUnits='normalized';
handles.SKGame(1,5).FontSize = 0.15;
handles.SKGame(1,5).Tooltip  =G.SKGame.UI.Hint(i);

for i=1:2
    if i==2
        handles.f10(i)=figure(202);
        handles.f10(i).Units='normalized';
        set(handles.f10(i),'DefaultUicontrolUnits','normalized');
        handles.f10(i).MenuBar='none';handles.f10(i).NumberTitle='off';handles.f10(i).Name='SKGame_User';
        handles.f10(i).Visible='off';
        
    end
    
    G.SKGame.ax(i) = axes(handles.f10(i));
    
    G.SKGame.ax(i).Units = 'normalized';
    G.SKGame.s(i)=(handles.f10(i).Position(4))/(handles.f10(i).Position(3));
    G.SKGame.ax(i).Position = [0.35 0.35 0.64 0.64];
    
    if i==2
        G.SKGame.ax(i).Position = [0.0 0.0 1 1];
    end
    
    G.SKGame.rgbtext=split(G.SKGame.UI.edit(12),',');
    if strcmp(G.SKGame.rgbtext(1),'lb')
        G.SKGame.rgb1=[ 0.5843 0.8157 0.9882];
    else
        G.SKGame.rgb1=G.SKGame.rgbtext(1);
    end
    if strcmp(G.SKGame.rgbtext(1),'lb')
        G.SKGame.rgb2=[ 0.5843 0.8157 0.9882];
    else
        G.SKGame.rgb2=G.SKGame.rgbtext(2);
    end
    if strcmp(G.SKGame.rgbtext(1),'lb')
        G.SKGame.rgb3=[ 0.5843 0.8157 0.9882];
    else
        G.SKGame.rgb3=G.SKGame.rgbtext(3);
    end
    if strcmp(G.SKGame.rgbtext(1),'lb')
        G.SKGame.rgb4=[ 0.5843 0.8157 0.9882];
    else
        G.SKGame.rgb4=G.SKGame.rgbtext(4);
    end
    
    G.SKGame.Plot1(i)=fill([0;G.SKGame.PMax;G.SKGame.PMax;0;0]',[G.SKGame.Min;G.SKGame.Min;G.SKGame.Max;G.SKGame.Max;G.SKGame.Min]','b');
    G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb1;
    G.SKGame.Plot1(i).EdgeColor='k';
    hold on;
    
    if G.SKGame.HintTextFlg==1
        G.SKGame.HintText(i)=text(G.SKGame.PMax/2,(G.SKGame.Min+G.SKGame.Max)/2,'');
        G.SKGame.HintText(i).String=G.SKGame.rgbtext(5);
        G.SKGame.HintText(i).FontUnits='normalized';
        G.SKGame.HintText(i).FontSize=0.08;
        G.SKGame.HintText(i).HorizontalAlignment='Center';
    end
    
    
    G.SKGame.t = (0:0.01:1)'*2*pi;
    G.SKGame.x = G.SKGame.r*cos(G.SKGame.t);
    G.SKGame.y = G.SKGame.r*sin(G.SKGame.t);
    % G.SKGame.Plot2=fill(0.5*G.SKGame.PMax+G.SKGame.x,G.SKGame.y,'r');
    G.SKGame.Plot2(i)=plot(0.5*G.SKGame.PMax,0,'o');
    G.SKGame.Plot2(i).MarkerSize=handles.f10(i).Position(3)*G.SKGame.RScale*30;
    G.SKGame.Plot2(i).MarkerFaceColor=[0.941 0.941 0.941];
    % G.SKGame.Plot2.MarkerEdgeColor=[0.941 0.941 0.941];
    
    
    % G.SKGame.Plot3=plot(0.5*G.SKGame.PMax+G.SKGame.x,G.SKGame.y+0.5,'-.r');
    G.SKGame.Plot3(i)=plot(0.5*G.SKGame.PMax,4*G.SKGame.r,'o');
    G.SKGame.Plot3(i).MarkerSize=G.SKGame.Plot2.MarkerSize;
    G.SKGame.Plot3(i).MarkerEdgeColor='r';
    
    if G.SKGame_BasedOnTimeFlg~=3
        G.SKGame.Plot3(i).Visible='off';
    else
        G.SKGame.Plot3(i).Visible='on';
    end
    
    
    if G.SKGame.PlotTextFlg==1
        G.SKGame.Plot3_text(i)=text(0.5*G.SKGame.PMax,0.5,'');
        G.SKGame.Plot3_text(i).String={"Catch Me";"If You Can:)"};
        G.SKGame.Plot3_text(i).FontUnits='normalized';
        G.SKGame.Plot3_text(i).FontSize=0.03;
        G.SKGame.Plot3_text(i).HorizontalAlignment='Center';
    end
    
    if G.SKGame.TextCntFlg==1
        G.SKGame.TextCnt(i)=text(0.01,0.00,'');
        G.SKGame.TextCnt(i).String=sprintf("0/%d",G.SKGame.No);
        G.SKGame.TextCnt(i).FontUnits='normalized';
        G.SKGame.TextCnt(i).FontSize=0.08;
        G.SKGame.TextCnt(i).HorizontalAlignment='Left';
    end
    
    % axis square;
    G.SKGame.ax(i).XLim=[0 G.SKGame.PMax];
    G.SKGame.ax(i).XTick=[];
    if i==2
        G.SKGame.ax(i).YTick=[];
    end
    G.SKGame.ax(i).YLim=[G.SKGame.PMin G.SKGame.PMax];
    % ax.XColor='non';
    
    % fff=figure;
    %  ax2=axes(fff);
    %  ax2.Children=G.SKGame.ax.Children;
end
%%
%% Deffine User Interference Functions
set(handles.mitem(1,2),'MenuSelectedFcn', {@Initialize_Interface});
set(handles.mitem(1,3),'MenuSelectedFcn', {@COMPortCheck_Callback,handles});
set(handles.mitem(2,2),'MenuSelectedFcn', {@ConnectForceSensor_Callback,handles});
set(handles.mitem(2,3),'MenuSelectedFcn', {@DisconnectForceSensor_Callback,handles});

set(handles.mitem(2,4),'MenuSelectedFcn', {@ConnectFES_Callback,handles});
set(handles.mitem(2,5),'MenuSelectedFcn', {@DisconnectFES_Callback,handles});
set(handles.mitem(2,6),'MenuSelectedFcn', {@InitializeFES_Callback,handles});
set(handles.mitem(2,7),'MenuSelectedFcn', {@QualisysInit_Callback,handles});
set(handles.mitem(2,8),'MenuSelectedFcn', {@GeneralInit_Callback,handles});

set(handles.mitem(3,2),'MenuSelectedFcn', {@Run_Callback,handles});
set(handles.mitem(3,3),'MenuSelectedFcn', {@Stop_Callback,handles});
set(handles.mitem(3,4),'MenuSelectedFcn', {@Terminate_Callback,handles});

set(handles.mitem(4,2),'MenuSelectedFcn', {@Plot_Callback,handles});
set(handles.mitem(4,3),'MenuSelectedFcn', {@Add_Legend_Callback,handles});
set(handles.mitem(4,4),'MenuSelectedFcn', {@Save_Fig_Callback,handles});
set(handles.mitem(4,5),'MenuSelectedFcn', {@Close_Fig_Callback,handles});

handles.VelecStimOn.Callback={@FESControlCommand_Callback,handles};
handles.VelecPopup.Callback={@VelecPopup_Callback,handles};
handles.VelecDef.Callback={@VelecDef_Callback,handles};
handles.Record.B.Callback={@RecordB_Callback,handles};
handles.Record.QCalibration.Callback={@QCalibration_Callback,handles};

handles.VelecNew(4,1).Callback={@SaveNewVelec_Callback,handles};
handles.VelecNew(4,2).Callback={@OnlineNewVelecCheckbox_Callback,handles};
handles.VelecNew(4,3).Callback={@OnlineStimOn_Callback,handles};
handles.VelecNew(4,5).Callback={@ElecPosHelp_Callback,handles};
handles.VelecNew(4,6).Callback={@ControlExportSelectedElec_Callback,handles};
handles.VelecNew(4,8).Callback={@ControlProportionalGain_Callback,handles};
handles.VelecNew(4,10).Callback={@FES_limit_Callback,handles};
handles.VelecNew(4,11).Callback={@Setting_Callback,handles};
handles.VelecNew(5,2).Callback={@Load_Saved_Velec_Callback,handles};

handles.VelecNew(7,1).Callback={@Auto_Velec_Callback,handles};

if G.velecAmpOnlineChangeInLoopFlg==1
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback;
else
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback0;
end

for i=1:16
    handles.VelecNewVal(i,2).Callback={@velecpopup0_Callback,handles};
    
    handles.VelecNewVal(i,4).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,5).Callback={velecAmpOnlineChangeFun,handles};
    %     addlistener(handles.VelecNewVal(i,5), 'Value', 'PostSet',velecAmpOnlineChangeFun);
    
    handles.VelecNewVal(i,7).Callback={@velecWidthOnlineChange_Callback,handles};
    handles.VelecNewVal(i,8).Callback={@velecWidthOnlineChange_Callback,handles};
    
    handles.VelecNewVal(i,10).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,11).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,12).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,13).Callback={velecAmpOnlineChangeFun,handles};
    %     handles.VelecNewVal(i,13).Interruptible='off';
    %     handles.VelecNewVal(i,13).BusyAction='cancel';
    handles.VelecNewVal(i,14).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,15).Callback={velecAmpOnlineChangeFun,handles};
end

for i=1:length(G.Fingers)
    handles.Feedback(i,3).Callback={@FeedbackSlider_Callback,handles};
end

handles.Feedback(length(G.Fingers)+1,3).Callback={@FeedbackSave_Callback,handles};

handles.SKGame(1,3).Callback={@SKGame_Callback,handles};
handles.SKGame(1,4).Callback={@SKGame_config_Callback,handles};

for i=1:length(G.SKGame.UI.text)
    handles.SKGame(i,2).Callback={@SKGame_config_Callback,handles};
end

handles.f2.KeyPressFcn={@FeedBackKeyPressFcn_Callback,handles};
handles.f.KeyPressFcn={@FeedBackKeyPressFcn_Callback,handles};


% GeneralInit_Callback(0, 0, handles);
end