function y = str2doubles (cs)
%STR2DOUBLES:  Faster alternative to builtin str2double

    if ischar(cs),  y = str2double(cs);  return;  end
    cs = regexprep(cs, '-(?!\d)','NaN' ); %relplace "-" when is not the "minus" sign
    siz = size(cs);
    cs = cs(:);
    cs = deblank(cs);  % (it changes the shpe of 3d input)    
    idx = ~cellfun(@isempty, cs);
    cs2 = cs(idx);
    y2 = sscanf(sprintf('%s#', cs2{:}), '%g#');  % faster
    %y2 = cellfun(@(csi) sscanf(csi, '%g#'), cs2);  % slower
    y = NaN(siz);
    y(idx) = y2;
end
