%%
function ReceiveFESData(handles)
global G
if G.deviceFES.NumBytesAvailable>0
    mes=readline(G.deviceFES);
    handles.Report(2,2).String=sprintf('FES Device Response:\n%s\n',mes);
    drawnow;
    %     pause(1);
end
end