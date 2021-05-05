function [l1_x ,l1_dx, l1_ddx, l1_dddx, l2_x ,l2_dx, l2_ddx, l2_dddx] = normas(x, dx, ddx, dddx, t_start, t_step, t_end)

n = length(x);
% L1 norm 
l1_x    = sum(abs(   x(t_start:t_step:t_end)))/n;
l1_dx   = sum(abs(  dx(t_start:t_step:t_end)))/n;
l1_ddx  = sum(abs( ddx(t_start:t_step:t_end)))/n;
l1_dddx = sum(abs(dddx(t_start:t_step:t_end)))/n;

% L2 norm

l2_x      = sqrt(sum(power(   x(t_start:t_step:t_end),2)))/n;
l2_dx     = sqrt(sum(power(  dx(t_start:t_step:t_end),2)))/n;
l2_ddx    = sqrt(sum(power( ddx(t_start:t_step:t_end),2)))/n;
l2_dddx   = sqrt(sum(power(dddx(t_start:t_step:t_end),2)))/n;



end

