%%
function SensorDataAnalysis(D)
global G

G.MaxLoad=max(G.MaxLoad , G.load);

if (G.load>=1.60 && G.load<=1.75)
    mu= G.load/mean(G.data(G.c,1) + G.data(G.c,2));
    if G.t<40
        if G.muCnt==0
            G.muav=mu;
        end
        G.muCnt=G.muCnt+1;
        G.muav=(G.muCnt*G.muav+mu)/(G.muCnt+1);
    end
    %                     fprintf('mu=%f  mucriticalmean=%f\n',mu,G.muav);
end

if (G.load>=1.6)
    G.startCnt=G.startCnt+1;
    if (G.startCnt==1)
        G.Teject=G.t;
    end
else
    G.startCnt=0;
    G.Teject=0;
    G.StartFlg=0;
    G.plotforceflg=0;
end

if (G.startCnt>0 && G.StartFlg==0 && G.t>G.Teject+0.1)
    G.StartFlg=1;
    Force=mean(G.data(G.c,1) + G.data(G.c,2))/2.0;
end

%%%%%%%%%%%%%%%%%%%%%%
G.A.b.x=mean(D(:,4));
G.A.b.y=mean(D(:,5));
G.A.b.z=mean(D(:,6));
G.A.b.vector=[G.A.b.x;G.A.b.y;G.A.b.z];
G.A.b.abs=sqrt(G.A.b.x^2+G.A.b.y^2+G.A.b.z^2);
%         G.A.b.abs=floor(G.A.b.abs*10000)/10000;
%% coarse Allignment
timestep=size(G.num,1)*1/128;
if (G.t<G.tCalibration)
    
    G.A.time         = G.timea_old+size(G.num,1)*1/128;
    G.A.b.vectorMean = (G.timea_old * G.A.b.vectorMean + G.A.b.vector * timestep)/G.A.time;
    G.A.b.absMean    = sqrt(G.A.b.vectorMean(1)^2 + G.A.b.vectorMean(2)^2 + G.A.b.vectorMean(3)^2);
    
    G.Angle.phi=atan(G.A.b.vectorMean(2)/G.A.b.vectorMean(3));
    G.Angle.theta=atan(  -G.A.b.vectorMean(1)/sqrt(G.A.b.vectorMean(2)^2+G.A.b.vectorMean(3)^2)  );
    G.Angle.Rphi  = [1 0 0 ;0 cos(G.Angle.phi) sin(G.Angle.phi);0 -sin(G.Angle.phi) cos(G.Angle.phi)];
    G.Rtheta= [cos(G.Angle.theta) 0 -sin(G.Angle.theta);0 1 0;sin(G.Angle.theta) 0 cos(G.Angle.theta)];
    G.A.g.vectorMean=G.Rtheta.'*G.Angle.Rphi.'*G.A.b.vectorMean;
    % fprintf('Angle.phi=%f Angle.theta=%f a=%f,%f,%f\n',Angle.phi*180/pi,G.Angle.theta*180/pi,G.A.g.vectorMean);
    % fprintf('phixyz=%f thetaxyz=%f\n',G.Angle.phi*180/pi,G.Angle.theta*180/pi);
    
    aa.String='Initialize';
    G.A.time=G.timea_old+size(G.num,1)*1/128;
    G.abodymean= (G.timea_old * G.abodymean + G.A.b.vector * timestep)/G.A.time;
    G.atotal= (G.timea_old * G.atotal + G.A.b.abs * timestep)/G.A.time;
    G.azave = (G.timea_old * G.azave + G.A.b.z * timestep)/G.A.time;
    G.timea_old=G.A.time;
    %             fprintf('G.atotal=%f\n',G.atotal);
    G.astepfilt=G.A.b.abs;
    G.aglobalmean= G.Rtheta.'*G.Angle.Rphi.'*G.abodymean;
else
    G.g=9.81/G.A.b.absMean;
    G.Angle.phi=atan(G.A.b.vector(2)/G.A.b.vector(3));
    G.Angle.theta=atan(  -G.A.b.vector(1)/sqrt(G.A.b.vector(2)^2+G.A.b.vector(3)^2)  );
    G.Angle.Rphi  = [1 0 0 ;0 cos(G.Angle.phi) sin(G.Angle.phi);0 -sin(G.Angle.phi) cos(G.Angle.phi)];
    G.Rtheta= [cos(G.Angle.theta) 0 -sin(G.Angle.theta);0 1 0;sin(G.Angle.theta) 0 cos(G.Angle.theta)];
    G.A.g.vector = G.Rtheta.'*G.Angle.Rphi.'*G.A.b.vector;
    G.A.g.net    = G.A.g.vector - G.A.g.vectorMean;
    G.A.g.net;
    aa.String='Start';
    G.astepfilt=(0*G.astepfilt + 9*G.A.b.abs)/(9+0);
    
    
    if G.load>0.9
        % G.vz=G.vz+((G.A.b.z - G.azave)*9.81*timestep);
        
        G.vz= G.vz+ G.A.g.net(3)*G.g*timestep;
        %                        G.vz=G.vz+((G.astepfilt - G.atotal)*G.g*timestep); % best
        G.vz=(abs(G.A.g.net(3)*G.g)>0.0001)*(G.vz);
        %                 G.vz=G.vz+((G.A.g.vectorMean(3) - G.aglobalmean(3))*9.81*timestep);
        G.vx=G.vx+((G.A.g.vectorMean(1) - G.aglobalmean(1))*G.g*timestep)*0;
        
    else
        G.vz=0;
        G.vx=0;
    end
    G.disz=G.disz+G.vz*timestep;
    G.diszshow=limit(G.disz,-0.1,0.50);
    G.disx=G.disx+G.vx*timestep;
    
end
%        fprintf('dela=%f G.vz=%f G.disz=%f\n',G.A.b.abs-G.atotal,G.vz,G.disz);
end
