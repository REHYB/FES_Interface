%%
function Terminate_Callback(hObject, eventdata, handles)
global G;

if  G.Terminate==0
    G.Terminate=1;
    handles.mitem(3,3).Enable='off';
    handles.mitem(3,4).Enable='off';
    handles.Report(1,2).String=sprintf('Task terminated:\nSelect "Reset and Start again" to start the task again.\n');
    handles.Record.B.Enable='off';
    drawnow;
    %     handles.mitem(3,2).Text='start';
end
fprintf("time=%f\n",G.t);
fprintf("Mean freq in reading data:=%f\n",128/G.BuffSizeMean);
fprintf("Data corruption =%d out of %d (%f percent)\n",G.BadDataCnt,(G.CorrectDataCnt+G.BadDataCnt),G.BadDataCnt/(G.CorrectDataCnt+G.BadDataCnt)*100);
a1=floor(G.t*128 - G.CorrectDataCnt*G.BuffSizeMean)*(floor(G.t*128 - G.CorrectDataCnt*G.BuffSizeMean)>=0);
a2=floor(G.t*128);
fprintf("Data lost =%d out of %d (%f percent)\n",a1,a2,(a1)/(a1+a2)*100);

G.velecAmpOnlineChangeInLoopFlg=1;
if G.velecAmpOnlineChangeInLoopFlg==1
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback;
else
    velecAmpOnlineChangeFun=@velecAmpOnlineChange_Callback0;
end
for i=1:16
    handles.VelecNewVal(i,4).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,5).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,10).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,11).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,12).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,13).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,14).Callback={velecAmpOnlineChangeFun,handles};
    handles.VelecNewVal(i,15).Callback={velecAmpOnlineChangeFun,handles};
end

if G.Qualisys.Flg
    write(G.Q.qtm,G.Q.qtm_h.close)
end

end

