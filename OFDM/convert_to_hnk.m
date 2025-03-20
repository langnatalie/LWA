function [hnk] = convert_to_hnk(h_matrix,col_indicators)
    row = 1:size(h_matrix,1);
    col = col_indicators;
    sz = [size(h_matrix,1) size(h_matrix,2)];

    ind = sub2ind(sz,row,col);
    hnk = h_matrix(ind)';
end