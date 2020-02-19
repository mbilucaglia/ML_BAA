function [crossval_table] = crossval_2class(table_struct,n_rep)

addpath('.\aux_func_IO');

thresh=0.95;

feat_name=table_struct.feat_name;
table=table_struct.table;
class=table_struct.class;

n_fold=10;

acc_lda_final=zeros(n_rep,1);
acc_svm_final=zeros(n_rep,1);
acc_knn_final=zeros(n_rep,1);
acc_zero_final=zeros(n_rep,1);
acc_random_final=zeros(n_rep,1);

for k=1:n_rep

    id_cross=crossvalind('Kfold',cellstr(table_struct.class),n_fold);

    acc_lda=zeros(n_fold,1);
    acc_svm=zeros(n_fold,1);
    acc_knn=zeros(n_fold,1);
    
    acc_zero=zeros(n_fold,1);
    acc_random=zeros(n_fold,1);

    for i=1:n_fold
        
        train=table(find(id_cross~=i),:);
        test=table(find(id_cross==i),:);
        
        class_train=class(find(id_cross~=i));
        class_train_unique=unique(class_train);
        class_test=class(find(id_cross==i));

        id_sel=feat_sel_BISERIAL_mat(train,class_train,thresh);

        train_red=train(:,id_sel);

        test_red=test(:,id_sel);

        %linear discriminat analysis
        Mdl_lda = fitcdiscr(train_red,class_train,'discrimType','pseudolinear');
        output=predict(Mdl_lda,test_red);
        
        %SVM
        Mdl_svm= fitcsvm(train_red,class_train,'KernelFunction','rbf');
        output_svm=predict(Mdl_svm,test_red);
        
        %KNN
        Mdl_knn=fitcknn(train_red,class_train);
        output_knn=predict(Mdl_knn,test_red);

        %zeroR classifer
        class_pred=mode(categorical(class_train));
        output2=repmat(string(class_pred),numel(class_test),1);

        %random classifer
        output3=randi([1 2],numel(class_test),1);
        output3=class_train_unique(output3);

        acc_lda(i)=sum(eq(class_test,output))/numel(class_test);
        acc_svm(i)=sum(eq(class_test,output_svm))/numel(class_test);
        acc_knn(i)=sum(eq(class_test,output_knn))/numel(class_test);
        
        acc_zero(i)=sum(eq(class_test,output2))/numel(class_test);
        acc_random(i)=sum(eq(class_test,output3))/numel(class_test);

        n(i)=numel(id_sel);

    end
    
    acc_lda_final(k)=mean(acc_lda);
    acc_svm_final(k)=mean(acc_svm);
    acc_knn_final(k)=mean(acc_knn);
    
    acc_zero_final(k)=mean(acc_zero);
    acc_random_final(k)=mean(acc_random);
    
end

%Using the whole training data
[id_sel,~,r]=feat_sel_BISERIAL_mat(table,class,thresh);
chans=feat_name(id_sel);

%==========================================================================
%Clean the feature string
chans_clean=eraseBetween(chans,'@',']');
chans_clean=regexprep(chans_clean,'@','');
chans_clean=regexprep(chans_clean,']','');
chans_clean=regexprep(chans_clean,' ','');

chans_unique=unique(chans_clean);
n_chans=numel(chans_unique);

r_sum=sum(r);

for i=1:n_chans
    chan_temp=chans_unique(i);
    pos_temp=find(chans_clean==chan_temp);
    
    chan_list=chans_clean(pos_temp);
    r_list=r(pos_temp);
    
    feat_all.chan(i)=chan_temp;
    feat_all.r(i)=(sum(r_list)/r_sum)*100;

end

EEG=pop_importdata('data',feat_all.r');

locs=struct('labels',cellstr(feat_all.chan'));
EEG.chanlocs=locs;
file_locs='.\aux_func_IO\GSN-HydroCel-128.sfp';
EEG=pop_chanedit(EEG,'lookup',file_locs);

topoplot(feat_all.r',EEG.chanlocs);
cbar('vert',0,[min(feat_all.r),max(feat_all.r)]);
set(gca,'FontSize',16) 
title('r^{2}');


crossval_table=[acc_lda_final, acc_svm_final, acc_knn_final, acc_zero_final, acc_random_final];


% %==========================================================================
% r_sum=sum(r);
% 
% feat_all.chan=table_struct.feat_name(id_sel);
% feat_all.r=(r/r_sum)*100;
% 
% EEG=pop_importdata('data',feat_all.r');
% 
% locs=struct('labels',cellstr(table_struct.feat_name));
% EEG.chanlocs=locs;
% 
% EEG=pop_chanedit(EEG,'lookup',file_locs);
% 
% topoplot(feat_all.r',EEG.chanlocs,'verbose','off','electrodes','off',...
%     'style','both','headrad',0.5,'whitebk','on');
% cbar('vert',0,[min(feat_all.r),max(feat_all.r)]);
% set(gca,'FontSize',16) 
% title('r^{2}');
% 
end
