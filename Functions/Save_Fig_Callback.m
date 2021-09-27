%%
function Save_Fig_Callback(hObject, eventdata, handles)
fn = cd;fn = fullfile(fn, '..');
foldername_1=fullfile(cd,'\Figures\fig\');
foldername_2=fullfile(cd,'\Figures\EMF\');

save_fig(foldername_1,foldername_2)
handles.Report(1,2).String=sprintf('Figures saved successfully.\n');
drawnow;
end