function [] = setob1(lambda, nd_one, nd_two)
%Set Filter Wheel Positions
%   Use this function to set the filter wheel positions. It also updates
%   the logging variables with the probe function.
probe()
setwl(lambda)
setnd1(nd_one)
setnd2(nd_two)
probe()
global f1
if isempty(f1)
    f1 = figure;
end
clf(f1)
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
global time wavelength nd1pos nd2pos
plot(ax1,time,wavelength);
plot(ax2,time,nd1pos);
plot(ax3,time,nd2pos);
datetick(ax1,'x','HH:MM');
datetick(ax2,'x','HH:MM');
datetick(ax3,'x','HH:MM');
xlabel(ax3,'time');
ylabel(ax1,'wavelength');
ylabel(ax2,'nd1');
ylabel(ax3,'nd2');
end
