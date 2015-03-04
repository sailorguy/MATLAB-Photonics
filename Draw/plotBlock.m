function h=plotBlock(object,transparency,color, EdgeAlpha)
%This function plots a block on the current axis, extracting the required
%data and calling draw rect

%Get size of block
      size = object.size;

      %Get origin of block
      origin = object.center;
      
      %Draw block
      h = drawRect(origin,size,transparency,color,EdgeAlpha);
      
end