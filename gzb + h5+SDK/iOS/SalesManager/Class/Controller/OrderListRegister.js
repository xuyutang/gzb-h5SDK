
window.onerror = function(err) {
    alert(err);
}

function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}
setupWebViewJavascriptBridge(function(js) {
		var uniqueId = 1
		
		js.init(function(message, responseCallback) {
			
		})
		js.registerHandler('testJavascriptHandler', function(data, responseCallback) {
			 // var responseData = { 'Javascript Says':'Right back atcha!' }
			 alert(JSON.stringify(data));
			// responseCallback(responseData);
			alert('回来了。');
		})

		$('.order .order-box h1 a').each(function(i,o){
			$(o).click(function(){
				js.callHandler('testJavascriptHandler',$(o).attr('href'),function(response){});
				return false;
			});
		});

		// $('.order .order-box h1 a').click(function(){
		// 	var data = $(self).attr('href');
		// 	alert(data);
		// 	js.callHandler('testJavascriptHandler',data ,function(response){

		// 	});
		// 	return false;
		// });
	})