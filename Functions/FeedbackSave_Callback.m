
%%
function FeedbackSave_Callback(hObject, eventdata, handles)
global G

feedbackname=(handles.Feedback(length(G.Fingers)+1,1).String);
G.Feedback.No=str2num(handles.Feedback(length(G.Fingers)+1,2).String);

dirtemp=sprintf("SavedConfiguration\\Feedback\\%s",feedbackname);

if exist(dirtemp,'dir')~=7
    mkdir(dirtemp);
end

name=handles.VelecNew(1,2).String;
id=handles.VelecNew(2,2).String;
frequency = handles.VelecNew(3,2).String;
note=handles.VelecNew(6,2).String;
stimFeature=str2num(handles.VelecNew(4,10).String);

for i=1:length(G.Fingers)
    feedback(i)=handles.Feedback(i,3).Value;
end

k=0;
k2=0;

for i=1:16
    if handles.VelecNewVal(i,2).Value==2 && ~isempty(handles.VelecNewVal(i,4).String) && ~isempty(handles.VelecNewVal(i,7).String) && ...
            ~isempty(frequency) && ~isempty(name) && ~isempty(id)
        k=k+1;
        cathode(k)= G.Elecorder(i);
        amp(k)   = str2num(handles.VelecNewVal(i,4).String);
        width(k) = str2num(handles.VelecNewVal(i,7).String);
    end
    if handles.VelecNewVal(i,2).Value==3 && ~isempty(frequency) && ~isempty(name) && ~isempty(id)
        k2=k2+1;
        anode(k2)= G.Elecorder(i);
    end
end
if ~(k==0 || k2==0)
    Name  = convertCharsToStrings(name);
    ID    = convertCharsToStrings(id);
    Selectedcathode = cathode;
    Selectedanode = anode;
    Amp   = amp;
    Width = width;
    Freq=frequency;
    Note=note;
    
    AmpUpdate=zeros(1,16);
    WidthUpdate=zeros(1,16);
    for i=1:length(Selectedcathode)
        AmpUpdate(Selectedcathode(i))=Amp(i);
        WidthUpdate(Selectedcathode(i))=Width(i);
    end
    
    [Cmd,success] = gen_FES_command(Selectedanode,Selectedcathode,Amp,Width,Name,ID); %[electrode], [mA], [pulse width]
    if success==1
        
        
        % Save Velec in text file for future use
        date=datetime('now');
        text{1}=datestr(date);
        text{2}=sprintf('Control Gain: %f, %f, %f',G.Control.Gain.Proportional,G.Control.Gain.Integral, G.Control.Gain.Derivative);
        %         text{3}=sprintf('Stim Feasure: %f, %f, %f, %f',G.Timeamp,G.Timeoutamp, G.MaxAmp, G.Auto.timedelay);
        text{3}=sprintf('Stim Feasure: %f, %f, %f',stimFeature);
        text{4}=sprintf('Freq: %s',Freq);
        text{5}=sprintf('%s',Cmd);
        text{6}=sprintf('\nNote:');
        for i=1:size(Note,1)
            text{6+i}=sprintf('%s',Note(i,:));
        end
        
        text{6+i}=sprintf('\nFeedback:');
        
        text{6+i+1}=sprintf('%d',feedback);
        
        text{6+i+2}=sprintf('\nFeedback Interpretation:');
        for ii=1:length(G.Fingers)
            text{6+i+2+ii}=sprintf('%10s: %10s',G.Fingers(ii),G.sensing(feedback(ii)+1));
        end
        
        
        
        file_velec = fopen(sprintf("%s\\%d.txt",dirtemp,G.Feedback.No),'wt');
        %         dirtemp=sprintf("SavedConfiguration\\%s",f_n)
        %         mkdir(dirtemp)
        for i=1:length(text)
            fprintf(file_velec,text{i});
            fprintf(file_velec,'\n');
        end
        fclose(file_velec);
        
    end
end

%
% f_n=sprintf("%s (%s)",G.Elec(no).Name,datestr(date,30));
% file_velec = fopen(sprintf("SavedConfiguration\\%s.txt",f_n),'wt');

G.Feedback.No=G.Feedback.No+1;
handles.Feedback(length(G.Fingers)+1,2).String=G.Feedback.No;

end