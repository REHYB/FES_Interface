%%
function save_fig(foldername_1,foldername_2)

foledrexist=exist(foldername_1,'dir');
if foledrexist~=7
    mkdir(foldername_1);
end

foledrexist=exist(foldername_2,'dir');
if foledrexist~=7
    mkdir(foldername_2);
end


FigList=findobj(allchild(0),'flat','Type','figure');
k=0;
for iFig=1:length(FigList)
    FigHandle=FigList(iFig);
    FigName=get(FigHandle,'Name');
    if isempty(FigName)
        k=k+1;
        FigName=sprintf('WithOutName_%d',k);
    end
    if get(FigHandle,'Number')~=100
        saveas(FigHandle,strcat(foldername_1,FigName,'.fig'));
        saveas(FigHandle,strcat(foldername_2,FigName,'.emf'));
    end
end
end