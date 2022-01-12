function [] = setob2(lambda, nd_one, nd_two)
%Set Filter Wheel Positions
%   Use this function to set the filter wheel positions on Bench 2.
%   It also updates the logging variables with the probe function.
probe_2()
setwl_2(lambda)
setnd1_2(nd_one)
setnd2_2(nd_two)
probe_2()
global f2
if isempty(f2)
    f2 = figure;
end
clf(f2)
ax1_2 = subplot(3,1,1);
ax2_2 = subplot(3,1,2);
ax3_2 = subplot(3,1,3);
global time_2 wavelength_2 nd1pos_2 nd2pos_2
plot(ax1_2,time_2,wavelength_2);
plot(ax2_2,time_2,nd1pos_2);
plot(ax3_2,time_2,nd2pos_2);
datetick(ax1_2,'x','HH:MM');
datetick(ax2_2,'x','HH:MM');
datetick(ax3_2,'x','HH:MM');
xlabel(ax3_2,'time');
ylabel(ax1_2,'wavelength');
ylabel(ax2_2,'nd1');
ylabel(ax3_2,'nd2');
end
