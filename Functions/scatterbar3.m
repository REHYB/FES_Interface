function scatterbar3(X,Y,Z1,Z2,width,color)
%SCATTERBAR3   3-D scatter bar graph.
%   SCATTERBAR3(X,Y,Z1,WIDTH) draws 3-D bars of height Z1 at locations X and Y with width WIDTH.
%
%   X, Y and Z1 must be of equal size.  If they are vectors, than bars are placed
%   in the same fashion as the SCATTER3 or PLOT3 functions.
%
%   If they are matrices, then bars are placed in the same fashion as the SURF
%   and MESH functions.
%
%   The colors of each bar read from the figure's colormap according to the bar's height.
%
%   NOTE:  For best results, you should use the 'zbuffer' renderer.  To set the current
%   figure renderer to 'zbuffer' use the following command:
%
%       set(gcf,'renderer','zbuffer')
%
%    % EXAMPLE 1:
%    y=[1 2 3 1 2 3 1 2 3];
%    x=[1 1 1 2 2 2 3 3 3];
%    z=[1 2 3 6 5 4 7 8 9];
%    scatterbar3(x,y,z,1)
%    colorbar
%
%    % EXAMPLE 2:
%    [X,Y]=meshgrid(-1:0.25:1);
%    Z1=2-(X.^2+Y.^2);
%    scatterbar3(X,Y,Z1,0.2)
%    colormap(hsv)
%
%    % EXAMPLE 3:
%    t=0:0.1:(2*pi);
%    x=cos(t);
%    y=sin(t);
%    z=sin(t);
%    scatterbar3(x,y,z,0.07)
% By Mickey Stahl - 2/25/02
% Engineering Development Group
% Aspiring Developer
z0=4;
[r,c]=size(Z1);
for j=1:r,
    for k=1:c,
        if ~isnan(Z1(j,k))
            drawbar(X(j,k),Y(j,k),Z1(j,k),Z2(j,k),width/2,color(j,k))
        end
    end
end
zlim=[min(Z1(:)) max(Z2(:))];
if zlim(1)>0,zlim(1)=0;end
if zlim(2)<0,zlim(2)=0;end
% axis([min(X(:))-width/2 max(X(:))+width/2 min(Y(:))-width/2 max(Y(:))+width/2 zlim])
% caxis([min(Z1(:)) max(Z1(:))])
function drawbar(x,y,z,z2,width,c)
z0=z2-z;
if strcmp(c,'e')==0
    h(1)=patch([-width -width width width]+x,[-width width width -width]+y,[0 0 0 0]+z,c);
    h(2)=patch(width.*[-1 -1 1 1]+x,width.*[-1 -1 -1 -1]+y,z0.*[0 1 1 0]+z,c);
    h(3)=patch(width.*[-1 -1 -1 -1]+x,width.*[-1 -1 1 1]+y,z0.*[0 1 1 0]+z,c);
    h(4)=patch([-width -width width width]+x,[-width width width -width]+y,[z0 z0 z0 z0]+z,c);
    h(5)=patch(width.*[-1 -1 1 1]+x,width.*[1 1 1 1]+y,z0.*[0 1 1 0]+z,c);
    h(6)=patch(width.*[1 1 1 1]+x,width.*[-1 -1 1 1]+y,z0.*[0 1 1 0]+z,c);
else
    h(1)=patch([-width -width width width]+x,[-width width width -width]+y,[0 0 0 0]+z, [0.7 0.7 0.7]);
    h(2)=patch(width.*[-1 -1 1 1]+x,width.*[-1 -1 -1 -1]+y,z0.*[0 1 1 0]+z,[0.7 0.7 0.7]);
    h(3)=patch(width.*[-1 -1 -1 -1]+x,width.*[-1 -1 1 1]+y,z0.*[0 1 1 0]+z, [0.7 0.7 0.7]);
    h(4)=patch([-width -width width width]+x,[-width width width -width]+y,[z0 z0 z0 z0]+z, [0.7 0.7 0.7]);
    h(5)=patch(width.*[-1 -1 1 1]+x,width.*[1 1 1 1]+y,z0.*[0 1 1 0]+z, [0.7 0.7 0.7]);
    h(6)=patch(width.*[1 1 1 1]+x,width.*[-1 -1 1 1]+y,z0.*[0 1 1 0]+z,  [0.7 0.7 0.7]);
    
end
% set(h,'facecolor','flat','FaceVertexCData',z)
