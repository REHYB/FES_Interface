%%
function RecordB_Callback(hObject, eventdata, handles)
global G
if handles.Record.B.Value
    G.Record.filename=handles.Record.T.String;
    
    handles.Record.QCalibration.Enable='on';
    
    G.Record.tStart=G.t;
    G.Record.Amp.ts=G.realtimev(1);
    G.Record.GF.ts=G.c(1);
    
    if G.Qualisys.Flg
        G.Q.start = 1;
        G.Q.Cnt   = 1;
        G.Q.Cnt2  = 1;
    end
    
    G.CurrentlyActive=0;
    G.CurrentlyDeactive=0;
    G.Q.SaveCnt=G.Q.SaveCnt+1;
    
    date=datetime('now');
    name=sprintf("%s_%s",G.Record.filename,datestr(date,30));
    G.Record.dirtemp=sprintf("SelectiveRegion\\%s",name);
    
    if exist(G.Record.dirtemp,'dir')~=7
        mkdir(G.Record.dirtemp);
    end
    
    if G.velecAmpOnlineChangeInLoopFlg
        G.Record.fileIsOpen(1)=1;
        G.Record.filename1 = fopen(sprintf("%s\\Amp.txt",G.Record.dirtemp),'wt');
        
        G.Record.fileIsOpen(2)=1;
        G.Record.filename2 = fopen(sprintf("%s\\MaxThreshold.txt",G.Record.dirtemp),'wt');
    end
    
    if G.Record.GF.ts>0
        G.Record.fileIsOpen(3)=1;
        G.Record.filename3 = fopen(sprintf("%s\\Force.txt",G.Record.dirtemp),'wt');
    end
    
    
    handles.Record.B.String='Stop and Save';
    
else
    handles.Record.B.String='Please wait ...';
    handles.Record.QCalibration.Enable='off';
    drawnow;
    
    
    if G.Qualisys.Flg
        G.Q.start=0;
        %         l={'L','R','M','I','T'};
        l=G.Q.param.qtm.markerName;
        for i=size(G.saved.X,2)%i=1:size(G.saved.X,2)
            figure(2000+i);
            x=G.saved.X{i}-G.saved.X{i}(1,:);
            y=G.saved.Y{i}-G.saved.Y{i}(1,:);
            z=G.saved.Z{i}-G.saved.Z{i}(1,:);
            t=G.saved.t{i}-G.saved.t{i}(1);
            d=sqrt(x.^2+y.^2+z.^2);
            s=size(d,1);
            Normdv=zeros(s,5);
            Normd=zeros(1,5);
            for j=1:5
                Normd(j)=norm(d(5:9,j));
                Normdv(:,j)=norm(d(5:9,j));
            end
            
            subplot(2,3,1);plot(t,x);legend(l);
            subplot(2,3,2);plot(t,y);legend(l);
            subplot(2,3,3);plot(t,z);legend(l);
            subplot(2,3,4);plot(t,d);legend(l);
            subplot(2,3,5);plot(t,Normdv);legend(l(5:9));
            subplot(2,3,6);plot(t,Normdv/max(Normd));legend(l(5:9));
            clear x y z d Normd Normdv;
        end
        
        if (isfield(G,'saved2')==1)
            for i=size(G.saved2.X,2)%i=1:size(G.saved2.X,2)
                %                 %% calibration
                %                 if G.Q.calibrationCnt>0
                %                     for ii=1:9
                %                         V0{i}{ii}=[  G.savedcalibration.X{end}{end}(:,ii), G.savedcalibration.Y{end}{end}(:,ii), G.savedcalibration.Z{end}{end}(:,ii)    ];
                %                     end
                %                     R=eye(3,3);
                %                     t=zeros(3,1);
                %                     A=[V0{i}{1}(1,:)',V0{i}{2}(1,:)',V0{i}{3}(1,:)',V0{i}{4}(1,:)'];
                %                     for k=1:length(V0{i}{1})
                %                         B=[V0{i}{1}(k,:)',V0{i}{2}(k,:)',V0{i}{3}(k,:)',V0{i}{4}(k,:)'];
                %                         if norm(A)~=Inf && norm(B)~=Inf
                %                             [R,t]=rigid_transform_3D(A,B);
                %                         else
                %
                %                         end
                %                         clear B
                %                         for m=5:9
                %                             C2=[V0{i}{m}(k,:)'-V0{i}{4}(k,:)'];
                %                             C22=R'*C2;
                %
                %                             G.saved2RelativeC.X{i}(k,m-4)=C22(1);
                %                             G.saved2RelativeC.Y{i}(k,m-4)=C22(2);
                %                             G.saved2RelativeC.Z{i}(k,m-4)=C22(3);
                %                             clear C2 C22
                %                         end
                %                     end
                %                     clear A
                %                     %
                %
                %                     x=G.saved2RelativeC.X{i}-G.saved2RelativeC.X{i}(1,:);
                %                     y=G.saved2RelativeC.Y{i}-G.saved2RelativeC.Y{i}(1,:);
                %                     z=G.saved2RelativeC.Z{i}-G.saved2RelativeC.Z{i}(1,:);
                %
                %                     d=sqrt(x.^2+y.^2+z.^2);
                %
                %                     for k=1:5
                %                         G.Q.Maxd0(1,k)=max(d(:,k));
                %                     end
                %                     clear x y z d
                %                     G.Q.Maxd0
                %                 end
                %%
                for j=1:size(G.saved2.X{i},2)
                    f=figure(3000+(i-1)*size(G.saved2.X{i},2) + j);fignameelec=sprintf('_%d',G.Auto.cathod{j});
                    f.Name=sprintf('Record_%d_Electrod%s',i,fignameelec);
                    
                    % x1=nonzeros(G.saved2.X{i}{j});
                    % y1=nonzeros(G.saved2.Y{i}{j});
                    % z1=nonzeros(G.saved2.Z{i}{j});
                    % x=x1-x1(1,:);
                    % y=y1-y1(1,:);
                    % z=z1-z1(1,:);
                    
                    for ii=1:9
                        V{i}{j}{ii}=[  G.saved3.X{i}{j}(:,ii),G.saved3.Y{i}{j}(:,ii),G.saved3.Z{i}{j}(:,ii)    ];
                    end
                    
                    %                     G.saved2Relative.X{i}{j}(1,:)=G.saved2.X{i}{j}(1,5:9)-G.saved2.X{i}{j}(1,4);
                    %                     G.saved2Relative.Y{i}{j}(1,:)=G.saved2.Y{i}{j}(1,5:9)-G.saved2.Y{i}{j}(1,4);
                    %                     G.saved2Relative.Z{i}{j}(1,:)=G.saved2.Z{i}{j}(1,5:9)-G.saved2.Z{i}{j}(1,4);
                    
                    R=eye(3,3);
                    t=zeros(3,1);
                    A=[V{i}{j}{1}(1,:)',V{i}{j}{2}(1,:)',V{i}{j}{3}(1,:)',V{i}{j}{4}(1,:)'];
                    for k=1:length(V{i}{j}{1})
                        %                         A=[V{i}{j}{1}(k,:)',V{i}{j}{2}(k,:)',V{i}{j}{3}(k,:)',V{i}{j}{4}(k,:)'];
                        %                         B=[V{i}{j}{1}(k+1,:)',V{i}{j}{2}(k+1,:)',V{i}{j}{3}(k+1,:)',V{i}{j}{4}(k+1,:)'];
                        B=[V{i}{j}{1}(k,:)',V{i}{j}{2}(k,:)',V{i}{j}{3}(k,:)',V{i}{j}{4}(k,:)'];
                        kk=0;
                        if norm(A)~=Inf && norm(B)~=Inf
                            kk=k+1;
                            [R,t]=rigid_transform_3D(A,B);
                        else
                            
                        end
                        clear B
                        for m=5:9
                            %                                 C1=[V{i}{j}{m}(k,:)'-V{i}{j}{4}(k,:)'];
                            C2=[V{i}{j}{m}(k,:)'-V{i}{j}{4}(k,:)'];
                            C22=R'*C2;
                            
                            G.saved2Relative.X{i}{j}(k,m-4)=C22(1);
                            G.saved2Relative.Y{i}{j}(k,m-4)=C22(2);
                            G.saved2Relative.Z{i}{j}(k,m-4)=C22(3);
                            clear c1 c2 c22
                        end
                    end
                    %
                    
                    x=G.saved2Relative.X{i}{j}-G.saved2Relative.X{i}{j}(1,:);
                    y=G.saved2Relative.Y{i}{j}-G.saved2Relative.Y{i}{j}(1,:);
                    z=G.saved2Relative.Z{i}{j}-G.saved2Relative.Z{i}{j}(1,:);
                    
                    t=G.saved2.t{i}{j}-G.saved2.t{i}{j}(1);
                    d=sqrt(x.^2+y.^2+z.^2);
                    s=size(d,1);
                    Normdv = zeros(s,5);
                    Normd  = zeros(1,5);
                    Maxd   = zeros(1,5);
                    for k=1:5
                        Normd(1,k)=norm(d(:,k));
                        Maxd(1,k)=max(d(:,k));
                        Normdv(:,k)=norm(d(:,k));
                        G.Q.MaxdNormalized{i}{j}(1,k)=Maxd(1,k)/G.Q.Maxd0(end,k);
                    end
                    %                     G.Q.MaxdNormalized{i}{j}
                    %                     [max0,G.Q.normMaxIndex(i,j)]=max(Normd);
                    [max0,G.Q.normMaxIndex(i,j)]=max(G.Q.MaxdNormalized{i}{j});
                    for n=1:length(t)
                        G.Q.FirstMovementT(i,j)=0;
                        G.Q.FirstMovementnorm(i,j)=0;
                        %                         if d(n,G.Q.normMaxIndex(i,j)) >= Maxd(1,G.Q.normMaxIndex(i,j))*0.2
                        if d(n,G.Q.normMaxIndex(i,j)) >= G.Q.Maxd0(end,G.Q.normMaxIndex(i,j))*0.2
                            G.Q.FirstMovementT(i,j)=G.saved2.t{i}{j}(n);
                            G.Q.FirstMovementnorm(i,j)=d(n,G.Q.normMaxIndex(i,j));
                            break;
                        end
                    end
                    subplot(2,3,1);plot(t,x(:,:));legend(l(:,5:9));
                    subplot(2,3,2);plot(t,y(:,:));legend(l(:,5:9));
                    subplot(2,3,3);plot(t,z(:,:));legend(l(:,5:9));
                    subplot(2,3,4);plot(t,d(:,:));legend(l(:,5:9));
                    subplot(2,3,5);plot(t,Normdv);legend(l(:,5:9));
                    subplot(2,3,6);plot(t,Normdv/max(Normd));legend(l(:,5:9));
                    clear x y z d Normd Normdv;
                    clear x1 y1 z1;
                    
                end
            end
        end
        
    end
    
    if G.Record.fileIsOpen(1)==1
        G.Record.Amp.treal=G.t_r(G.Record.Amp.ts:G.realtimev(end));
        G.Record.Amp.t=G.t_r(G.Record.Amp.ts:G.realtimev(end)) - G.t_r(G.Record.Amp.ts);
        for j=1:16
            G.Record.Amp.a{G.Q.SaveCnt}(:,j)=G.AmpHistory(G.Record.Amp.ts:G.realtimev(end),j);
        end
        for j=1:length(G.Record.Amp.t)
            fprintf(G.Record.filename1,sprintf("%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n",G.Record.Amp.t(j),G.Record.Amp.a{G.Q.SaveCnt}(j,:)));
        end
        fclose(G.Record.filename1);
        G.Record.fileIsOpen(1)=0;
    end
    
    if G.Record.fileIsOpen(2)==1
        for j=1:(size(G.Auto.cathod,1))
            temp=sprintf('%d,',G.Auto.cathod{j});
            temp=temp(1:end-1);
            %             fprintf(G.Record.filename2,sprintf("%s:\n%d\n\n",temp, G.Auto.MaxThreshold(j)));
            fprintf(G.Record.filename2,sprintf("%d,%d\n",G.Auto.cathod{j}(1), G.Auto.MaxThreshold(j)));
        end
        fclose(G.Record.filename2);
        ResultAnalysis(G.Record.dirtemp)
    end
    
    if G.Record.fileIsOpen(3)==1
        Record.GF.t=G.t_r(G.Record.GF.ts:G.c(end))' - G.t_r(G.Record.GF.ts)';
        Record.GF.f=((G.data(G.Record.GF.ts:G.c(end),1) + G.data(G.Record.GF.ts:G.c(end),2))/2.0)';
        for j=1:length(Record.GF.t)
            fprintf(G.Record.filename3,sprintf("%f,%f\n",Record.GF.t(j), Record.GF.f(j)));
        end
        fclose(G.Record.filename3);
        G.Record.fileIsOpen(2)=0;
    end
    
    
    
    handles.Record.B.String='Start Recording Data';
end

end