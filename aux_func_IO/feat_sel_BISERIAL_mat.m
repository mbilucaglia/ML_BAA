function [id_sel,table_out,r] = feat_sel_BISERIAL_mat(table_in,class,thresh)

if nargin<2
    thresh=0.75;
end

%first column of <table_in> is the class column 
class_vec=class;

table_mat=table_in;

classes=unique(class_vec);
n_class=numel(classes);

if n_class~=2
    error('Error! This feature selection works only with 2 classes!');
end

n_feat=size(table_mat,2);

r=zeros(1,n_feat);

for i=1:n_feat
    feat_temp=table_mat(:,i);
    
    X_plus=feat_temp(class_vec==classes(1));
    X_minus=feat_temp(class_vec==classes(2));
    
    N_plus=numel(X_plus);
    N_minus=numel(X_minus);
    
    r(i)=(sqrt(N_plus*N_minus)/(N_plus+N_minus))*...
        ((mean(X_minus)-mean(X_plus))/(std(feat_temp)));
    r(i)=r(i)^2;
    
    if isnan(r(i))
        r(i)=0;
    end
    
end



[r, id_sort]=sort(r,'descend');
r_tot=sum(r);
r_cum=cumsum(r);

pos_th=find(r_cum>=thresh*r_tot,1);
id_sel=id_sort(1:pos_th);

table_out=[class_vec, table_mat(:,id_sel)];

end

