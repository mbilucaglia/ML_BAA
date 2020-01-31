function [table] = feature_extract_temporal_static(data_struct)

n_epoc=numel(data_struct.epoch_data);
n_chan=numel(data_struct.channels);

fc1=0.05;
fc2=10;
Fs=data_struct.Fs;
order=2;

subject_vec=repmat(data_struct.subject,n_epoc,1);
class_vec=string(data_struct.epoch_id)';

for i=1:n_epoc
    
    class_temp=data_struct.epoch_id{i};
    
    feature=[];
    
    for j=1:n_chan
        
        %EEGLAB store data as "Single precision" while matlab wants double
        data_temp=double(data_struct.epoch_data{i}(j,:));
        
        %band-pass filter
        Wp1=fc1/(Fs/2);
        Wp2=fc2/(Fs/2);

        [b,a]=butter(order,[Wp1 Wp2],'bandpass');

        data_out=filtfilt(b,a,data_temp');
        data_temp=data_out';
        
        %resample @20Hz
        fs_new=20;
        
        [int_TT, dec_TT]=rat(fs_new/Fs,1e-6);
        
        data_temp=resample(data_temp',int_TT, dec_TT)';
        time_temp=(1/fs_new)*(0:numel(data_temp)-1)-2;
        
        mean_value=mean(data_temp);
        std_value=std(data_temp,0);
        
        data_temp=(data_temp-mean_value)/(std_value);
        
        feature=[feature,data_temp];
    end
    
    feature_def(i,:)=feature;
end

k=0;

feature_name=strings(1,size(feature_def,2));

for i=1:n_chan
    for j=1:size(time_temp,2)
        k=k+1;
        feature_name(k)=string(sprintf('%s @t=%.3f[s]',data_struct.channels(i),time_temp(j)));
    end
end
        
table.table=feature_def;
table.class=class_vec;
table.var_name=subject_vec;
table.feat_name=feature_name;

end
