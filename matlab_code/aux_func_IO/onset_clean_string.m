function [id_out,onset_out, offset_out] = onset_clean_string (id_in)

id_in=column_ceck(id_in);

l=length(id_in);

stim_unique=unique(id_in);
n_stim=numel(stim_unique);

onset_out=NaN(1,n_stim);
offset_out=NaN(1,n_stim);

for i=1:n_stim
    onset_out(i)=find(strcmp(id_in,stim_unique(i)),1,'first');
    offset_out(i)=find(strcmp(id_in,stim_unique(i)),1,'last');
    
end

id_out=id_in(onset_out);

[~,id_new_pos]=sort(onset_out,'ascend');

id_out=id_out(id_new_pos);
onset_out=onset_out(id_new_pos);
offset_out=offset_out(id_new_pos);


end