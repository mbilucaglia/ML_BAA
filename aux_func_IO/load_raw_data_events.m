function [data_out,filename] = load_raw_data_events(filename)

data_out=struct();


header=ft_read_header(filename,'headerformat', 'egi_mff_v2');
data=ft_read_data(filename,'headerformat', 'egi_mff_v2', 'dataformat', 'egi_mff_v2');
event=ft_read_event(filename);

[~,n_samples]=size(data);

id_event=[event.value];
pos_event=[event.sample];

%ceck on indices
id_temp=find(pos_event>n_samples);

if ~isempty(id_temp)
    pos_event(id_temp)=[];
    id_event(id_temp)=[];
end

data_out_name=sprintf('%s. %s.',header.orig.name(1:10),header.orig.surname(1:10));
data_out_name=data_out_name(~isspace(data_out_name));

date_string=sprintf('%s-%s-%s',header.orig.day,header.orig.month,header.orig.year);
%[Year,Month,Day]=datevec(date_string);

%general info
data_out.subject=data_out_name;
data_out.date=date_string;
%data_out.time=
data_out.Fs=header.Fs;

data_out.electrodes=header.label;

data_out.electrodes_type=header.chantype;

data_out.unit=header.chanunit;

data_out.data=data;

data_out.event_id=id_event;

data_out.event_pos=pos_event;

[~,filename] = fileparts(filename);

end

function [str_out] = str_clean (str)

str_out=regexprep(str,'\W','');

if (isstrprop(str_out(1),'digit'))
    str_out=strcat('n',str_out);
end

end