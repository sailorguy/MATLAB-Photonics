function h = drawRect ( origin, size, transparency, color, EdgeAlpha)
 %This function draws a rectangular prisim, taking arguments of origin,
 %size, transparency and color (RGB triple)
 
 %To avoid overlapping patches on adjacent cubes, draw cube slightly
 %smaller than requested
 size = size*.99;
 
x=([0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]-0.5)*size(1)+origin(1);
y=([0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]-0.5)*size(2)+origin(2);
z=([0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]-0.5)*size(3)+origin(3);
for i=1:6
 h=patch(x(:,i),y(:,i),z(:,i),'w');
 set(h,'FaceColor',color, 'EdgeColor', color, 'FaceAlpha', transparency, 'EdgeAlpha', EdgeAlpha)
 alpha(h,transparency)
end