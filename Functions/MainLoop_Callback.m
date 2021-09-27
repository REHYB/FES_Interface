%%
% MainLoop_Callback
function MainLoop_Callback(hObject, eventdata, handles)
global G;
tic;


while(1 && G.Terminate==0)
    
    G.Sen.told=-1000;
    G.FES.told=-1000;
    G.Vis.told=-1000;
    
    G.Sen.Act=1;
    G.FES.Act=1;
    G.Vis.Act=1;
    
    G.Sen.Step=1/10;
    G.FES.Step=1/5;
    G.Vis.Step=1/1;
    
    while(1 && G.Terminate==0)
        
        
        if (G.stop==1)
            pause(0.001);
        else
            %
            
            G.Sen.tnew= toc;
            if (G.Sen.tnew-G.Sen.told)>G.Sen.Step && G.Sen.Act
                G.Sen.told=toc;
                fprintf('Sen\n');
                %             L_Sen_Fun();
            end
            
            G.Con.tnew= toc;
            if (G.Con.tnew-G.Con.told)>G.Con.Step && G.Con.Act
                G.Con.told=toc;
                fprintf('Con\n');
                %             L_Con_Fun();
            end
            
            G.UI.t.new= toc;
            if (G.UI.tnew-G.UI.told)>G.UI.Step && G.UI.Act
                G.UI.told=toc;
                fprintf('UI\n');
                %             L_UI_Fun();
            end
            
            G.FES.t.new= toc;
            if (G.FES.tnew-G.FES.told)>G.FES.Step && G.FES.Act
                G.FES.told=toc;
                fprintf('FES\n');
                %             L_FES_Fun();
            end
            
            
            G.Vis.t.new= toc;
            if (G.Vis.tnew-G.Vis.told)>G.Vis.Step && G.Vis.Act
                G.Vis.told=toc;
                fprintf('Vis\n');
                %                 L_Vis_Fun();
            end
            
            
            %
        end
    end
    
    
end

end