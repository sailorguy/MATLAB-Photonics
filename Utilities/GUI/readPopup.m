function choice = readPopup(handle)

options = get(handle, 'String');

choice = char(options{get(handle, 'Value')});

end