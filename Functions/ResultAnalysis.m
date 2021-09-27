%%
function ResultAnalysis(folder)
global G
%    y=[1 2 1 2;1 2 1 2];
%    c=["r","g","b","k";"b","r","b","k"];
%    x=[1 1 2 2;1 1 2 2];
%    z=[1 2 3 7 ;8 1 3 2];
%    y=[2;2;2];
%    c=["r";"b";"k"];
%    x=[3;3;3];
%    z1=[0;1;5];
%    z2=[0;2;7];
address=sprintf("%s\\MaxThreshold.txt",folder);
fileID=fopen(address,'r');
temp=(fscanf(fileID,'%d,%d\n',[2 Inf]))';
% temp=(fscanf(fileID,'%d:\n%d\n',[2 Inf]))';
if G.Qualisys.Flg
    name={"non","General",G.Q.param.qtm.markerName{5:9},"Mix"};
else
    name={"non","General","Little","Ring","Middle","Index","Thumb","Mix"};
end

for i=1:16
    temp2=find(temp(:,1)==i);
    if temp2>0
        data(i)=temp(temp2,2);
    else
        data(i)=0;
    end
end

Min=[2 0 3 1 1 5 1 2 2 3 1  1  1 2  3  0]*0;
Max=data;

if G.Qualisys.Flg
    k=1;
    lll=ones(1,16);
    for i=1:16
        ll{i}=name(1);
        
        if i<=size(G.Auto.cathod,1) && G.Auto.Flg>-1
            ll{G.Auto.cathod{i}(1)}=name(G.Q.normMaxIndex(end,k)+2);
            
            r=0;
            for ii=1:5
                if G.Q.MaxdNormalized{end}{k}(ii)>0.5
                    r=r+1;
                end
            end
            if r>=1
                lll(G.Auto.cathod{i}(1))=G.Q.normMaxIndex(end,k)+2;
            elseif r>1
                lll(G.Auto.cathod{i}(1))=5+2+1;
            end
            
            t=G.Q.FirstMovementT(end,k);
            [~,index]=min(abs(G.Record.Amp.treal - t));
            Min(G.Auto.cathod{i}(1))=G.Record.Amp.a{G.Q.SaveCnt}(index,G.Auto.cathod{i}(1));
            
            k=k+1;
        end
    end
end

fclose(fileID);
c0=["w","c","r","y","g","b","m","e"]; %e: grey


x0=[4 4 1 3 3 2 2 1 4 3 2 1 4 3 2 1];
y0=[3 4 4 4 3 4 3 3 2 2 2 2 1 1 1 1];
padnumdis=-3;
for i=1:2
    for j=1:16
        x(i,j)=x0(j);
        y(i,j)=y0(j);
        
        %         if Max(j)==0
        %             Min(j)=padnumdis;
        %             Max(j)=padnumdis;
        %         end
        
        if i~=3
            if Max(j)==0
                c(i,j)=c0(1);
                leg(i,j)="non";
            else
                
                leg(i,j)="General";
                if G.Qualisys.Flg
                    c(i,j)=c0(lll(j));
                else
                    c(i,j)=c0(2);
                end
                %                 leg(i,j)=ll{j};
            end
        else
            c(i,j)=c0(3);
            leg(i,j)="Little";
        end
        
        
        z1(1,j)=padnumdis;
        z2(1,j)=padnumdis;
        
        
        if Max(j)>0
            z1(2,j)=Min(j);
            z2(2,j)=Max(j);
        else
            z1(2,j)=padnumdis;
            z2(2,j)=padnumdis;
        end
        
    end
end


f=figure;
hold on;
for i=1:8
    if strcmp(c0(i),'e')==0
        h(i)=patch([0 0 0 0],[0 0 0 0],[0 0 0 0],c0(i));
    else
        h(i)=patch([0 0 0 0],[0 0 0 0],[0 0 0 0],[0.7,0.7,0.7]);
    end
end


view(-52,32);
f.CurrentAxes.YTick=[];
f.CurrentAxes.XTick=[];

f.CurrentAxes.ZLabel.String="Amp (mA)";
scatterbar3(x,y,z1,z2,0.9,c)
% f.CurrentAxes.ZTickLabel(1)={''};

%    l=legend('g');
% for i=2:length(leg(1,:))

% a(i)=f.CurrentAxes.Children(6*16:-6:1)
%   l=legend(f.CurrentAxes.Children(6*16:-6:1),leg(1,:));
%    l=legend('Little','','','','','','Ring','','','','','','Middle','','','','','','Index','','','','','','Thuumb','','','','','');
%    l.Title.String="Finger";

l=legend(f.CurrentAxes.Children(end:-1:end-7),name);
l.Title.String="Finger";
l.Location='northeastout';
for j=1:16
    t= text(x0(j),y0(j),0.5+padnumdis,sprintf("%d",j));
    t.HorizontalAlignment='Center';
    t.FontUnits='Normalized';
    %        t.Margin=1;
    t.Rotation=-45;
end

for j=1:16
    if Max(j)>0
        t= text(x0(j),y0(j),0.5+Max(j),sprintf("%d",j));
        t.HorizontalAlignment='Center';
        t.FontUnits='Normalized';
        %        t.Margin=1;
        t.Rotation=-45;
    end
end

if G.Auto.Flg>-1 && G.Qualisys.Flg
    for j=1:size(G.Auto.cathod,1)
        vv(j,:)=[G.Auto.cathod{j}(1),limit(floor(G.Q.MaxdNormalized{end}{j}(:)'*100),0,100)];
    end
    
    ax2=axes('position',[0.75,0.15,0.25,0.4], 'Visible','off');
    
    % vv=[[1:14]',[1:14]',[1:14]',[1:14]',[1:14]',[1:14]'];
    %     T = table(vv(:,1),vv(:,2),vv(:,3),vv(:,4),vv(:,5),vv(:,6),'VariableNames',{'Pad','T','I','M','R','L'});
    T = table(vv(:,1),vv(:,2),vv(:,3),vv(:,4),vv(:,5),vv(:,6),'VariableNames',{'Pad',G.Q.param.qtm.markerName{5}(1),G.Q.param.qtm.markerName{6}(1),G.Q.param.qtm.markerName{7}(1),G.Q.param.qtm.markerName{8}(1),G.Q.param.qtm.markerName{9}(1)});
    
    writetable(T,strcat(folder,'\','Fingers_Movement_Contribution_Percent.txt'));
    
    tableCell = [T.Properties.VariableNames; table2cell(T)];
    tableCell(cellfun(@isnumeric,tableCell)) = cellfun(@num2str, tableCell(cellfun(@isnumeric,tableCell)),'UniformOutput',false);
    tableChar = splitapply(@strjoin,pad(tableCell),[1:size(G.Auto.cathod,1)+1]');
    Text=text(0,.95,tableChar,'VerticalAlignment','Top','HorizontalAlignment','Left','FontName','Consolas');
    Text.Units='normalized';
    Text.FontUnits='normalized';
    Text.FontSize=0.05;
end


f.CurrentAxes.ZLim(1)=padnumdis;
grid on;
drawnow;
saveas(gcf,strcat(folder,'\','MaxThreshold.jpg'));
saveas(gcf,strcat(folder,'\','MaxThreshold.fig'));

T2 = table([1:16]',Min','VariableNames',{'Pad','Min'});
writetable(T2,strcat(folder,'\','MinThreshold.txt'));

save(strcat(folder,'\','G.mat'),'G');

foldername_1=fullfile(folder,'\Figures\fig\');
foldername_2=fullfile(folder,'\Figures\EMF\');
save_fig(foldername_1,foldername_2)


fprintf('saved Finished');
%   t= text(1,4,1,'16');
%   t.HorizontalAlignment='Center'
%   %%
%   t.Rotation=-52;
%    colorbar
%%


% Z(:,:)=[11	11	9
% 7	13	11
% 14	17	20
% 11	13	9];
%
% figure
% a=bar3([1,3 4 6],Z,0.5,'detached'); % 'stacked' % 'detached'
%  a(1).Visible='off';

% Y = rand ( 10 , 2 )
% figure
% bar3 ( Y ) % % with dummy column
% hold on
% bar3 ( Y, 'stacked' )
end