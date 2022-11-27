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
                              predicates =
                                {
                                  identity = x : x ;
                                  is-type = item : item == type ;
                                } ;
                              processed =
                                let
				  indices = if is-simple then null else if is-list then builtins.genList ( builtins.length input ) else builtins.attrNames input ;
                                  initial = if is-simple then input else if is-list then [ ] else { } ;
                                  in builtins.foldl' reducers.processed initial indices ;
			      reduced = if is-simple then processed else if is-list then builtins.map ( value : value.processed ) processed else builtins.mapAttrs ( name : value : value.processed ) processed ;
                              reducers =
                                {
                                  processed =
				    previous : current :
				      let
				        next = caller next-index next-path next-input ;
				        next-index = index + previous-size ;
					next-input = if is-simple then input else if is-list then builtins.elemAt input current else builtins.getAttr current input ;
					next-path = builtins.concatLists [ path [ current ] ] ;
					previous-size = builtins.foldl' reducers.size 0 previous ;
				        in if is-simple then previous else if is-list then builtins.concatLists [ previous [ next ] ] else previous // { "${ current }" = next ; } ;
			          size = previous : current : previous + current.size ;
                                } ;
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
				  reduced = reduced ;
                                  reducers = reducers ;
                                  type = type ;
                                } ;
                              type = builtins.typeOf input ;
                              in track ;
                        node = caller 0 [ ] input ;
                        in node.lambdas.value node ;
              }
      ) ;
    }
