function [table] = feature_extract_temporal_dynamic(data_struct)

n_epoc=numel(data_struct.epoch_data);
n_chan=numel(data_struct.channels);
n_point=size(data_struct.epoch_data{1},2);

Fs=data_struct.Fs;
window=round(0.5*Fs);

%filter====================================================================
fc1=0.05;
fc2=10;
order=2;
%band-pass filter
Wp1=fc1/(Fs/2);
Wp2=fc2/(Fs/2);
[b,a]=butter(order,[Wp1 Wp2],'bandpass');
%==========================================================================

%resample @20Hz ===========================================================
fs_new=20;
[int_TT, dec_TT]=rat(fs_new/Fs,1e-6);
%==========================================================================
subject_vec=repmat(data_struct.subject,n_epoc,1);
class_vec=string(data_struct.epoch_id)';

for i_epoch=1:n_epoc %for every epoch
    
    for i_point=1:(n_point-window) %for every time point
        
        feature=[]; %initialize "feature" void for every time point
        time_temp(i_point)=data_struct.epoch_timeline{i_epoch}(i_point);
        
        for i_chan=1:n_chan
        
        %EEGLAB store data as "Single precision" while matlab wants double
        data_temp=double(data_struct.epoch_data{i_epoch}(i_chan,i_point:i_point+window-1));
        
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
        %==================================================================
        
        feature=cat(2,feature,data_temp);
        
        end
        
        feature_def(i_epoch,:,i_point)=feature;
    end
    
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
table.time=time_temp;
table.class=class_vec;
table.var_name=subject_vec;
table.feat_name=feature_name;

end
