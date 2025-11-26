function [e2, e1, c50, c20, c10, c5] = estim_coins(measurement, bias, dark, flat)
    image = (measurement - bias - dark) ./ flat;
    [x_sc,y_sc] = geometry_calibration(image);

    e2 = 0;
    e1 = 0;
    c50 = 0;
    c20 = 0;
    c10 = 0;
    c5 = 0;
end