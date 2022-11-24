  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
        } ;
      outputs =
        { flake-utils , self } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                lib =
		  {
		    bool ? false ,
		    float ? false		 ,
		    int ? false ,
		    lambda ? false ,
		    list ? false ,
		    path ? false ,
		    set ? false ,
		    string ? false ,
		    undefined ? false
		  } :
		    let
		      visitor =
		        value :
			  let
			    multiples =
			      in
			        {
			          list = if builtins.typeOf list != "lambda" then builtins.throw "a8be822f-1fbd-4c2e-bbbb-b175f7d1480b" else list ( builtins.map visitor value ) ;
			          set = if builtins.typeOf set != "lambda" then builtins.throw "5b99bcbd-ebe8-4926-9684-d49c02e3f631" else set ( builtins.mapAttr ( name : value : visitor value ) value ) ;
			        } ;
			    output =
			      if ! builtins.getAttr "success" builtins.tryEval ( visitor-fun value ) then builtins.throw "e154aef8-04a6-4fa0-9bec-a9f4771e2a24"
			      else visitor-fun value ;
			    singletons =
			      let
			        defined = { bool = bool ; float = float ; int = int ; lambda = lambda ; path = path ; string = string ; } ;
				mapper =
				  name : value :
				    if name != type then builtins.throw "5f38825e-4a6c-4480-a05d-89fadce728db"
				    else if builtins.typeOf value != "lambda" && builtins.typeOf undefined != "lambda" then builtins.throw "f7a4b8d7-be7e-4f4a-96f1-02fbababb09b"
				    else if builtins.typeOf value == "lambda" then value
				    else undefined ;
				in builtins.mapAttrs mapper defined ;
		            type = builtins.typeOf value ;
			    visitor-fun = if ! builtins.hasAttr type visitors then builtins.throw "e19d4085-c5cb-4cad-8c5b-e78b4b1aeb8e" else builtins.getAttr type visitors ;
			    visitors = multiples // singletons ;
			    in { output = output ; }
		      in visitor ;
              }
      ) ;
    }
