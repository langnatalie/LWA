function [R] = fitnessFunction(indicators, W, P, h, sigma2)
    hnk = convert_to_hnk(h,indicators);
    h_norm_square = hnk.^2;
    R = s_fGetRAte(W, h_norm_square, P, sigma2);

    % Since GA minimizes by default, return negative R for maximization
    R = -R;
end