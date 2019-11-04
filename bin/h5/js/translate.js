function googleTranslate(param){
	var tk = translateToken(param.text);
	var data = {
		"client": "t",
		"sl": param.from,
		"tl": param.to,
		"hl": "zh-CN",
		"dt": "at",
		"dt": "bd",
		"dt": "ex",
		"dt": "ld",
		"dt": "md",
		"dt": "qca",
		"dt": "rw",
		"dt": "rm",
		"dt": "ss",
		"dt": "t",
		"ie": "UTF-8",
		"oe": "UTF-8",
		"source": "btn",
		"ssel": "0",
		"tsel": "0",
		"kc": "0",
		"tk": tk,
		"q": param.text
	};
	return "http://translate.google.com/translate_a/single?" + urlEncode(data);
}

var urlEncode = function (param, key, encode) {  
  if(param==null) return '';  
  var paramStr = '';  
  var t = typeof (param);  
  if (t == 'string' || t == 'number' || t == 'boolean') {  
    paramStr += '&' + key + '=' + ((encode==null||encode) ? encodeURIComponent(param) : param);  
  } else {  
    for (var i in param) {  
      var k = key == null ? i : key + (param instanceof Array ? '[' + i + ']' : '.' + i);  
      paramStr += urlEncode(param[i], k, encode);  
    }  
  }  
  return paramStr;  
}; 
 
//////////////////////////////////////////////////////////////////////////////////////////
 
function translateToken(a) {
    var k = "";
    var b = 406644;
    var b1 = 3293161072;

    var jd = ".";
    var sb = "+-a^+6";
    var Zb = "+-3^+b+-f";

    for (var e = [], f = 0, g = 0; g < a.length; g++) {
        var m = a.charCodeAt(g);
        128 > m ? e[f++] = m: (2048 > m ? e[f++] = m >> 6 | 192 : (55296 == (m & 64512) && g + 1 < a.length && 56320 == (a.charCodeAt(g + 1) & 64512) ? (m = 65536 + ((m & 1023) << 10) + (a.charCodeAt(++g) & 1023), e[f++] = m >> 18 | 240, e[f++] = m >> 12 & 63 | 128) : e[f++] = m >> 12 | 224, e[f++] = m >> 6 & 63 | 128), e[f++] = m & 63 | 128)
    }
    a = b;
    for (f = 0; f < e.length; f++) a += e[f],
    a = translateRL(a, sb);
    a = translateRL(a, Zb);
    a ^= b1 || 0;
    0 > a && (a = (a & 2147483647) + 2147483648);
    a %= 1E6;
    return a.toString() + jd + (a ^ b)
};

function translateRL(a, b) {
    var t = "a";
    var Yb = "+";
    for (var c = 0; c < b.length - 2; c += 3) {
        var d = b.charAt(c + 2),
        d = d >= t ? d.charCodeAt(0) - 87 : Number(d),
        d = b.charAt(c + 1) == Yb ? a >>> d: a << d;
        a = b.charAt(c) == Yb ? a + d & 4294967295 : a ^ d
    }
    return a
}