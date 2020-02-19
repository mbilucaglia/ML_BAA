function [data_joint,index1, index2] = allign_crop(data1, data2, point_data1, point_data2)

index1=zeros(1,2);
index2=zeros(1,2);

data1_raw=data1;
data2_raw=data2;

[~,samp1]=size(data1);
[~,samp2]=size(data2);

l_max=min(samp1-point_data1,samp2-point_data2);

if point_data1>point_data2 
    index1(1)=(point_data1-point_data2)+1; %new starting point for data1
    index2(1)=1;
else 
    index2(1)=(point_data2-point_data1)+1; %new starting point for data2
    index1(1)=1;
end

index1(2)=point_data1+l_max-1;
index2(2)=point_data2+l_max-1;

data_joint=[data1(:,index1(1):index1(2)); data2(:,index2(1):index2(2))];

end

