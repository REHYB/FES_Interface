

%% Visualization
function ShowData(t,A,g,Angle,handles)
global G
if (t<G.tCalibration || ~isfield(G,'deviceForce'))
    handles.Report(1,1).String=sprintf('Time (sec) = %.3f\nphi    (deg) = %.3f\ntheta (deg) = %.3f\n',t,Angle.phi/pi*180,Angle.theta/pi*180);
else
    handles.Report(1,1).String=sprintf('Time (sec) = %.3f\nphi    (deg) = %.3f\ntheta (deg) = %.3f\n|a|  (m/s/s) = %.3f\n',t,Angle.phi/pi*180,Angle.theta/pi*180,A.b.abs*g);
end
end