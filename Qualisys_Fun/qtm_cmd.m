function h = qtm_cmd(cmd)
s = uint8(cmd);
h = [uint8([0,0,0,length(cmd)+8,0,0,0,1]),s];
