%%
function Read_All_Saved_Velec(hObject, eventdata, handles)
global G
listing = dir("SavedConfiguration");
k=0;
G.Load.DefNo=0;
for i=1:length(listing)
    if listing(i).bytes>0 && strcmp(listing(i).name(end-3:end),'.txt')
        k=k+1;
        G.Load.Elec(k).FileName= listing(i).name;
        text = fileread(sprintf("SavedConfiguration\\%s",G.Load.Elec(k).FileName));
        
        %     index=find(strfind(text,"*")>strfind(text,"*name")+5);
        G.Load.Elec(k).Name= erase(text(strfind(text,"*name")+5:strfind(text,"*elec")-1),' ');
        if strcmp(G.Load.Elec(k).Name,'SKTest_Default')
            G.Load.DefNo=k;
        end
        G.Load.Elec(k).ID  = erase(text(strfind(text,"velec ")+6:strfind(text,"*name")-1),' ');
        G.Load.Elec(k).Freq = str2num(erase(text(strfind(text,"Freq:")+5:strfind(text,"velec")-2),' '));
        G.Load.Elec(k).Note = convertCharsToStrings(erase(text(strfind(text,"Note:")+7:end),'?'));
        G.Load.Elec(k).StimFeasure = erase(text(strfind(text,"Stim Feasure:")+13:strfind(text,"Freq:")-1),' ');
        
        tempcathode  = split(erase(text(strfind(text,"*cathodes")+9:strfind(text,"*amp")-1),' '),',');
        tempamp      = split(erase(text(strfind(text,"*amp")+4:strfind(text,"*width")-1),' '),',');
        tempwidth    = split(erase(text(strfind(text,"*width")+6:strfind(text,"*anode")-1),' '),',');
        tempanode    = split(erase(text(strfind(text,"*anode")+6:strfind(text,"*selected")-1),' '),',');
        tempanode2=de2bi(2^16+str2num(char(tempanode)))';
        for j=1:16
            tempcathode2=char(tempcathode(j));
            tempamp2=char(tempamp(j));
            tempwidth2=char(tempwidth(j));
            
            
            G.Load.Elec(k).SelectedcathodeBinary(j,1)=str2num(erase(tempcathode2(strfind(tempcathode2,"=")+1:end),' '));
            G.Load.Elec(k).Amp(j,1)=str2num(erase(tempamp2(strfind(tempamp2,"=")+1:end),' '));
            G.Load.Elec(k).Width(j,1)=str2num(erase(tempwidth2(strfind(tempwidth2,"=")+1:end),' '));
            
            G.Load.Elec(k).SelectedanodeBinary(j,1)=tempanode2(j);
        end
    end
end

G.Load.No=k;
s{1}='New';
for i=1:G.Load.No
    s{i+1}=G.Load.Elec(i).FileName(1:end-4);
    if G.AutoRun.GeneralInit.flg
        if strcmp(G.Load.Elec(i).FileName(1:end-4),G.AutoRun.selectedVelecstr)
            G.AutoRun.select=i+1;
        end
    end
end
handles.VelecNew(5,2).String=s;

end

