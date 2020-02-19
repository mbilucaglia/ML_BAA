function [str_out] = str_clean (str)

str_out=regexprep(str,'\W','');

if (isstrprop(str_out(1),'digit'))
    str_out=strcat('n',str_out);
end

end