%% Extra (not used)
% Not used anymore
function ConnectFES_Callback_old(hObject, eventdata, handles)
global G;
clc
handles.Report(2,2).String=sprintf('Please wait for FES conncetion ...\n');
drawnow;
% a=instrhwinfo('Bluetooth')
% G.deviceForce = Bluetooth("btspp://0016A474BDB5",1);
% G.deviceForce = serial ('COM3','BaudRate',115200,'Terminator','CR/LF');
% G.deviceForce = serial ('COM3','BaudRate',115200);
% G.deviceForce = serial ('COM3','BaudRate',115200);
% % % % % % device = serialport("COM7",57600,"Timeout",5);
% % % % % % data = read(device,16,"uint32");
% fopen(G.deviceForce);
% % configureTerminator(G.deviceForce,"CR/LF");
% fwrite(G.deviceForce,"iam DESKTOP\r\n")
% G.deviceForce.BytesAvailable
% fwrite(G.deviceForce,"battery ?\r\n")
% G.deviceForce.BytesAvailable
% fwrite(G.deviceForce,"elec 1 *pads_qty 16\r\n");
% G.Elec(1).Name = "testname2";
% G.Elec(1).Amp = 5;
% fwrite(G.deviceForce,strcat("freq ",num2str(35)));
% [G.Elec(1).Cmd,success] = gen_FES_command([2],[8,4,6],[G.Elec(1).Amp,G.Elec(1).Amp,G.Elec(1).Amp],[300,300,300],G.Elec(1).Name); %[electrode], [mA], [pulse width]
% fwrite(G.deviceForce,G.Elec(1).Cmd);
% fwrite(G.deviceForce,strcat("stim ",G.Elec(1).Name,"\r\n"));%start continous stimulation
% G.deviceForce.BytesAvailable
% serialportlist("available")
if exist('G')==1
    if (isfield(G,'deviceFES')==1)
        delete(G.deviceFES)
    end
end

if G.deviceFES_findmode==1
    [status,cmdout] =system('listComPorts.exe');
    cmdouts=split(cmdout,'COM');
    for i=1:length(cmdouts)
        %         porttemp=cell2mat(extractBetween(cmdouts(i),'COM','0012F306B122'));
        if contains(cmdouts(i),'0016A474BDB5')==1
            temp1=cell2mat(cmdouts(i));
            G.deviceForce_com=sprintf('COM%d',str2num(temp1(1:2)));
        end
    end
else
    G.deviceFES_com=findport(G.deviceFES_ID, G.deviceFES_Name, G.deviceFES_findmode);
end

G.deviceFES = serialport(G.deviceFES_com,115200);
% % % % % device = serialport("COM7",57600,"Timeout",5);
% % % % % data = read(device,16,"uint32");
% G.deviceFES = Bluetooth("GF-Box-3 (SN13)",1);
% fopen(G.deviceFES);
handles.Indicator(2,1).BackgroundColor='g';
% drawnow;
configureTerminator(G.deviceFES,"CR/LF");
writeline(G.deviceFES,"iam DESKTOP")
G.deviceFES.NumBytesAvailable
data = readline(G.deviceFES)
writeline(G.deviceFES,"battery ? ")
readline(G.deviceFES)
G.deviceFES.NumBytesAvailable
writeline(G.deviceFES,"elec 1 *pads_qty 16");
readline(G.deviceFES)
G.Elec(1).Name = "hkijuy";
G.Elec(1).Amp = 4;
writeline(G.deviceFES,strcat("freq ",num2str(35)));
readline(G.deviceFES)
[G.Elec(1).Cmd,success] = gen_FES_command(2,[4,6],[G.Elec(1).Amp,G.Elec(1).Amp,G.Elec(1).Amp],[300,300,300],G.Elec(1).Name,11); %[electrode], [mA], [pulse width]
if success==1
    writeline(G.deviceFES,G.Elec(1).Cmd);
    % readline(G.deviceFES)
    kk=1;
    % while(kk<5)
    pause(2);
    writeline(G.deviceFES,strcat("stim ",G.Elec(1).Name));%start continous stimulation
    fprintf('on\n');
    % writeline(G.deviceFES,"stim testname20");%start continous stimulation
    % readline(G.deviceFES)
    pause(10);
    writeline(G.deviceFES,"stim off");
    fprintf('off\n');
    % kk=kk+1;
    % end
    % readline(G.deviceFES)
    G.deviceFES.NumBytesAvailable
    % readline(G.deviceFES)
end
% handles.mitem(3,1).Enable='on';
handles.Report(2,2).String=sprintf('FES Device is connected successfully, you can now start the task.\n');
drawnow;
end