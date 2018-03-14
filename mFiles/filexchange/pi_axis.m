function pi_axis(yaxis)
%PI_AXIS Q&D relabeling of x-axis in [0,pi] interval.
%   P_AXIS(yaxis) sets the y-axis of the current axes to yaxis, sets the x-axis
%   to [0,pi], and sets the x-axis ticks and tick labels to quarter-pi
%   intervals. The code snippet copied from Cleve's Corner.
   axis([0 pi yaxis])
   set(gca,'xtick',0:pi/4:pi, ...
       'xticklabels',{0 '\pi/4' '\pi/2' '3\pi/4' '\pi'})
end
