ccc;

%initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

parts = {'004';'005';'006';'007';'008';'009';'010';'012';'014';'015';'016';'017';'018';'019';'020';'021';'022';'023';'024'}; %%%Depth
parts = {'007'};
conds = {'near','far'};
blocks = {'01';'02'};
pathname = 'M:\Data\VR_P3\Depth';

rt.cond.block.part = [];
near_count = [];
far_count = [];
total_trials = [];

for i_part = 1:length(parts)
    if str2num(parts{i_part}) >= 11 | str2num(parts{i_part}) == 5
        for i_cond = 1:2
            for i_block = 1:2
                
                total_near = 0;
                total_far = 0;
                
                filename =  [parts{i_part} '_' blocks{i_block} '_depth_p3_' conds{i_cond} '.vhdr'];
                EEG = pop_loadbv(pathname, filename);
                allevents = length(EEG.event);
                for i_event = 2:allevents %skip the first
                    %%%check to see if there are duplicate response triggers%%%
                    %%%sometimes we get two response triggers overlapping%%%
                    EEG.event(i_event).type = num2str(str2num(EEG.event(i_event).type(2:end)));
                    if i_event+1 <= allevents
                        if strcmp(EEG.event(i_event).type, '139') == 1
                            if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                                EEG.event(i_event+1).type = 'S0000';
                            end
                        elseif strcmp(EEG.event(i_event).type, '138') == 1
                            if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                                EEG.event(i_event+1).type = 'S0000';
                            end
                        end
                        if strcmp(EEG.event(i_event).type, '1') == 1
                            EEG.event(i_event).type = '111';
                        elseif strcmp(EEG.event(i_event).type, '2') == 1
                            EEG.event(i_event).type = '222';
                        end
                    end
                end
                
                for i_event = 2:allevents
                    if strcmp(EEG.event(i_event).type, '111') == 1
                        total_near = total_near + 1;
                    elseif strcmp(EEG.event(i_event).type, '222') == 1
                        total_far = total_far + 1;
                    end
                    if i_event+1 <= allevents
                        if strcmp(EEG.event(i_event).type, '111') == 1
                            if strcmp(EEG.event(i_event+1).type, '138') == 1 | strcmp(EEG.event(i_event+1).type, '139') == 1
                                temp_near(total_near) = (EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate;
                            end
                        elseif strcmp(EEG.event(i_event).type, '222') == 1
                            if strcmp(EEG.event(i_event+1).type, '138') == 1 | strcmp(EEG.event(i_event+1).type, '139') == 1
                                temp_far(total_far) = (EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate;
                            end
                        end
                    end
                end
                temp_near(temp_near == 0) = [];
                temp_far(temp_far == 0) = [];
                if strcmp(conds{i_cond},'near') == 1
                    rt(i_part).cond(i_cond).block(i_block).part(1,:) = temp_near;
                elseif strcmp(conds{i_cond},'far') == 1
                    rt(i_part).cond(i_cond).block(i_block).part(1,:) = temp_far;
                end
                total_trials(i_cond,i_block,i_part) = total_near + total_far;
            end
        end
        
    elseif str2num(parts{i_part}) < 11 & str2num(parts{i_part}) ~= 5
        for i_cond = 1:2
            
            total_near = 0;
            total_far = 0;
            temp_near = [];
            temp_far = [];
            
            filename =  [parts{i_part} '_depth_p3_' conds{i_cond} '.vhdr'];
            EEG = pop_loadbv(pathname, filename);
            allevents = length(EEG.event);
            for i_event = 2:allevents %skip the first
                %%%check to see if there are duplicate response triggers%%%
                %%%sometimes we get two response triggers overlapping%%%
                EEG.event(i_event).type = num2str(str2num(EEG.event(i_event).type(2:end)));
                if i_event+1 <= allevents
                    if strcmp(EEG.event(i_event).type, '139') == 1
                        if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                            EEG.event(i_event+1).type = 'S0000';
                        end
                    elseif strcmp(EEG.event(i_event).type, '138') == 1
                        if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                            EEG.event(i_event+1).type = 'S0000';
                        end
                    end
                    if strcmp(EEG.event(i_event).type, '1') == 1
                        EEG.event(i_event).type = '111';
                    elseif strcmp(EEG.event(i_event).type, '2') == 1
                        EEG.event(i_event).type = '222';
                    end
                end
            end
            
            for i_event = 2:allevents
                if (total_near + total_far) <= 250
                    i_block = 1;
                elseif (total_near + total_far) > 250
                    i_block = 2;
                end
                if strcmp(EEG.event(i_event).type, '111') == 1
                    total_near = total_near + 1;
                elseif strcmp(EEG.event(i_event).type, '222') == 1
                    total_far = total_far + 1;
                end
                if i_event+1 <= allevents
                    if strcmp(EEG.event(i_event).type, '111') == 1
                        if strcmp(EEG.event(i_event+1).type, '138') == 1 | strcmp(EEG.event(i_event+1).type, '139') == 1
                            temp_near(total_near) = (EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate;
                        end
                    elseif strcmp(EEG.event(i_event).type, '222') == 1
                        if strcmp(EEG.event(i_event+1).type, '138') == 1 | strcmp(EEG.event(i_event+1).type, '139') == 1
                            temp_far(total_far) = (EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate;
                        end
                    end
                end
            end
            temp_near(temp_near == 0) = [];
            temp_far(temp_far == 0) = [];
            if strcmp(conds{i_cond},'near') == 1
                rt(i_part).cond(i_cond).block(i_block).part(1,:) = temp_near;
            elseif strcmp(conds{i_cond},'far') == 1
                rt(i_part).cond(i_cond).block(i_block).part(1,:) = temp_far;
            end
            total_trials(i_cond,i_block,i_part) = total_near + total_far;
        end
    end
end

rt_near = [rt_near(1,:),rt_near(2,:)];
rt_far = [rt_far(1,:),rt_far(2,:)];

rt_near(rt_near ==0) = [];
rt_far(rt_far ==0) = [];

mean(rt_near)
min(rt_near)
max(rt_near)

mean(rt_far)
min(rt_far)
max(rt_far)

for i_loop = 1
    i_loop = 3;
end
