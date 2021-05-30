function [x_max, x_min, x_ticks] = get_axis(med, des, ticks)

max_med = max(med);
min_med = min(med);

max_des = max(des);
min_des = min(des);

if max_med >= max_des
    x_max = max_med;
else
    x_max = max_des;
end

if min_med <= min_des
    if min_med < 0
        x_min = min_med;
    else
        x_min = min_med;
    end
else
    if min_des < 0
        x_min = min_des;
    else
        x_min = min_des;
    end
end

delta = x_max - x_min;
x_max = x_max + 0.05*delta;
x_min = x_min - 0.05*delta;
x_ticks = x_min : (x_max-x_min)/ticks : x_max;
%x_ticks = round(x_ticks);

end

