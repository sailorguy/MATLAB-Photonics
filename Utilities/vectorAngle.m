function theta = vectorAngle(a,b)


%Use four-quadrant inverse tangent to avoid accuracy errors when vectors
%approach parallel
 theta = atan2(norm(cross(a,b)),dot(a,b));


end