classdef Hand_Matrix
    properties
        E;
        Size;
        MovementName;
        AwardGain;
        NP;
        Point;
        PointNo;
        Posterior;
        ElecPosterior;
        Elec;
    end
    
    methods
        %%
        function obj = Hand_Matrix (row,col,name,AwardGain)
            if nargin == 4
                obj.PointNo=0;
                obj.Size=[row,col,length(name)];
                
                obj.MovementName=name;
                obj.AwardGain=AwardGain;
                
                obj.Posterior.Max=zeros(obj.Size(3),3);
                obj.ElecPosterior.Max=zeros(obj.Size(3),9);
                
                for i=1:obj.Size(1)
                    for j=1:obj.Size(2)
                        obj.NP(i,j,:)=[1/col/2+1/col*(j-1)  , 1/row/2+1/row*(i-1)];
                        obj.E(i,j).NP=[1/col/2+1/col*(j-1)  , 1/row/2+1/row*(i-1)];
                        for k=1:obj.Size(3)
                            obj.E(i,j).TS(k).Name=name(k);
                            obj.E(i,j).TS(k).Alpha=1;
                            obj.E(i,j).TS(k).Beta=1;
%                             obj.E(i,j).t=text(obj.E(i,j).NP(1),obj.E(i,j).NP(2)+0.025,'');
                        end
                    end
                end
            end
        end
        
        
        
        %%
        function obj=Update(obj,movementstr,award,npos)
            
            for k=1:obj.Size(3)
                if strcmp(movementstr,obj.MovementName(k))
                    break
                end
            end
            obj.PointNo=obj.PointNo+1;
            obj.Point(obj.PointNo).Pos=npos;
            
            [Left,Right,Bottom,Top,Leftdisn,Bottomdisn]=findindex(npos,obj);
            
            if Bottomdisn<0 ||  Leftdisn<0
                "Wrong Code"
            end
            
            if ~isnan(Bottom)
                obj.E(Bottom,Left).TS(k).Alpha  = obj.E(Bottom,Left).TS(k).Alpha + award*obj.AwardGain * (1-Bottomdisn)*(1-Leftdisn);
                obj.E(Bottom,Left).TS(k).Beta   = obj.E(Bottom,Left).TS(k).Beta  + (1-award)*obj.AwardGain*  (1-Bottomdisn)*(1-Leftdisn);
                
                obj.E(Bottom,Right).TS(k).Alpha  = obj.E(Bottom,Right).TS(k).Alpha + award*obj.AwardGain * (1-Bottomdisn)*(Leftdisn);
                obj.E(Bottom,Right).TS(k).Beta   = obj.E(Bottom,Right).TS(k).Beta + (1-award)*obj.AwardGain* (1-Bottomdisn)*(Leftdisn);
            end
            
            if ~isnan(Top)
                obj.E(Top,Left).TS(k).Alpha     = obj.E(Top,Left).TS(k).Alpha + award*obj.AwardGain * (Bottomdisn)*(1-Leftdisn);
                obj.E(Top,Left).TS(k).Beta      = obj.E(Top,Left).TS(k).Beta + (1-award)*obj.AwardGain* (Bottomdisn)*(1-Leftdisn);
                
                obj.E(Top,Right).TS(k).Alpha    = obj.E(Top,Right).TS(k).Alpha + award*obj.AwardGain * (Bottomdisn)*(Leftdisn);
                obj.E(Top,Right).TS(k).Beta     = obj.E(Top,Right).TS(k).Beta + (1-award)*obj.AwardGain* (Bottomdisn)*(Leftdisn);
            end
            
        end
        
        
        %%
        function obj=Post(obj,Elec)
            
            obj.Posterior.Max=zeros(obj.Size(3),3);
            obj.ElecPosterior.Max=zeros(obj.Size(3),9);
            
            for k=1:obj.Size(3)
                for i=1:obj.Size(1)
                    for j=1:obj.Size(2)
                        obj.E(i,j).TS(k).Posterior=betarnd(obj.E(i,j).TS(k).Alpha, obj.E(i,j).TS(k).Beta);
                        if obj.E(i,j).TS(k).Posterior>obj.Posterior.Max(k,3)
                            obj.Posterior.Max(k,:)= [i,j,obj.E(i,j).TS(k).Posterior];
                        end
                    end
                end
                
                if nargin==2
                    for m=1:size(Elec,2)
                        [Left,Right,Bottom,Top,Leftdisn,Bottomdisn]=findindex(Elec(m).NPos,obj);
                        
                        if ~isnan(Bottom) && ~isnan(Top)
                            obj.Elec(m).TS(k).Posterior= obj.E(Bottom,Left).TS(k).Posterior*(1-Leftdisn)*(1-Bottomdisn)+...
                                obj.E(Bottom,Right).TS(k).Posterior*(Leftdisn)*(1-Bottomdisn)+...
                                obj.E(Top,Left).TS(k).Posterior*(1-Leftdisn)*(Bottomdisn)+...
                                obj.E(Top,Right).TS(k).Posterior*(Leftdisn)*(Bottomdisn);
                        elseif isnan(Bottom)
                            obj.Elec(m).TS(k).Posterior= obj.E(Top,Left).TS(k).Posterior*(1-Leftdisn)*(Bottomdisn)+...
                                obj.E(Top,Right).TS(k).Posterior*(Leftdisn)*(Bottomdisn);
                        else
                            obj.Elec(m).TS(k).Posterior= obj.E(Bottom,Left).TS(k).Posterior*(1-Leftdisn)*(1-Bottomdisn)+...
                                obj.E(Bottom,Right).TS(k).Posterior*(Leftdisn)*(1-Bottomdisn);
                        end
                        
                        if obj.Elec(m).TS(k).Posterior > obj.ElecPosterior.Max(k,end)
                            obj.ElecPosterior.Max(k,:)= [Left,Right,Bottom,Top,Leftdisn,Bottomdisn,m,Elec(m).ID,obj.Elec(m).TS(k).Posterior];
                        end
                        
                    end
                end
                
            end
            
            
        end
        
        %%
        function obj=Eplot(obj,fignumber,movementstr,plotdataflg)
            out=figure(fignumber);out.Name='Nomalized Matrix Position';

            %%
%             [a,b,c] = imread('electrodes.JPG');
%             [a,b,c] = imread('forearm.PNG'); 
% %             a= imread('electrodes.JPG');
%             ff=image('CData',a,'XData',[0 1],'YData',[1 0]);        
% set(ff, 'AlphaData', c);
%             hold on
            %%
            for i=1:obj.Size(1)
                for j=1:obj.Size(2)
                    p=plot(obj.E(i,j).NP(1),obj.E(i,j).NP(2),'.');
                    p.MarkerSize=20;
                    if j>obj.Size(2)/4 && j<=3*obj.Size(2)/4
                        p.Color='r';
                    else
                        p.Color='b';
                    end
                    hold on
                    
                    if ~isempty(movementstr)
                        for k=1:obj.Size(3)
                            if strcmp(movementstr, obj.MovementName(k))
                                s=sprintf('%s(%.1f,%.1f)',cell2mat(obj.E(i,j).TS(k).Name), obj.E(i,j).TS(k).Alpha, obj.E(i,j).TS(k).Beta);
                                
                                if ~isfield(obj.E(i,j),'t')
                                    obj.E(i,j).t=text(obj.E(i,j).NP(1),obj.E(i,j).NP(2)+0.025,'');
                                elseif isempty(obj.E(i,j).t)
                                    obj.E(i,j).t=text(obj.E(i,j).NP(1),obj.E(i,j).NP(2)+0.025,'');
                                end
                                
                                obj.E(i,j).t.String=s;
                                obj.E(i,j).t.HorizontalAlignment='Center';
                                break
                            end
                        end
                    end
                    
                end
            end
            
            if ~isempty(plotdataflg)
                for m=plotdataflg
                    if obj.PointNo>0
                        p=plot(obj.Point(m).Pos(1),obj.Point(m).Pos(2),'Xk');
                        p.MarkerSize=15;
                    end
                end
            end
            
            out.CurrentAxes.XLim=[0,1];
            out.CurrentAxes.YLim=[0,1];
        end
        
        %%
        function [Left,Right,Bottom,Top,Leftdisn,Bottomdisn]=findindex(npos,obj)
            x=npos(1);
            y=npos(2);
            if x< obj.NP(1,1,1)
                Left=  obj.Size(2);
                Leftdisn= (x+1/obj.Size(2)/2)*obj.Size(2);
                Right=1;
            elseif x> obj.NP(1,end,1)
                Left=  1;
                Leftdisn= (x-obj.NP(1,end,1))*obj.Size(2);
                Right=obj.Size(2);
            else
                [valueLeft,Rightorleft] =min(abs(obj.NP(1,:,1)-x));
                if obj.NP(1,Rightorleft,1)>x
                    Right=Rightorleft;
                    Left=Right-1;
                else
                    Left=Rightorleft;
                    Right=Left+1;
                end
                
                Leftdisn= (x - obj.NP(1,Left,1))*obj.Size(2);
            end
            
            
            if y<= obj.NP(1,1,2)
                Bottom=  NaN;
                Bottomdisn= (y+1/obj.Size(1)/2)*obj.Size(1);
                Top=1;
            elseif y>= obj.NP(end,1,2)
                Bottom=   obj.Size(1);
                Bottomdisn= (y-obj.NP(end,1,2))*obj.Size(1);
                Top=NaN;
            else
                [valueBottom,BottomorTop] =min(abs(obj.NP(:,1,2)-y));
                if obj.NP(BottomorTop,1,2)>y
                    Top=BottomorTop;
                    Bottom=Top-1;
                else
                    Bottom=BottomorTop;
                    Top=Bottom+1;
                end
                Bottomdisn= (y - obj.NP(Bottom,1,2))*obj.Size(1);
            end
        end
        
        
    end
    
    
end