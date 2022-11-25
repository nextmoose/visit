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
                    float ? false                ,
                    int ? false ,
                    lambda ? false ,
                    list ? false ,
                    null ? false ,
                    path ? false ,
                    set ? false ,
                    string ? false ,
                    undefined ? false
                  } :
                    value :
                      let
		        root = track 0 value [ ] ;
                        track =
                          index : input : path :
                            let
			      is-list = type == "list" ;
			      is-simple = builtins.any ( t : t == type ) [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                              lambda =
                                let
                                  first =
                                    name : value :
                                      let
                                        filtered = builtins.filter ( function : builtins.typeOf function == "lambda" ) [ value undefined identity ] ;
                                        identity = x : x ;
                                        in if builtins.length filtered == 0 then builtins.throw "a15ffabd-f8d1-4af1-9e84-c13c6f043fd0" else builtins.elemAt filtered 0 ;
                                  input-functions =
                                    {
                                      bool = bool ;
                                      float = float ;
                                      int = int ;
                                      lambda = lambda ;
                                      list = list ;
                                      null = null ;
                                      path = path ;
                                      set = set ;
                                      string = string ;
                                    } ;
                                  output-functions = builtins.mapAttrs first input-functions ;
                                  in builtins.getAttr type output-functions ;
			      output =
			        let
				  in lambda processed ;
			      processed = if is-simple then input else null ;
                              type = builtins.typeOf input ;
                              in
                                {
                                  index = index ;
                                  input = input ;
                                  path = path ;
                                  type = type ;
                                } ;
                        in root.output ;
              }
      ) ;
    }
