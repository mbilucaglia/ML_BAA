function [data_out] = set2struct(filepath)

EEG=pop_loadset(filepath);

data_out.path=string(EEG.filepath);

data_out.origin="SET file";

data_out.subject=string(EEG.subject);

data_out.date=string(upper(date));

data_out.Fs=double(EEG.srate);

data_out.channels=string({EEG.chanlocs.labels}');

data_out.channels_type=string({EEG.chanlocs.type}');

data_out.channels_unit=repmat("",size(data_out.channels,1),1);

data_out.data=EEG.data;

data_out.event_id=string({EEG.event.type}');

data_out.event_pos=cell2mat({EEG.event.latency}');


n=size(data_out.data,3);

if n>1
    data_out.epoch_id=strings(1,n);
    data_out.epoch_data=cell(1,n);
    data_out.epoch_timeline=cell(1,n);
    
    for i=1:n
        data_out.epoch_id(i)=data_out.event_id(i);
        data_out.epoch_data{i}=data_out.data(:,:,i);
        data_out.epoch_timeline{i}=EEG.times/1000; %in ms
    end
end

end

