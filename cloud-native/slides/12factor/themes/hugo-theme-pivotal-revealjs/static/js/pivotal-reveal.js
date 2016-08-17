function addFragmentsToList(container) {
  var lists = $(container).find("ul");
	for ( var i = 0; i < lists.length; i++ ) {
		var items = $(lists[i]).children();
		for ( var j = 0; j < items.length; j++ ) {
			$(items[j]).addClass("fragment");
		}
	}
}
