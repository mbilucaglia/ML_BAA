function [table] = feature_extract_spectral_static(data_struct)

n_epoc=numel(data_struct.epoch_data);
n_chan=numel(data_struct.channels);

fc1=0.05;
fc2=10;
Fs=data_struct.Fs;
order=2;

subject_vec=repmat(data_struct.subject,n_epoc,1);
class_vec=string(data_struct.epoch_id)';

feature_def=zeros(n_epoc,n_chan);

for i=1:n_epoc
    
    class_temp=data_struct.epoch_id{i};
    
    feature=[];
    
    for j=1:n_chan
        
        %EEGLAB store data as "Single precision" while matlab wants double
        data_temp=double(data_struct.epoch_data{i}(j,:));
        data_temp=detrend(data_temp,'constant');
        
        %Compute PSD
        [pxx,f]=pwelch(data_temp,[],[],Fs,Fs);
        
        %nomralize PSD
        pxx=pxx/(sum(pxx)*f(end));
        
        %compute alpha and beta powers [note that f(1)=0Hz]
        alpha=sum(pxx((8+1):(12+1)))*(12-8);
        beta=sum(pxx((13+1):(31+1)))*(30-13);
        
        feature_temp=beta/alpha;
        
        if isnan(feature_temp)
            feature_temp=0;
        end
        
        feature=[feature,feature_temp];
        
    end
    
    feature_def(i,:)=feature;
end

feature_name=strings(1,size(feature_def,2));

for i=1:n_chan
    feature_name(i)=string(data_struct.channels(i));
end
        
table.table=feature_def;
table.class=class_vec;
table.var_name=subject_vec;
table.feat_name=feature_name;

end
