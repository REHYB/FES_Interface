
%%
function port=findport(inp_ID,inp_Name,mode)
[err,str] = system('REG QUERY HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM');
if err
    ports = [];
else
    ports = regexp(str,'\\Device\\(?<type>[^ ]*) *REG_SZ *(?<port>COM.*?)\n','names');
    cmd = 'REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ /s /f "FriendlyName" /t "REG_SZ"';
    if exist('jsystem','file')==2 %~10x faster then 'system'
        [~,str] = jsystem(cmd,'noshell');
    else
        [~,str] = system(cmd);
    end
    names = regexp(str,'FriendlyName *REG_SZ *(?<name>.*?) \((?<port>COM.*?)\)','names');
    
    if mode==1
        n1=strfind(str,inp_ID);
    elseif mode==2
        m1=strfind(str,inp_Name);
        n1=strfind(str,str(m1-43:m1-32));
    end
    
    aa='FriendlyName    REG_SZ    Standard Serial over Bluetooth link (COM';
    n2=strfind(str,aa);
    % names = regexp(str,'_C00000000         FriendlyName *REG_SZ *(?<name>.*?) \((?<port>COM.*?)\)','names');
    for i=1:length(n1)
        for j=1:length(n2)
            if (n2(j)>n1(i) &&  n2(j)<n1(i)+30)
                port=sprintf("COM%d",str2num(str(n2(j)+length(aa))));
            end
        end
    end
    
end
end