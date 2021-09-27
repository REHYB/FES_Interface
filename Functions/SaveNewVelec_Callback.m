%%
function SaveNewVelec_Callback(hObject, eventdata, handles)
global G

no=length(handles.VelecPopup.String);
name=handles.VelecNew(1,2).String;
ID=handles.VelecNew(2,2).String;
frequency = handles.VelecNew(3,2).String;
note=handles.VelecNew(6,2).String;
stimFeature=str2num(handles.VelecNew(4,10).String);
k=0;
k2=0;
for i=1:16
    if handles.VelecNewVal(i,2).Value==2 && ~isempty(handles.VelecNewVal(i,4).String) && ~isempty(handles.VelecNewVal(i,7).String) && ...
            ~isempty(frequency) && ~isempty(name) && ~isempty(ID)
        k=k+1;
        cathode(k)= G.Elecorder(i);
        amp(k)   = str2num(handles.VelecNewVal(i,4).String);
        width(k) = str2num(handles.VelecNewVal(i,7).String);
    end
    if handles.VelecNewVal(i,2).Value==3 && ~isempty(frequency) && ~isempty(name) && ~isempty(ID)
        k2=k2+1;
        anode(k2)= G.Elecorder(i);
    end
end
if k==0 || k2==0
    handles.VelecNew(4,4).String='Try again';
    handles.VelecNew(4,4).ForegroundColor='r';
else
    handles.VelecPopup.String(no+1)={name};
    G.VelecPopup.Name(no+1)={str2mat(strcat(name,' (ID: ',ID,')'))};
    G.Elec(no).Name  = convertCharsToStrings(name);
    G.Elec(no).ID    = convertCharsToStrings(ID);
    G.Elec(no).Selectedcathode = cathode;
    G.Elec(no).Selectedanode = anode;
    G.Elec(no).Amp   = amp;
    G.Elec(no).Width = width;
    G.Elec(no).Freq=frequency;
    G.Elec(no).Note=note;
    
    G.Elec(no).AmpUpdate=zeros(1,16);
    G.Elec(no).WidthUpdate=zeros(1,16);
    for i=1:length(G.Elec(no).Selectedcathode)
        G.Elec(no).AmpUpdate(G.Elec(no).Selectedcathode(i))=G.Elec(no).Amp(i);
        G.Elec(no).WidthUpdate(G.Elec(no).Selectedcathode(i))=G.Elec(no).Width(i);
    end
    
    [G.Elec(no).Cmd,success] = gen_FES_command(G.Elec(no).Selectedanode,G.Elec(no).Selectedcathode,G.Elec(no).Amp,G.Elec(no).Width,G.Elec(no).Name,G.Elec(no).ID); %[electrode], [mA], [pulse width]
    if success==1
        %     writeline(G.deviceFES,strcat("freq ",frequency));
        %     ReceiveFESData(handles);
        
        writeline(G.deviceFES,G.Elec(no).Cmd);
        ReceiveFESData(handles);
        
        handles.VelecNew(4,4).String='Velec Saved Successful';
        handles.VelecNew(4,4).ForegroundColor='g';
%         handles.VelecNew(4,6).Enable='on';
        %                 handles.VelecNew(4,7).Enable='on';
        %         handles.VelecNew(4,9).Enable='on';
        
        % Save Velec in text file for future use
        date=datetime('now');
        text{1}=datestr(date);
        text{2}=sprintf('Control Gain: %f, %f, %f',G.Control.Gain.Proportional,G.Control.Gain.Integral, G.Control.Gain.Derivative);
        %         text{3}=sprintf('Stim Feasure: %f, %f, %f',G.Timeamp,G.Timeoutamp, G.MaxAmp);
        text{3}=sprintf('Stim Feasure: %f, %f, %f',stimFeature);
        text{4}=sprintf('Freq: %s',G.Elec(no).Freq);
        text{5}=sprintf('%s',G.Elec(no).Cmd);
        text{6}=sprintf('\nNote:');
        for i=1:size(G.Elec(no).Note,1)
            text{6+i}=sprintf('%s',G.Elec(no).Note(i,:));
        end
        
        f_n=sprintf("%s (%s)",G.Elec(no).Name,datestr(date,30));
        file_velec = fopen(sprintf("SavedConfiguration\\%s.txt",f_n),'wt');
        %         dirtemp=sprintf("SavedConfiguration\\%s",f_n)
        %         mkdir(dirtemp)
        for i=1:length(text)
            fprintf(file_velec,text{i});
            %             if i<=6
            fprintf(file_velec,'\n');
            %             end
        end
        fclose(file_velec);
        
        Read_All_Saved_Velec(hObject, eventdata, handles);
        
        if handles.VelecNew(4,2).Value== 0
            handles.VelecDef.Value=0;
            handles.f2.Visible='off';
        end
    else
        handles.VelecNew(4,4).String='Try again';
        handles.VelecNew(4,4).ForegroundColor='r';
    end
    
end
end