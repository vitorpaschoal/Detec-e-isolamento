function [propArray,propArrayNames] = getProperties(mc)
%Given a class handle, returns some properties
            
  %All properties in a cell array
  propArray = arrayfun(@(propNum) mc.PropertyList(propNum),...
      1:numel(mc.PropertyList),...
      'UniformOutput',false);
  
  %All the names
  propArrayNames = arrayfun(@(propNum) mc.PropertyList(propNum).Name,...
      1:numel(mc.PropertyList),...
      'UniformOutput',false);
 

end
