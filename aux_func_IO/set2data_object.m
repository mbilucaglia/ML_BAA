function [data_object] = set2data_object()

addpath('.\aux_func_IO');

if nargin<1
    dir=[];
end

if ~isempty(dir)
    [name_data_m,dir_source,ack]=uigetfile([dir,'*.set'],'MultiSelect','on','Select Source Files');
else
    [name_data_m,dir_source,ack]=uigetfile('*.set','MultiSelect','on','Select Source Files');
end

if ack~=1
    return
end

if ~iscell(name_data_m)
    h_warn=warndlg('Warning! You selectred ony one file!','Warning!');
    uiwait(h_warn);
    name_data_m=cellstr(name_data_m);
end

[~,n_files]=size(name_data_m);

location=cell(1,n_files);

for i=1:n_files
    location{i}=sprintf('%s%s',dir_source,name_data_m{i});
end

data_object = fileDatastore(location,'ReadFcn',@set2struct);

end

