list=who;
eeglab('nogui');
clearvars('-except',list{:});


addpath('.\aux_func_IO');

list=who;

[filename,filepath]=uigetfile('*.set','Load SET files','Multiselect','on');

if isequal(filename,0)
    return;
end

if ~iscell(filename)
    filename={filename};
end

n_sbj=numel(filename);

table=struct('table',[],'class',[],'var_name',[],'feat_name',[]);

wb=waitbar(0,'Start processing...');
set(get(get(wb, 'CurrentAxes'), 'title'), 'Interpreter', 'none'); %no latex interpreter into waitbar

for i=1:n_sbj%for every subject
    
    waitbar((i-1)/n_sbj,wb,sprintf('Subject %.0d/%.0d',i,n_sbj));
   
    data_struct_raw=set2struct(strcat(filepath,'\',filename));
    
    %only 128 channels!
    data_struct_raw.channels=data_struct_raw.channels(1:128);
    data_struct_raw.channels_type=data_struct_raw.channels_type(1:128);
    data_struct_raw.channels_unit=data_struct_raw.channels_unit(1:128);
    
    data_struct_raw.data=data_struct_raw.data(1:128,:,:);
    
    %extract the original events
    data_struct_raw.event_id=extractBetween(data_struct_raw.event_id,"(",")");
    data_struct_raw.epoch_id=extractBetween(data_struct_raw.epoch_id,"(",")");
    
    %re-code the event
    data_struct_raw.event_id=event_translation(data_struct_raw.event_id);
    data_struct_raw.epoch_id=event_translation(data_struct_raw.epoch_id);
    
    fprintf(1,'\n');
    fprintf(1,'-> Path: %s\n\n',data_struct_raw.path);
    
    %0.3s AFTER the onset to 1.3s after the onset
    n=size(data_struct_raw.data,3);
    
    %sample 126=0.3s, sample 375=1.2960
    for ii=1:n %for every epoch
        data_struct_raw.epoch_data{ii}=data_struct_raw.epoch_data{ii}(:,126:375);
        data_struct_raw.epoch_timeline{ii}=data_struct_raw.epoch_timeline{ii}(126:375);
        
    end
    
    
    if isempty(data_struct_raw.epoch_data)
        continue;
    else
        fprintf(1,'\n');
        fprintf(1,'Extracting features ');
    
        [table_temp]=feature_extract_time_FAS(data_struct_raw);
        
        fprintf(1,'-> Done\n');
        
        %update "table" global struct
        table.table=cat(1, table.table, table_temp.table);
        table.class=cat(1, table.class, table_temp.class);
        table.var_name=cat(1, table.var_name, table_temp.var_name);
        table.feat_name=[table_temp.feat_name];
        
    end
    
    
    close all;
    
    keepvars=['Dataset_group','table','n_sbj','wb','list','selection',list'];
    
    clearvars('-except',keepvars{:});
    
    waitbar((i)/n_sbj,wb,sprintf('Subject %.0d/%.0d',i,n_sbj));

end


delete(wb);

clearvars('Dataset_group','n_sbj','wb','list','selection','data_struct_raw','n','i','ii','data_struct_raw');

close all;


