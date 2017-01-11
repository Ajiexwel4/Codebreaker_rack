function disableRefreshPage(e) { 
  if (e.key === 'F5' || e.keyCode == 116 || // F5 or CTRL+F5
  (e.key === 'r' || e.key === 'R' || e.keyCode == 82) && e.ctrlKey // CTRL+R
  )
  e.preventDefault();
};

$(document).on("keydown", disableRefreshPage);