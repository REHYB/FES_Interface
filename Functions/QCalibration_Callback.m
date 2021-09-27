%%
function QCalibration_Callback(hObject, eventdata, handles)
global G
if handles.Record.QCalibration.Value
    handles.Record.QCalibration.String='Stop';
    G.Q.calibration=1;
    G.Q.Cnt3=1;
    G.Q.calibrationCnt=G.Q.calibrationCnt+1;
else
    G.Q.calibration=0;
    handles.Record.QCalibration.String='GraspCalibration';
    %% calibration
    i=G.Q.calibrationCnt;
    if G.Q.calibrationCnt>0
        for ii=1:9
            V0{i}{ii}=[  G.savedcalibration.X{end}{end}(:,ii), G.savedcalibration.Y{end}{end}(:,ii), G.savedcalibration.Z{end}{end}(:,ii)    ];
        end
        R=eye(3,3);
        t=zeros(3,1);
        A=[V0{i}{1}(1,:)',V0{i}{2}(1,:)',V0{i}{3}(1,:)',V0{i}{4}(1,:)'];
        for k=1:length(V0{i}{1})
            B=[V0{i}{1}(k,:)',V0{i}{2}(k,:)',V0{i}{3}(k,:)',V0{i}{4}(k,:)'];
            if norm(A)~=Inf && norm(B)~=Inf
                [R,t]=rigid_transform_3D(A,B);
            else
                
            end
            clear B
            for m=5:9
                C2=[V0{i}{m}(k,:)'-V0{i}{4}(k,:)'];
                C22=R'*C2;
                
                G.saved2RelativeC.X{i}(k,m-4)=C22(1);
                G.saved2RelativeC.Y{i}(k,m-4)=C22(2);
                G.saved2RelativeC.Z{i}(k,m-4)=C22(3);
                clear C2 C22
            end
        end
        clear A
        %
        
        x=G.saved2RelativeC.X{i}-G.saved2RelativeC.X{i}(1,:);
        y=G.saved2RelativeC.Y{i}-G.saved2RelativeC.Y{i}(1,:);
        z=G.saved2RelativeC.Z{i}-G.saved2RelativeC.Z{i}(1,:);
        
        d=sqrt(x.^2+y.^2+z.^2);
        
        for k=1:5
            G.Q.Maxd0(i,k)=max(d(:,k));
        end
        clear x y z d
        G.Q.Maxd0_fix=floor(G.Q.Maxd0);
        T = table([1:size(G.Q.Maxd0,1)]',G.Q.Maxd0_fix(:,1),G.Q.Maxd0_fix(:,2),G.Q.Maxd0_fix(:,3),G.Q.Maxd0_fix(:,4),G.Q.Maxd0_fix(:,5),'VariableNames',{'Calibration No.',G.Q.param.qtm.markerName{5}(1),G.Q.param.qtm.markerName{6}(1),G.Q.param.qtm.markerName{7}(1),G.Q.param.qtm.markerName{8}(1),G.Q.param.qtm.markerName{9}(1)})
        writetable(T,strcat(G.Record.dirtemp,'\','Fingers_Movement_Calibration.txt'));
        
    end
end
end
