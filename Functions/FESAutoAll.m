%%
function FESAutoAll(ActiveNo0,type,inp3,inp4,handles,mode)
for i=1:length(ActiveNo0)
    FESAuto(ActiveNo0(i),type,inp3,inp4,handles,mode);
end
end