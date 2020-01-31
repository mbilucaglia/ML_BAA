function [data_out] = extract_epoch_struct(data_in,block)

data_out=data_in;

if nargin<2
    block=[0 0];
end

Fs=data_in.Fs;
data=data_in.data;

stim=data_in.event_id;
n_stim=numel(stim);

start_stim=data_in.event_begin;

if isfield(data_in,'event_end')
    end_stim=data_in.event_end;
else
    end_stim=star_stim+(5*Fs);
end

pre_block=(round(block(1)*Fs));
post_block=round(block(2)*Fs);

epoch_cell=cell(1,n_stim); 
epoch_timeline=cell(1,n_stim);

for i=1:n_stim %for every class of stimuli
    epoch_cell{1,i}=data(:,((start_stim(i)-pre_block):(start_stim(i)+post_block-1)));
    l_epoch=size(epoch_cell{1,i},2);
    epoch_timeline{1,i}=(1/Fs)*((0:l_epoch-1)-pre_block);
    
end

data_out.epoch_id=data_out.event_id;
data_out.epoch_data=epoch_cell;
data_out.epoch_timeline=epoch_timeline;

end
