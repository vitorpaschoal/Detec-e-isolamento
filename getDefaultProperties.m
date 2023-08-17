function [defaultNames,defaultValues] = getDefaultProperties(mc)
%Given a classHandle, return just defaultValues
  %Returns only Default parameters
  [propArray,propArrayNames] = getProperties(mc);
  propDefault = cell2mat(cellfun(@(prop) prop.HasDefault,propArray,'UniformOutput',false));
  defaultpropArray = propArray(propDefault);
  
  defaultValues = cellfun(@(propNum) propNum.DefaultValue,...
      defaultpropArray,...
      'UniformOutput',false);
  
  defaultNames = propArrayNames(propDefault);
end