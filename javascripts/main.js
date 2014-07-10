var ua = navigator.userAgent.toLowerCase();
var check = function(r) {
    return r.test(ua);
};
var DOC = document;
var isStrict = DOC.compatMode == "CSS1Compat";
var isOpera = check(/opera/);
var isChrome = check(/chrome/);
var isWebKit = check(/webkit/);
var isSafari = !isChrome && check(/safari/);
var isSafari2 = isSafari && check(/applewebkit\/4/); // unique to
// Safari 2
var isSafari3 = isSafari && check(/version\/3/);
var isSafari4 = isSafari && check(/version\/4/);
var isIE = !isOpera && check(/msie/);
var isIE7 = isIE && check(/msie 7/);
var isIE8 = isIE && check(/msie 8/);
var isIE6 = isIE && !isIE7 && !isIE8;
var isGecko = !isWebKit && check(/gecko/);
var isGecko2 = isGecko && check(/rv:1\.8/);
var isGecko3 = isGecko && check(/rv:1\.9/);
var isBorderBox = isIE && !isStrict;
var isWindows = check(/windows|win32/);
var isMac = check(/macintosh|mac os x/);
var isAir = check(/adobeair/);
var isLinux = check(/linux/);
var isSecure = /^https/i.test(window.location.protocol);
var isIE7InIE8 = isIE7 && DOC.documentMode == 7;

var jsType = '', browserType = '', browserVersion = '', osName = '';
var ua = navigator.userAgent.toLowerCase();
var check = function(r) {
    return r.test(ua);
};

if(isWindows){
    osName = 'Windows';

    if(check(/windows nt/)){
        var start = ua.indexOf('windows nt');
        var end = ua.indexOf(';', start);
        osName = ua.substring(start, end);
    }
} else {
    osName = isMac ? 'Mac' : isLinux ? 'Linux' : 'Other';
} 

if(isIE){
    browserType = 'IE';
    jsType = 'IE';

    var versionStart = ua.indexOf('msie') + 5;
    var versionEnd = ua.indexOf(';', versionStart);
    browserVersion = ua.substring(versionStart, versionEnd);

    jsType = isIE6 ? 'IE6' : isIE7 ? 'IE7' : isIE8 ? 'IE8' : 'IE';
} else if (isGecko){
    var isFF =  check(/firefox/);
    browserType = isFF ? 'Firefox' : 'Others';;
    jsType = isGecko2 ? 'Gecko2' : isGecko3 ? 'Gecko3' : 'Gecko';

    if(isFF){
        var versionStart = ua.indexOf('firefox') + 8;
        var versionEnd = ua.indexOf(' ', versionStart);
        if(versionEnd == -1){
            versionEnd = ua.length;
        }
        browserVersion = ua.substring(versionStart, versionEnd);
    }
} else if(isChrome){
    browserType = 'Chrome';
    jsType = isWebKit ? 'Web Kit' : 'Other';

    var versionStart = ua.indexOf('chrome') + 7;
    var versionEnd = ua.indexOf(' ', versionStart);
    browserVersion = ua.substring(versionStart, versionEnd);
}else{
    browserType = isOpera ? 'Opera' : isSafari ? 'Safari' : '';
}
