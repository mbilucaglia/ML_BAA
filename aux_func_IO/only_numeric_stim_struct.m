function [id_event, pos_event] = only_numeric_stim_struct(event)

n_event=numel(event);

id_event=cell(1,n_event);
pos_event=zeros(1,n_event);

for i=1:n_event
    id_event{i}=event(i).value;
    pos_event(i)=event(i).sample;
end

id_event=str2double(id_event);

position_ok=find(~isnan(id_event));

id_event=id_event(position_ok);
pos_event=pos_event(position_ok);

end

