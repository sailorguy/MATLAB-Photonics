function setupPopup(handle, choice, options)

      %Set elment type list
      set(handle, 'String', options);
      
      %Get index for current selection, set the popup
      [~, i] = ismember(choice, options);
      set(handle, 'Value', i);

end