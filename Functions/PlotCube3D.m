%%
function PlotCube3D(position,theta,phi,surf_c)
global G
%%
% global G;
% clear all,close all,clc
% s3=subplot(2,2,1);
% G.r0=1;x=0.0;y=0.0;
% cube=[-0.5 -0.5 0.5 0.5 -0.5; -1 1 1 -1 -1; 1 1 1 1 1 ];
% G.h3 = plot(cube(1,:),cube(2,:));
% xlim(s3,[-2 2]);
% ylim(s3,[-2 2]);hold on
% axis equal;
%%
% figure(2);
% s5=subplot(2,2,4);
% a = -pi : pi/2 : pi;                                % Define Corners
% ph = pi/4;                                          % Define Angular Orientation (‘Phase’)
% position=[1;0.5;2];
% x = [cos(a+ph); cos(a+ph)]/cos(ph);
% y = [sin(a+ph); sin(a+ph)]/sin(ph) ;
% z = [-ones(size(a)); ones(size(a))] ;
x  =0.05*[-1    1    1   -1   -1];
y  =0.025*[-1   -1    1    1   -1];
z =0.1*[ 1     1     1     1     1];
surf1=[x;y;z];
surf2=[x;y;-z];

% Angle.theta=0*pi/180;
% Angle.phi=0*pi/180;

Rphi  = [1 0 0 ;0 cos(phi) sin(phi);0 -sin(phi) cos(phi)];
Rtheta= [cos(theta) 0 -sin(theta);0 1 0;sin(theta) 0 cos(theta)];
surf1_r=Rphi.'*Rtheta.'*surf1 + position;
surf2_r=Rphi.'*Rtheta.'*surf2 + position;

% rotate
if G.firstCube==1
    
    f3=figure(3);f3.Units='normalized';%f3.Position=[-1.1182    0.8250    0.3646    0.4861];
    f3.Position=[0.9974    0.7806    0.4141    0.5370];
    set(f3,'color','w');
    % f3=G.stext;
    %     G.Cube2=patch([1 -1 -1 1], [1 1 -1 -1], [0 0 0 0]-0.2, [0.5843 0.8157 0.9882]);    hold on;                            % Make Cube Appear Solid
    G.Cube2=patch([1 -1 -1 1], [1 1 -1 -1], [0 0 0 0]-0.1, [75 75 75]/255*2);    hold on;                              % Make Cube Appear Solid
    b=[1:2];G.Cube(1)=surf([surf1_r(1,b);surf2_r(1,b)], [surf1_r(2,b);surf2_r(2,b)], [surf1_r(3,b);surf2_r(3,b)], 'FaceColor',surf_c);
    
    b=[2:3];G.Cube(2)=surf([surf1_r(1,b);surf2_r(1,b)], [surf1_r(2,b);surf2_r(2,b)], [surf1_r(3,b);surf2_r(3,b)], 'FaceColor','g');
    b=[3:4];G.Cube(3)=surf([surf1_r(1,b);surf2_r(1,b)], [surf1_r(2,b);surf2_r(2,b)], [surf1_r(3,b);surf2_r(3,b)], 'FaceColor',surf_c);
    b=[4:5];G.Cube(4)=surf([surf1_r(1,b);surf2_r(1,b)], [surf1_r(2,b);surf2_r(2,b)], [surf1_r(3,b);surf2_r(3,b)], 'FaceColor','g');
    G.Cube(5)=patch([surf1_r(1,:);surf2_r(1,:)]', [surf1_r(2,:);surf2_r(2,:)]', [surf1_r(3,:);surf2_r(3,:)]', 'g');                              % Make Cube Appear Solid
    G.firstCube=0;
    hold off
    %     axis([ -1  1    -1  1    -1  1]*0.5);
    axis([ -1  1    -1  1    -0.4  1.6]*0.5);
    
    xlabel('z');ylabel('x');zlabel('y');
    view(-54,11);
    f3.Children.XTickLabel={};
    f3.Children.YTickLabel={};
    f3.Children.ZTickLabel={};
    grid on
    tt=text(-0.25,0.25,-0.05,'Table');
    tt.Units='normalized';
    tt.VerticalAlignment='bottom';
else
    b=[1:2];G.Cube(1).XData=[surf1_r(1,b);surf2_r(1,b)]; G.Cube(1).YData=[surf1_r(2,b);surf2_r(2,b)] ; G.Cube(1).ZData=[surf1_r(3,b);surf2_r(3,b)] ; G.Cube(1).FaceColor=surf_c;
    b=[2:3];G.Cube(2).XData=[surf1_r(1,b);surf2_r(1,b)]; G.Cube(2).YData=[surf1_r(2,b);surf2_r(2,b)] ; G.Cube(2).ZData=[surf1_r(3,b);surf2_r(3,b)] ;
    b=[3:4];G.Cube(3).XData=[surf1_r(1,b);surf2_r(1,b)]; G.Cube(3).YData=[surf1_r(2,b);surf2_r(2,b)] ; G.Cube(3).ZData=[surf1_r(3,b);surf2_r(3,b)] ; G.Cube(3).FaceColor=surf_c;
    b=[4:5];G.Cube(4).XData=[surf1_r(1,b);surf2_r(1,b)]; G.Cube(4).YData=[surf1_r(2,b);surf2_r(2,b)] ; G.Cube(4).ZData=[surf1_r(3,b);surf2_r(3,b)] ;
    G.Cube(5).XData=[surf1_r(1,:);surf2_r(1,:)]'       ; G.Cube(5).YData=[surf1_r(2,:);surf2_r(2,:)]'; G.Cube(5).ZData=[surf1_r(3,:);surf2_r(3,:)]';  % Make Cube Appear Solid
end
% b=[1:2];surf(x(:,b), y(:,b), z(:,b), 'FaceColor','k');
% hold on
% b=[2:3];surf(x(:,b), y(:,b), z(:,b), 'FaceColor','g');
% b=[3:4];surf(x(:,b), y(:,b), z(:,b), 'FaceColor','k');
% b=[4:5];surf(x(:,b), y(:,b), z(:,b), 'FaceColor','g');
% b=[3:4];surf(x(:,b), y(:,b), z(:,b), 'FaceColor','k');
% surf(x, y, z, 'FaceColor','k')                      % Plot Cube
% hold on
% patch(x', y', z', 'g')                              % Make Cube Appear Solid
% hold off
% axis([ -1  1    -1  1    -1  1]*0.5)
% grid on
% xlabel('z');ylabel('x');zlabel('y');
% view(-54,11);
end