
%%
function SKGame_config_Callback(hObject, eventdata, handles)
global G

G.SKGame.Name = handles.SKGame(1,2).String;
G.SKGame.Max = str2num(handles.SKGame(2,2).String);
G.SKGame.Min = str2num(handles.SKGame(3,2).String);
G.SKGame.No = str2num(handles.SKGame(4,2).String);
G.SKGame.Restv(1) = str2num(handles.SKGame(5,2).String);
G.SKGame.Duration = str2num(handles.SKGame(6,2).String);
G.SKGame.Restv(2:3) = str2num(cell2mat(split(handles.SKGame(7,2).String,'+')));

G.SKGame.Rest=sum(G.SKGame.Restv);

G.SKGame.PMax= str2num(handles.SKGame(8,2).String);
G.SKGame.PMin= str2num(handles.SKGame(9,2).String);

G.SKGame.RScale= str2num(handles.SKGame(10,2).String)*30;

G.SKGame_BasedOnTimeFlg=floor(str2num(handles.SKGame(11,2).String));
G.SKGame.r=(G.SKGame.Max-G.SKGame.Min)/2;
G.SKGame.x = G.SKGame.r*cos(G.SKGame.t);
G.SKGame.y = G.SKGame.r*sin(G.SKGame.t);

G.SKGame.rgbtext=split((handles.SKGame(12,2).String),',');
if strcmp(G.SKGame.rgbtext(1),'lb')
    G.SKGame.rgb1=[ 0.5843 0.8157 0.9882];
else
    G.SKGame.rgb1=str2mat(G.SKGame.rgbtext(1));
end
if strcmp(G.SKGame.rgbtext(1),'lb')
    G.SKGame.rgb2=[ 0.5843 0.8157 0.9882];
else
    G.SKGame.rgb2=str2mat(G.SKGame.rgbtext(2));
end
if strcmp(G.SKGame.rgbtext(1),'lb')
    G.SKGame.rgb3=[ 0.5843 0.8157 0.9882];
else
    G.SKGame.rgb3=str2mat(G.SKGame.rgbtext(3));
end
if strcmp(G.SKGame.rgbtext(1),'lb')
    G.SKGame.rgb4=[ 0.5843 0.8157 0.9882];
else
    G.SKGame.rgb4=str2mat(G.SKGame.rgbtext(4));
end

for i=1:2
    G.SKGame.ax(i).XLim=[0 G.SKGame.PMax];
    %     G.SKGame.ax.XTick=[];
    G.SKGame.ax(i).YLim=[G.SKGame.PMin G.SKGame.PMax];
    G.SKGame.Plot1(i).XData=[0;G.SKGame.PMax;G.SKGame.PMax;0;0]';
    G.SKGame.Plot1(i).YData=[G.SKGame.Min;G.SKGame.Min;G.SKGame.Max;G.SKGame.Max;G.SKGame.Min]';
    
    if G.SKGame.PlotTextFlg==1
        G.SKGame.Plot3_text(i).Position(1)=0.5*G.SKGame.PMax;
        G.SKGame.Plot3_text(i).Position(2)=4*G.SKGame.r;
    end
    %     G.SKGame.Plot3.XData=0.5*G.SKGame.PMax;
    %     G.SKGame.Plot3.YData=4*G.SKGame.r;
    
    G.SKGame.Plot2(i).XData=0.5*G.SKGame.PMax;
    G.SKGame.Plot2(i).YData=0;
    
    G.SKGame.Plot3(i).XData=0.5*G.SKGame.PMax;
    G.SKGame.Plot3(i).YData=4*G.SKGame.r;
    
    G.SKGame.Plot2(i).MarkerSize=handles.f10(i).Position(3)*G.SKGame.RScale;
    G.SKGame.Plot3(i).MarkerSize=G.SKGame.Plot2(i).MarkerSize;
    
    if G.SKGame_BasedOnTimeFlg~=3
        G.SKGame.Plot3(i).Visible='off';
    else
        G.SKGame.Plot3(i).Visible='on';
    end
    
    G.SKGame.TextCnt(i).String=sprintf("0/%d",G.SKGame.No);
    G.SKGame.Plot1(i).FaceColor=[ 0.5843 0.8157 0.9882];
    
    if G.SKGame.HintTextFlg==1
        G.SKGame.HintText(i).String=str2mat(G.SKGame.rgbtext(5));
    end
    
end



end