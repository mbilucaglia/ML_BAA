function [] = crossval_dynamic(table_struct,n_rep)

tic

if nargin<2
    n_rep=10;
end

% eeglab('nogui');
% clearvars -GLOBAL 'ALLCOM' 'ALLEEG' 'CURRENTSET' 'CURRENTSTUDY' 'EEG' 'LASTCOM' 'PLUGINLIST' 'STUDY'

addpath('.\aux_func_IO');

task=["Ac","Pr","Ps"];
type=["Im","So"];

table_temp=table_struct;

n_pt=size(table_struct.table,3);

for i=1:numel(task)
    
    for j=1:numel(type)
        
        for n=1:n_pt
        
        
        class_temp1=string(sprintf('%s-H-%s',task(i),type(j)));
        class_temp2=string(sprintf('%s-L-%s',task(i),type(j)));
        
        id1=find(table_struct.class==class_temp1);
        id2=find(table_struct.class==class_temp2);
        
        table_temp_temp=table_temp;
        table_temp_temp.table=table_struct.table([id1;id2],:,n);
        table_temp_temp.class=table_struct.class([id1;id2]);
        crossval_table(:,:,n)=crossval_FAS_1class_dynamic(table_temp_temp,n_rep);
        end
        
        assignin('base',sprintf('Table_%s_%s',task(i),type(j)),crossval_table);
        
    end
    
    
end

toc

end

