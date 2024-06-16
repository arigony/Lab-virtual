onClipEvent (load){

	this.loadVariables("link.txt");
	scrolling = 0;
	frameCounter = 1;
	speedFactor = 3;
	numLines = 7;
	resetOnNewFile = true;

	origHeight = scrollbar._height;
	origX = scrollbar._x;
	
	refreshRate = 12;
	refreshCounter = 0;
	refreshlastMaxscroll = 0;
	loaded = false;

	function refreshScrollBar(){
	
		daTextBox.scroll = resetOnNewFile ? 1 : Math.min(daTextBox.maxscroll, daTextBox.scroll);
		
		var totalLines = numLines + daTextBox.maxscroll - 1;
		scrollbar._yscale = 100*(numLines)/totalLines;
		deltaHeight = origHeight - scrollbar._height;
		lineHeight = deltaHeight/(daTextBox.maxScroll - 1);	
		scrollbar._y = lineHeight*(daTextBox.scroll - 1);
		
	}
	
	function updateScrollBarPos(){

		scrollbar._y = lineHeight*(daTextBox.scroll - 1);
	}
}

onClipEvent (enterFrame){

	if( loaded ){
	
		if(refreshCounter % refreshRate == 0 && daTextBox.maxscroll != refreshLastMaxScroll){
		
			refreshScrollBar();
			refreshLastMaxScroll = daTextBox.maxscroll;
			refreshCounter = 0;
			
		}
		refreshCounter++;
	}
	
	if( frameCounter % speedFactor == 0){
	
		if( scrolling == "up" && daTextBox.scroll > 1){
			daTextBox.scroll--;
			updateScrollBarPos();
		}
		else if( scrolling == "down" && daTextBox.scroll < daTextBox.maxscroll){
			daTextBox.scroll++;
			updateScrollBarPos();
		}
		frameCounter = 0;
	}
	frameCounter++;
}

onClipEvent (mouseDown){

	if(up.hitTest(_root._xmouse,_root._ymouse)){
		scrolling = "up";
		frameCounter = speedFactor;
		up.gotoAndStop(2);
	}
	if(down.hitTest(_root._xmouse,_root._ymouse)){
		scrolling = "down";
		frameCounter = speedFactor;
		down.gotoAndStop(2);
	}
	if(scrollbar.hitTest(_root._xmouse,_root._ymouse)){
		scrollbar.startDrag(0,origX,deltaHeight,origX);
		scrolling = "scrollbar";
	}
	updateAfterEvent();
}

onClipEvent (mouseUp){

	scrolling = 0;
	up.gotoAndStop(1);
	down.gotoAndStop(1);
	stopDrag();

	updateAfterEvent();
}

onClipEvent (mouseMove){
	if(scrolling == "scrollbar"){
		daTextBox.scroll = Math.round((scrollbar._y)/lineHeight + 1);
	}
	updateAfterEvent();
}

onClipEvent (data){
	loaded = true;
}