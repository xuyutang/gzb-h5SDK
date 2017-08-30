document.addEventListener( "plusready",  function()
{
    var _BARCODE = 'plugintest',
		B = window.plus.bridge;
    var plugintest = 
    {
    	PluginTestFunction : function (Argus1, Argus2, Argus3, Argus4, successCallback, errorCallback ) 
		{
			var success = typeof successCallback !== 'function' ? null : function(args) 
			{
				successCallback(args);
			},
			fail = typeof errorCallback !== 'function' ? null : function(code) 
			{
				errorCallback(code);
			};
			callbackID = B.callbackId(success, fail);

			return B.exec(_BARCODE, "PluginTestFunction", [callbackID, Argus1, Argus2, Argus3, Argus4]);
		},     
		myTextAction:function(argus1,argus2) {
            return B.execSync(_BARCODE, "myTextAction", [argus1, argus2]);
			
		},
        PluginTestFunctionSync : function (Argus1, Argus2, Argus3, Argus4) 
        {                                	
            return B.execSync(_BARCODE, "PluginTestFunctionSync", [Argus1, Argus2, Argus3, Argus4]);
        },
                          
        PluginTestFunctionSyncArrayArgu : function (Argus) 
        {                                	
            return B.execSync(_BARCODE, "PluginTestFunctionSyncArrayArgu", [Argus]);
        },
        AuthenticateUser: function(successCallback, errorCallback)
        {
                          var success = typeof successCallback !== 'function' ? null : function(args)
                          {
                          successCallback(args);
                          },
                          fail = typeof errorCallback !== 'function' ? null : function(code)
                          {
                          errorCallback(code);
                          };
                          callbackID = B.callbackId(success, fail);
                          return B.exec(_BARCODE,"AuthenticateUser", [callbackID]);
        }
    };
    window.plus.plugintest = plugintest;
}, true );
