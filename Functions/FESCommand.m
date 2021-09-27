%%
function FESCommand(VelecID,type,Value)
global G
% global handles
cmd=sprintf("velec %s *%s 1=%d,2=%d,3=%d,4=%d,5=%d,6=%d,7=%d,8=%d,9=%d,10=%d,11=%d,12=%d,13=%d,14=%d,15=%d,16=%d",VelecID,type, Value);
writeline(G.deviceFES,cmd);
% ReceiveFESData(handles);
end