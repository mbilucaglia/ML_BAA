function [] = crossval_static(table_struct,n_rep)

eeglab('nogui');
clearvars -GLOBAL 'ALLCOM' 'ALLEEG' 'CURRENTSET' 'CURRENTSTUDY' 'EEG' 'LASTCOM' 'PLUGINLIST' 'STUDY'

addpath('.\aux_func_IO');

class=unique(table_struct.class);


task=["Ac","Pr","Ps"];
type=["Im","So"];

table_temp=table_struct;

k=0;

for i=1:numel(task)
    
    for j=1:numel(type)
        
        k=k+1;
        
        class_temp1=string(sprintf('%s-H-%s',task(i),type(j)));
        class_temp2=string(sprintf('%s-L-%s',task(i),type(j)));
        
        id1=find(table_struct.class==class_temp1);
        id2=find(table_struct.class==class_temp2);
        
        table_temp.table=table_struct.table([id1;id2],:);
        table_temp.class=table_struct.class([id1;id2],:);
        table_temp.var_name=table_struct.var_name([id1; id2]);
        table_temp.feat_name=table_struct.feat_name;
        
        subplot(numel(task),numel(type),k);
        title(sprintf('%s-%s: High VS Low',task(i),type(j)));
        
        crossval_table=crossval_FAS_1class(table_temp,n_rep);

        assignin('base',sprintf('Table_%s_%s',task(i),type(j)),crossval_table);
        
        
        
    end
    
    
end



end

