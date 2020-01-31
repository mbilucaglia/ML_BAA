function [vec_out] = extract_numbers_string(str_in)

[r,c]=size(str_in);
vec_out=NaN(r,c);

for i=1:r
    for j=1:c
        vec_out(i,j)=str2double(regexp(str_in{i,j},'\d*','match'));
        
    end
end

end

