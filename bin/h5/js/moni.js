startLoadingMoni();
var _loadingMoniT;
var _loadingMoniMax;
function startLoadingMoni(){
	if(window&&window.loadingView){
		window.loadingView.loadingAutoClose = false;
	}
	_loadingMoniMax =5;
	_loadingMoniT = window.setInterval(refreshCount,500);
}

function refreshCount(){
	if(window&&window.loadingView){
		console.log("intochange loadingView"+_loadingMoniMax);
		if(_loadingMoniMax<90){
			_loadingMoniMax+=5;
		}
		window.loadingView.loading(_loadingMoniMax+5);
	}else{
		endLoadingMoni();
	}
}

function endLoadingMoni(){
	if(_loadingMoniT){
		window.clearInterval(_loadingMoniT);
		_loadingMoniT = null;
	}
}
