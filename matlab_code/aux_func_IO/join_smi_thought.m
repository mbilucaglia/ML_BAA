function [data_out] = join_smi_thought(filepath_smi,filepath_thought)

addpath('./aux_func_IO/');

data_out=struct();

%==== smi data ====
format_head=strcat(repmat('%s',1,12));
fid=fopen(filepath_smi,'r');
smi_data_raw=textscan(fid,format_head,'Delimiter','\t','HeaderLines',0);
fclose(fid);

%stimoli
stim=smi_data_raw{1,4}(6:end)';

%segnale eye tracker
eye_tracker=str2doubles(smi_data_raw{1,7}(6:end))';

%indicatori EEG - MOLTO LENTI: da velocizzare!
eeg_eng=str2doubles(smi_data_raw{1,8}(6:end))';
eeg_exc_long=str2doubles(smi_data_raw{1,9}(6:end))';
eeg_ext_short=str2doubles(smi_data_raw{1,10}(6:end))';
eeg_frustr=str2doubles(smi_data_raw{1,11}(6:end))';
eeg_medit=str2doubles(smi_data_raw{1,12}(6:end))';

smi_data_matrix=[eye_tracker; eeg_eng; eeg_exc_long; eeg_ext_short; eeg_frustr; eeg_medit];

%==== thoght data ====
format_head=strcat(repmat('%s',1,3));
fid=fopen(filepath_thought);
tought_data_raw=textscan(fid,format_head,'Delimiter',',','HeaderLines',0);
fclose(fid);


skin=str2doubles(tought_data_raw{1,2}(7:end))';

%=== pulizia degli stimoli ===
sync=str2doubles(tought_data_raw{1,3}(7:end))';
med_point=mean(sync);
sync(sync>=med_point)=1;
sync(sync<med_point)=0;

[~, pos]=onset_clean(sync);

%pos(1) corrisponde al primo campione in cui c'è RichText2.rtf
index = strfind(stim,'RichText2.rtf');
index = (find(not(cellfun('isempty', index))));

%smi_data_matrix(:,index) è da allineare con skin(pos(1))
point_smi=index(1);
point_skin=pos(1);

[data_matrix,index1,~]=allign_crop(smi_data_matrix,skin,point_smi,point_skin);

chans={'Eye-tracker','EEG Engagement','EEG Excitment (Long)','EEG Excitement Short','EEG Frrustration','EEG Meditation','Skin'};

stim=stim(index1(1):index1(2));

[id_event,pos_event]=onset_clean_string(stim);


Fs= str2doubles(smi_data_raw{1,2}(3));



data_out.path{1,1}=filepath_smi;
data_out.path{2,1}=filepath_thought;

data_out.subject=smi_data_raw{1,1}{3,1};

%data_out.date=date_string; %TODO

data_out.Fs=Fs;

data_out.electrodes=chans;

data_out.electrodes_type=[];

data_out.unit=[];

data_out.data=data_matrix;

data_out.event_id=id_event;

data_out.event_pos=pos_event;


end

