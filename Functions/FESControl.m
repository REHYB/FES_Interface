%%
function FESControl(ControlAmp)
global G

if ~isequal(ControlAmp, G.ControlAmpOld)
    FESCommand(G.Control.VElec.ID,'amp',ControlAmp);
end
G.ControlAmpOld=ControlAmp;
G.ActPanel.Amp=ControlAmp;
G.fff=1;
end