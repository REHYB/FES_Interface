%%
function BallandBeam(q1,q2,des)
global G
r=G.ball.radious;l=G.beam.length;

if G.firstBallandBeam==1
    G.firstBallandBeam=0;
    G.f6=figure(6);
    G.f6.Units='normalized';%G.f6.Position=[-1.1182-0.3646    0.8250    0.3646    0.4861];
    G.tt=0:0.1:2*pi+.01;
    G.xc=r*cos(G.tt);G.yc=r*sin(G.tt);
    
    %     gca(G.f6);
    %     hold off;
    
    
    XO=q1*cos(q2)-r*sin(q2);
    YO=q1*sin(q2)+r*cos(q2);
    XA=0;YA=0;
    XB=l*cos(q2);YB=l*sin(q2);
    XC=-l*cos(q2);YC=-l*sin(q2);
    
    V1x=[XA;XB];  V1y=[YA;YB];
    V2x=[XA;XC];  V2y=[YA;YC];
    
    
    G.p0=plot(-r*sin(q2)+G.xc+des*cos(q2),+r*cos(q2)+G.yc+des*sin(q2),'b--','linewidth',2);
    hold on
    G.p1=plot(XO+G.xc,YO+G.yc,'r-','linewidth',2);
    
    G.p2=plot(V1x,V1y,'b-','linewidth',1);
    
    G.p3=plot(V2x,V2y,'b-','linewidth',1);
    
    G.p4=plot(XO,YO,'kO','linewidth',2);
    
    G.p5=plot(XA,YA,'kO','linewidth',4);
    
    V3x=[XO;XO+r*sin(q1/r)];  V3y=[YO;YO+r*cos(q1/r)];
    V4x=[XO;XO+r*sin(q1/r+pi/2)];  V4y=[YO;YO+r*cos(q1/r+pi/2)];
    V5x=[XO;XO+r*sin(q1/r+pi)];  V5y=[YO;YO+r*cos(q1/r+pi)];
    V6x=[XO;XO+r*sin(q1/r+1.5*pi)];  V6y=[YO;YO+r*cos(q1/r+1.5*pi)];
    G.p6=plot(V3x,V3y,'r-','linewidth',2);
    G.p7=plot(V4x,V4y,'r-','linewidth',2);
    G.p8=plot(V5x,V5y,'r-','linewidth',2);
    G.p9=plot(V6x,V6y,'r-','linewidth',2);
else
    
    XO=q1*cos(q2)-r*sin(q2);
    YO=q1*sin(q2)+r*cos(q2);
    XA=0;YA=0;
    XB=l*cos(q2);YB=l*sin(q2);
    XC=-l*cos(q2);YC=-l*sin(q2);
    
    V1x=[XA;XB];  V1y=[YA;YB];
    V2x=[XA;XC];  V2y=[YA;YC];
    
    G.p0.XData=-r*sin(q2) + G.xc+des*cos(q2);G.p0.YData=+r*cos(q2)+G.yc+des*sin(q2);
    G.p1.XData=XO+G.xc;G.p1.YData=YO+G.yc;
    G.p2.XData=V1x;G.p2.YData=V1y;
    
    G.p3.XData=V2x;G.p3.YData=V2y;
    
    G.p4.XData=XO;G.p4.YData=YO;
    
    G.p5.XData=XA;G.p5.YData=YA;
    
    V3x=[XO;XO+r*sin(q1/r)];  V3y=[YO;YO+r*cos(q1/r)];
    V4x=[XO;XO+r*sin(q1/r+pi/2)];  V4y=[YO;YO+r*cos(q1/r+pi/2)];
    V5x=[XO;XO+r*sin(q1/r+pi)];  V5y=[YO;YO+r*cos(q1/r+pi)];
    V6x=[XO;XO+r*sin(q1/r+1.5*pi)];  V6y=[YO;YO+r*cos(q1/r+1.5*pi)];
    G.p6.XData=V3x;G.p6.YData=V3y;
    G.p7.XData=V4x;G.p7.YData=V4y;
    G.p8.XData=V5x;G.p8.YData=V5y;
    G.p9.XData=V6x;G.p9.YData=V6y;
end
axis(G.f6.CurrentAxes,'equal');
G.f6.CurrentAxes.XLim=[-5 5];
G.f6.CurrentAxes.YLim=[-2 2];
% axis equal
% axis([-5 5 -2 2])
%         str=['Time = ',num2str(t)];
%     text(-1,-.5,str,'fontsize',18,'fontweight','bold');
% hold off
%         pause(0.01)


end