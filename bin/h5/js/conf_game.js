/**
*服务端数据
*/
var serverObj = new Object;

//服务端的访问端口
serverObj.serverPort = 11111;
serverObj.key = "my9yu_test";
serverObj.sn = 1;

serverObj.serverIpArr ="192.168.57.16_朝辉,192.168.57.27_罗杰,192.168.57.21_黄炜,192.168.57.25_正龙,192.168.56.155_测试服,192.168.56.207_验收服,192.168.130.45_外网体验";


/**
 * 运营商网址参数
*/
var agentsObj = new Object;
agentsObj.webTitle="idleHero";
agentsObj.agent = 11;
agentsObj.debug = true;


/**
 * CDN
*/
var cndObj = new Object;
//cndObj.root= "http://192.168.10.223:8080/";	//图片加载的域名。
cndObj.root= "";


/**
 * 录像地址
*/
var recordObj = new Object;
recordObj.tower = "http://192.168.56.155/reports"
recordObj.arena = "http://192.168.56.155/reports/AREA/"

/**
 * 隐私政策地址
*/
var privacyURL = "http://linkworldent.com/privacy/";
var googlePlayIdleURL = "market://details?id=";

function toLogin(param){
	if(sdkObj&&sdkObj.toLogin){
		sdkObj.toLogin(param);
	}
}

function toLoginView(){
	if(sdkObj&&sdkObj.toLoginView){
		sdkObj.toLoginView();
	}
}

function platformToGame(param){
	if(sdkObj&&sdkObj.platformToGame){
		sdkObj.platformToGame(param);
	}
}

function getGameServerConfig() {
	return serverObj;
}

function getGameAgentsConfig() {
	return agentsObj;
}

function getRecordConfig(){
	return recordObj;
}

function androidLog(val){
	console.log(val);
}

//cdn目录，空字符代表原路径
function getGameCdnConfig() {
	return cndObj;
}

var functionObj={}
function addNewFunction(nameStr,strs){
	 functionObj[nameStr] = new Function(strs);
}

function useNewFunction(nameStr,strs){
	return functionObj[nameStr].apply(strs);
}

function callAsFun(codeStr)
{
	eval(codeStr);
}

function getPrivacyURL(){
	return privacyURL;
}

function getGGPURL(){
	return googlePlayIdleURL;
}

/**
 * 推广地址
*/
var promotionURL = "https://www.facebook.com/LegacyofgodEN/";
function getPromotionURL(){
	return promotionURL;
}




