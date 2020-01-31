function [id_out,pos_out] = onset_clean (id_in)

nonstim=0;
id_in=row_ceck(id_in);
l=length(id_in);
id_out=zeros(1,l);

for i=2:l-1
    if (id_in(i+1)~=nonstim) && (id_in(i-1)==nonstim)
        id_out(i)=id_in(i);
    end
end

pos_out=find(id_out~=nonstim);
id_out=id_out(id_out~=0);


end