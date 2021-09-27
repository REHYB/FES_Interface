
%% Control
function ContorlMainLoop()
global G
maxrate=5;

if G.Control.Active==1 && G.FESStimOn.Flg==1 && ~G.tempflg && ~G.ControlStartwithdelay && 0
    G.ControlStartwithdelay=1;
    G.tControlStartwithdelay=G.t+2;
end

if G.ControlStartwithdelay && G.t>=G.tControlStartwithdelay
    kp=G.Control.Gain.Proportional;
    ki=G.Control.Gain.Integral;
    kd=G.Control.Gain.Derivative;
    
    
    if G.control.FirstTime==1
        G.tControlOld=G.t;
        G.control.FirstTime=0;
        G.interror=0;
        G.errorOld=0;
        G.derrorfw=10;
        G.derrorHis=zeros(1,G.derrorfw);
        G.Sensor.h=zeros(1,8);
        G.Control.t.Start=G.t;
    end
    
    G.Control.t.elapsed=G.t-G.Control.t.Start;
    
    %                         G.Force.D.V=  3 + sin(G.Control.t.elapsed);
    %                         G.Force.D.H(G.c,1)=G.Force.D.V;
    
    G.Force.D.V = G.Force.D.H(G.c(end));
    
    for ii=8:-1:2
        G.Sensor.h(ii)=G.Sensor.h(ii-1);
    end
    Sensor.d=G.GripForce;
    G.Sensor.h(1)=Sensor.d;
    Sensor.f=mean(G.Sensor.h);
    
    %                         fprintf("%f  %f  \n",Sensor.d,Sensor.f);
    
    error=G.Force.D.V-Sensor.f;
    
    
    G.interror=G.interror+(G.t-G.tControlOld)*error;
    %     G.interror=limit(G.interror,-G.MaxAmp/2/(ki+0.001),G.MaxAmp/2/(ki+0.001));
    G.interror=limit(G.interror,-G.MaxAmp/(ki+0.001),G.MaxAmp/(ki+0.001));
    
    if G.t>G.tControlOld
        derror=(error-G.errorOld)/(G.t-G.tControlOld);
    else
        derror=0;
    end
    
    for ii=G.derrorfw:-1:2
        G.derrorHis(ii)=G.derrorHis(ii-1);
    end
    G.derrorHis(1)=derror;
    
    derrorf=mean(G.derrorHis);
    
    %                         derrorOld=derror;
    
    G.errorOld=error;
    
    
    
    if Sensor.f>0.0 || 1
        %fprintf("%f  %f   %f\n",G.interror,ki*G.interror,limit(ki*G.interror,-G.MaxAmp/2,G.MaxAmp/2));
        %                             fprintf("%f  %f  %f %f\n",derror,derrorf,kd*derror,limit(kd*derror,-G.MaxAmp/3,G.MaxAmp/3));
        
        
        Cinp =  kp*error + limit(ki*G.interror,-G.MaxAmp/2*2,G.MaxAmp/2*2) + limit( kd*derror, -G.MaxAmp/3, G.MaxAmp/3);
    else
        Cinp = 0;
    end
    
    if abs(Cinp-G.CinpOld)> maxrate*(G.t-G.tControlOld)
        Cinp=G.CinpOld + maxrate*(G.t-G.tControlOld)*sign(Cinp-G.CinpOld);
    end
    G.CinpOld=Cinp;
    
    G.tControlOld=G.t;
    
    Cinp=limit(Cinp,0,G.MaxAmp);
    Cinp=floor(Cinp);
    %
    %     if G.t>15 && G.t<20
    %         Cinp=12;
    %     elseif G.t>20 && G.t<25
    %         Cinp=0;
    %     elseif G.t>25 && G.t<30
    %         Cinp=12;
    %     elseif G.t>30 && G.t<40
    %         Cinp=0;
    %     elseif G.t>40 && G.t<50
    %         Cinp=(G.t-40)/10*12;
    %     elseif G.t>50 && G.t<55
    %         Cinp=12;
    %     elseif G.t>55
    %         Cinp=0;
    %     end
    
    %     Cinpv=[]
    
    
    
    %
    G.ControlAmp=zeros(1,16);
    if (~G.stopcontrol)
        for i=1:16
            if G.Control.Cathodes.Flg(i)==1
                G.ControlAmp(i)=Cinp;
                %         handles.VelecNewVal(i,4)=inp;
            else
                G.ControlAmp(i)=0;
            end
        end
    end
    %
    
    
    FESControl(G.ControlAmp);
    %     for j=1:16
    %         G.AmpHistory(G.c,j)=Cinpv(j);
    %     end
    
    %     G.AmpHistory(G.c,1)=Cinp;
    
    
end
%temp:
if G.tempflg
    if G.FESStimOn.Flg==1
        g1=[4];
        g2=[9];
        s=14*sin(0.2*G.t);
        
        G.ControlAmp=zeros(1,16);
        if s>=0
            for i=g1
                G.ControlAmp(i)=floor(s);
            end
        else
            for i=g2
                G.ControlAmp(i)=floor(-s);
            end
        end
        FESControl(G.ControlAmp);
    end
end

end