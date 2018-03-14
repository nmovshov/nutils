%% mice - an experiment (in behavioral science?)

clear all
close all
clc
%% --- Setup phase ---
% An array of four "mice" objects, with fields for position and velocity,
% both 2D vectors
mouse(1).position=[0 0];
mouse(2).position=[1 0];
mouse(3).position=[1 1];
mouse(4).position=[0 1];
mouse(1).velocity=[0 0];
mouse(2).velocity=[0 0];
mouse(3).velocity=[0 0];
mouse(4).velocity=[0 0];
% The ploting ground
axis([0 1 0 1]);
set(gca,'xtick',[],'ytick',[],'ycolor','w','xcolor','w')
hold on
m1=plot(mouse(1).position(1),mouse(1).position(2),'.b');
m2=plot(mouse(2).position(1),mouse(2).position(2),'.r');
m3=plot(mouse(3).position(1),mouse(3).position(2),'.g');
m4=plot(mouse(4).position(1),mouse(4).position(2),'.y');
m=[m1 m2 m3 m4];
set(m,'erasemode','none','markersize',6)

%% Make them run
safety=0;
while norm(mouse(1).position-mouse(2).position)>0.01
    mouse(1).velocity=(mouse(2).position-mouse(1).position)/...
        norm(mouse(2).position-mouse(1).position);
    mouse(2).velocity=(mouse(3).position-mouse(2).position)/...
        norm(mouse(3).position-mouse(2).position);
    mouse(3).velocity=(mouse(4).position-mouse(3).position)/...
        norm(mouse(4).position-mouse(3).position);
     mouse(4).velocity=(mouse(1).position-mouse(4).position)/...
        norm(mouse(1).position-mouse(4).position);
    for k=1:4
        mouse(k).position=mouse(k).position+0.01*mouse(k).velocity;
        set(m(k),'xdata',mouse(k).position(1),...
            'ydata',mouse(k).position(2));
    end
    drawnow
    pause(0.01)
    safety=safety+1;
    if safety>1000
        beep
        break
    end
end