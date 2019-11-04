var updateObj = new Object;
updateObj.url = "http://www.baidu.com";

function toUpdateURL() {
	if(window.conch)
	{
		window.conch.setExternalLink(updateObj.url);
	}
}

var sdkObj = new Object;
sdkObj.idle_game_version = "1.0"
sdkObj.faq_email = "odyssey2018contact@gmail.com";
sdkObj.game_translate_enable = 1;
sdkObj.hallArds = 0;
sdkObj.forceUpdateVersionAndroid = "0";//Android强制更新的版本号1.0.13
sdkObj.forceUpdateVersionIOS = "0";//IOS强制更新的版本号

function getSdkObject(){
	return sdkObj;
}


var idleAdConfig = new Object;
idleAdConfig.androidAdStartVersion = "1.0.17"
idleAdConfig.iosAdStartVersion = "100.0"
idleAdConfig.adOpenSetting = {
							"1":{"Android":true, "IOS":false},
							"2":{"Android":true, "IOS":false},
							"3":{"Android":true, "IOS":false},
							"4":{"Android":true, "IOS":false}
							};//1签到,2钻石,3点券,4宝箱