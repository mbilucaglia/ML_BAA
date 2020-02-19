function [data] = row_ceck(data_in)

if (ndims(data_in))>2
        error('\nError! Input data must be a vector!\n');
end

[r_in,c_in]=size(data_in);
        
if (r_in==1 && c_in==1)
        error('\nError! Input data cannot be a scalar!\n');
           
elseif (r_in<c_in)
       data=data_in;
        
else 
       data=data_in';
               
end

end