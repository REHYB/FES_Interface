
%%
function SKGameFun(handles,t,fSK)
global G
temp_dis=4*G.SKGame.r;
if G.SKGame.Start==1 && ( (G.No_Trials<=G.SKGame.No && G.SKGame_BasedOnTimeFlg==3) || (G.No_Trials_BasedOnTime<=G.SKGame.No && G.SKGame_BasedOnTimeFlg~=3) )
    
    if G.SKGame.First==1
        G.SKGame.tStart=t;
        date=datetime('now');
        feedbackname=sprintf("%s_%s_%d_%d_%d_%d_%d",G.SKGame.Name,datestr(date,30),floor(100*G.SKGame.Max),floor(100*G.SKGame.Min),floor(100*G.SKGame.No),floor(100*G.SKGame.Duration),floor(100*G.SKGame.Rest));
        dirtemp=sprintf("Schon_Klinik_Feedback\\Feedback");
        
        if exist(dirtemp,'dir')~=7
            mkdir(dirtemp);
        end
        G.SKGame.file_SK_fb = fopen(sprintf("Schon_Klinik_Feedback\\Feedback\\%s.txt",feedbackname),'wt');
        G.SKGame.fileIsOpen=1;
        G.SKGame.First=0;
        
        G.SKGame.t_desirable_bound_start=t-G.SKGame.tStart;
        G.SKGame.region1_init=0;
        G.SKGame.region_time=0;
        G.SKGame.region=0;
        G.SKGame.rest_flg=0;
        G.SKGame.ref_place_flag=0;
        G.No_Trials=1;
        G.No_Trials_BasedOnTime=1;
        G.Status_BasedOnTime=0;
        G.SKGame.FirstTimeIndex=G.c(1);
    end
    
    G.SKGame.LastTimeIndex=G.c(end);
    
    G.SKGame.t=t-G.SKGame.tStart;
    
    
    if G.SKGame.WriteDataMethod==1
        fprintf(G.SKGame.file_SK_fb,sprintf("%f,%f\n",G.SKGame.t,fSK));
    elseif G.SKGame.WriteDataMethod==2
        for j=1:length(G.c)
            fprintf(G.SKGame.file_SK_fb,sprintf("%f,%f\n",G.t_r(G.c(j))-G.t_r(G.SKGame.FirstTimeIndex),(G.data(G.c(j),1) + G.data(G.c(j),2))/2.0));
        end
    elseif G.SKGame.WriteDataMethod==3
        for j=1:length(G.c)
            fprintf(G.SKGame.file_SK_fb,sprintf("%f,%f\n",G.t_r(G.c(j))-G.SKGame.t,(G.data(G.c(j),1) + G.data(G.c(j),2))/2.0));
        end
        fprintf(G.SKGame.file_SK_fb,sprintf("\n"));
    end
    
    
    
    if G.SKGame_BasedOnTimeFlg==2
        if G.SKGame.t >= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration  + G.SKGame.Rest ) && G.SKGame.t <= (G.No_Trials_BasedOnTime)*(G.SKGame.Duration+ G.SKGame.Rest) - G.SKGame.Rest
            G.Status_BasedOnTime_str={'Stimulation'};
            G.Status_BasedOnTime=2;
        elseif G.SKGame.t < (G.No_Trials_BasedOnTime)*(G.SKGame.Duration+ G.SKGame.Rest)
            G.Status_BasedOnTime_str={'Rest'};
            G.Status_BasedOnTime=3;
        else
            G.No_Trials_BasedOnTime=G.No_Trials_BasedOnTime+1;
            if G.No_Trials_BasedOnTime<=G.SKGame.No
                G.SKGame.TextCnt(1).String=sprintf("%d/%d",G.No_Trials_BasedOnTime,G.SKGame.No);
                G.SKGame.TextCnt(2).String=sprintf("%d/%d",G.No_Trials_BasedOnTime,G.SKGame.No);
            end
        end
    elseif G.SKGame_BasedOnTimeFlg==1
        if G.SKGame.t >= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration  + G.SKGame.Rest ) && G.SKGame.t <= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1)
            G.Status_BasedOnTime_str={'Rest'};
            G.Status_BasedOnTime=1;
        elseif G.SKGame.t > (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) && G.SKGame.t <= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) + G.SKGame.Duration
            G.Status_BasedOnTime_str={'Stimulation'};
            G.Status_BasedOnTime=2;
        elseif G.SKGame.t > (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) + G.SKGame.Duration && G.SKGame.t <= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) + G.SKGame.Duration + G.SKGame.Restv(2)
            G.Status_BasedOnTime_str={'Rest'};
            G.Status_BasedOnTime=3;
        elseif G.SKGame.t > (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) + G.SKGame.Duration + G.SKGame.Restv(2) && G.SKGame.t <= (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration + G.SKGame.Rest) + G.SKGame.Restv(1) + G.SKGame.Duration + G.SKGame.Restv(2) + G.SKGame.Restv(3)
            G.Status_BasedOnTime_str={'Rest'};
            G.Status_BasedOnTime=4;
        else
            G.No_Trials_BasedOnTime=G.No_Trials_BasedOnTime+1;
            if G.No_Trials_BasedOnTime<=G.SKGame.No
                G.SKGame.TextCnt(1).String=sprintf("%d/%d",G.No_Trials_BasedOnTime,G.SKGame.No);
                G.SKGame.TextCnt(2).String=sprintf("%d/%d",G.No_Trials_BasedOnTime,G.SKGame.No);
            end
        end
    end
    
    
    
    if (fSK <= 0.15 )
        G.SKGame.region=1;
    elseif (0.15 < fSK && fSK <= temp_dis )
        G.SKGame.region=2;
    elseif (temp_dis < fSK && fSK < G.SKGame.Min )
        G.SKGame.region=3;
    elseif fSK >= G.SKGame.Min && fSK  <= G.SKGame.Max
        G.SKGame.region=4;
    else
        G.SKGame.region=5;
    end
    
    if  G.SKGame.region==4 && G.SKGame.region1_init==0
        G.SKGame.t_desirable_bound_start=G.SKGame.t;
        G.SKGame.region1_init=1;
    end
    
    if G.SKGame_BasedOnTimeFlg==3
        for i=1:2
            G.SKGame.Plot3(i).Visible='on';
        end
    end
    
    if G.SKGame.region1_init==1 && (G.SKGame.t - G.SKGame.t_desirable_bound_start) <= G.SKGame.Duration
        G.SKGame.region_time=1;
        G.SKGame.rest_flg=0;
    elseif G.SKGame.region1_init==1 && (G.SKGame.t - G.SKGame.t_desirable_bound_start) > G.SKGame.Duration && (G.SKGame.t - G.SKGame.t_desirable_bound_start) <= (G.SKGame.Duration + G.SKGame.Rest)
        G.SKGame.region_time=2;
        G.SKGame.rest_flg=0;
        for i=1:2
            G.SKGame.Plot3(i).Visible='off';
        end
    elseif G.SKGame.region1_init==1 && (G.SKGame.t - G.SKGame.t_desirable_bound_start) > (G.SKGame.Duration + G.SKGame.Rest)
        G.SKGame.rest_flg=1;
        G.SKGame.region_time=0;
    end
    
    if G.SKGame.rest_flg==1 && G.SKGame.region<=2
        G.SKGame.region_time=0;
        G.SKGame.region1_init=0;
        G.SKGame.rest_flg=0;
        G.SKGame.ref_place_flag=1;
        G.No_Trials=G.No_Trials+1;
        
    end
    
    
    
    if G.SKGame.ref_place_flag==0 && G.SKGame.rest_flg==0
        follow = + (fSK + temp_dis )*(fSK + 0.5 < G.SKGame.Min ) + (G.SKGame.Max+G.SKGame.Min)/2* (fSK+0.5 >= G.SKGame.Min );
    else
        follow=temp_dis;
        if fSK <= temp_dis
            G.SKGame.ref_place_flag=0;
        end
    end
    
    follow=limit(follow,0,(G.SKGame.Max+G.SKGame.Min)/2);
    
    
    for i=1:2
        if G.SKGame_BasedOnTimeFlg~=1
            if G.SKGame.region_time<2 && G.SKGame.rest_flg==0
                %                                 G.SKGame.Plot3(i).Visible='on';
                if (fSK <= 0.15 )
                    G.SKGame.Plot2(i).MarkerFaceColor=[0.941 0.941 0.941];
                elseif (0.15 < fSK && fSK < G.SKGame.Min )
                    G.SKGame.Plot2(i).MarkerFaceColor='b';
                elseif fSK > G.SKGame.Min && fSK  < G.SKGame.Max
                    G.SKGame.Plot2(i).MarkerFaceColor='g';
                else
                    G.SKGame.Plot2(i).MarkerFaceColor='r';
                end
                
            elseif G.SKGame.region_time==2
                
                G.SKGame.Plot2(i).MarkerFaceColor=[0.941 0.941 0.941];
                %                                 G.SKGame.Plot3(i).Visible='off';
            end
            
        else
            
            if G.Status_BasedOnTime==1
                G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb1;
                G.SKGame.HintText(i).String=G.SKGame.rgbtext(5);
                G.SKGame.HintText(i).Color='k';
            elseif G.Status_BasedOnTime==2
                if fSK > G.SKGame.Min && fSK  < G.SKGame.Max
                    G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb3;
                    G.SKGame.HintText(i).String=G.SKGame.rgbtext(7);
                    G.SKGame.HintText(i).Color='k';
                else
                    G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb2;
                    G.SKGame.HintText(i).String=G.SKGame.rgbtext(6);
                    G.SKGame.HintText(i).Color='k';
                end
            elseif G.Status_BasedOnTime==3
                G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb1;
                G.SKGame.HintText(i).String=G.SKGame.rgbtext(5);
                G.SKGame.HintText(i).Color='k';
            elseif G.Status_BasedOnTime==4
                G.SKGame.Plot1(i).FaceColor=G.SKGame.rgb4;
                G.SKGame.HintText(i).String=G.SKGame.rgbtext(8);
                G.SKGame.HintText(i).Color='w';
            end
            
            
            
        end
    end
    
    
    
    for i=1:2
        % G.SKGame.Plot2(i).XData=0.5*G.SKGame.PMax+G.SKGame.x;
        % G.SKGame.Plot2(i).YData=G.SKGame.y+fSK;
        G.SKGame.Plot2(i).XData=0.5*G.SKGame.PMax;
        G.SKGame.Plot2(i).YData=fSK;
        
        if G.SKGame.PlotTextFlg==1
            G.SKGame.Plot3_text(i).Position(2)= follow ;
        end
        
        G.SKGame.Plot3(i).XData=0.5*G.SKGame.PMax;
        G.SKGame.Plot3(i).YData= follow ;
        
        
        
        if G.SKGame.PlotTextFlg==1
            if (fSK < G.SKGame.Min )
                G.SKGame.Plot3_text(i).String={sprintf("%s!!",G.SKGame.Name);"Catch Me";"If You Can:)"};
            elseif fSK > G.SKGame.Min && fSK  < G.SKGame.Max
                G.SKGame.Plot3_text(i).String={"";"Perfect";":)"};
            else
                G.SKGame.Plot3_text(i).String={"";"No, No, No";sprintf("Come Back %s!!",G.SKGame.Name)};
            end
        end
        
    end
    
    
    if  G.SKGame_BasedOnTimeFlg==1
        if G.Status_BasedOnTime~=2
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials_BasedOnTime,G.SKGame.No);sprintf('Status: Rest Time')};
        else
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials_BasedOnTime,G.SKGame.No);sprintf('Status: Stimulation (Passed time: %0.1f sec.)',G.SKGame.t - (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration  + G.SKGame.Rest )- G.SKGame.Restv(1))};
        end
    elseif G.SKGame_BasedOnTimeFlg==2
        if G.Status_BasedOnTime~=2
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials_BasedOnTime,G.SKGame.No);sprintf('Status: Rest Time (Passed time: %0.1f sec.)',G.SKGame.t - (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration  + G.SKGame.Rest )-G.SKGame.Duration)};
        else
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials_BasedOnTime,G.SKGame.No);sprintf('Status: Stimulation (Passed time: %0.1f sec.)',G.SKGame.t - (G.No_Trials_BasedOnTime-1)*(G.SKGame.Duration  + G.SKGame.Rest ) )};
        end
    else
        if G.SKGame.region_time==2
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials,G.SKGame.No);sprintf('Status: Rest Time (Passed time: %0.1f sec. out of %0.1f sec.)',(G.SKGame.t - G.SKGame.t_desirable_bound_start-G.SKGame.Duration), G.SKGame.Rest);};
        elseif G.SKGame.region_time==1
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials,G.SKGame.No);sprintf('Status: In Desirable Force Range (Passed time: %0.1f sec. out of %0.1f sec.)',(G.SKGame.t - G.SKGame.t_desirable_bound_start),G.SKGame.Duration)};
        else
            handles.SKGame(1,5).String={sprintf('time(s)=%0.1f',G.SKGame.t);sprintf('trial No=%d out of %d',G.No_Trials,G.SKGame.No);sprintf('Status: Out of Desirable Force Range')};
        end
    end
    
end

if G.SKGame.Start==1 && ( (G.No_Trials>G.SKGame.No && G.SKGame_BasedOnTimeFlg==3) || (G.No_Trials_BasedOnTime>G.SKGame.No && G.SKGame_BasedOnTimeFlg~=3) )
    handles.SKGame(1,5).String={'Number of trials finished';'Please click on Stop';'Then start again'};
end
end