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
                    float ? false ,
                    int ? false ,
                    lambda ? false ,
                    list ? false ,
                    null ? false ,
                    path ? false ,
                    set ? false ,
                    string ? false ,
                    undefined ? false
                  } :
		    input :
                      let
                        caller =
                          index : path : input :
                            let
                              is-list = type == "list" ;
                              is-simple = builtins.any predicates.is-type [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                              lambdas =
                                let
                                  find =
				    name : value :
				      let
				        filtered = builtins.filter ( value : builtins.typeOf value == "lambda" ) [ value undefined ] ;
					in if builtins.length filtered == 0 then builtins.throw "0f308e77-0fb7-43cc-86e8-c1dd58d75092" else builtins.head filtered ;
                                  input =
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
                                    output = builtins.mapAttrs find input ;
                                    value = if builtins.hasAttr type input then builtins.getAttr type input else builtins.throw "223c63db-a1d5-48bc-aaca-b4a6c40b15b3" ;
                                  in
                                    {
                                      find = find ;
                                      input = input ;
                                      output = output ;
                                      undefined = undefined ;
                                      value = value ;
                                    } ;
                              output = lambdas.value track ;
                              predicates =
                                {
                                  identity = x : x ;
                                  is-type = item : item == type ;
                                } ;
                              processed =
			        let
				  initial = if is-simple then input else if is-list then [ ] else { } ;
				  list = if is-simple then [ ] else if is-list then builtins.genList predicates.identity ( builtins.length input ) else builtins.attrNames input ;
				  in builtins.trace "YES: ${ builtins.concatStringsSep " , " ( builtins.map builtins.typeOf ( builtins.attrValues ( builtins.foldl' reducers.processed initial list ) ) ) }" ( builtins.foldl' reducers.processed initial list ) ;
                              reducers =
                                {      
                                  processed =
                                    previous : current :
                                      let
                                        last = builtins.foldl' reducers.size index ( if is-simple then previous else if is-list then previous else builtins.attrValues previous ) ;
                                        next =
                                          caller
                                            ( index + last )
                                            ( builtins.concatLists [ path [ current ] ] )
                                            (
                                              if is-simple then input
                                              else if is-list then builtins.elemAt input current
                                              else builtins.getAttr current input
                                            ) ;
                                        in if is-simple then next else if is-list then builtins.concatLists [ previous [ next ] ] else previous // { "${ current }" = builtins.trace ( builtins.toString ( current ) ) next ; } null ;
                                  size =
				    previous : current : -1 ;
				      # if is-simple then 1
				      # else if is-list then previous + ( builtins.getAttr "size" ( caller index ( builtins.concatLists [ path [ current ] ] ) ( builtins.elemAt input current ) ) )
				      # else previous + ( builtins.getAttr "size" ( caller index ( builtins.concatLists [ path [ current ] ] ) ( builtins.getAttr current input ) ) ) ;
                                } ;
                              size = if is-simple then 1 else if is-list then builtins.foldl' reducers.foldl' reducers.size 0 input else builtins.foldl' reducers.size 0 ( builtins.attrNames input ) ;
                              track =
                                {
                                  caller = caller ;
                                  index = index ;
                                  input = input ;
                                  is-list = is-list ;
                                  is-simple = is-simple ;
                                  lambdas = lambdas ;
                                  path = path ;
                                  predicates = predicates ;
                                  processed = processed ;
                                  reducers = reducers ;
                                  size = size ;
                                  type = type ;
                                  visitor = visitor ;
                                } ;
                              type = builtins.typeOf input ;
                              visitor = caller index path ;
                              in output ;
                        in caller 0 [ ] input ;
              }
      ) ;
    }
