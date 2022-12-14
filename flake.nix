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
                              functions =
                                let
                                  size =
                                    input :
                                      if builtins.typeOf input == "list" then let x = builtins.foldl' reducers.size 0 input ; in builtins.trace "LIST ${ builtins.toString x }" x
                                      else if builtins.typeOf input == "set" then let x = builtins.foldl' reducers.size 0 ( builtins.attrValues input ) ; in builtins.trace "SET ${ builtins.toString x }" x
                                      else builtins.trace "SIMPLE 1 ${ builtins.typeOf input } ${ if builtins.typeOf input == "lambda" then "LAMBDA" else builtins.toString input }" 1 ;
                                  size-input =
                                    input :
                                      if builtins.typeOf input == "list" then builtins.foldl' ( previous : current : previous + current.size ) 0 input
                                      else if builtins.typeOf input == "set" then builtins.foldl' ( previous : current : previous + current.size ) 0 ( builtins.attrValues input )
                                      else builtins.throw "a54f80de-06e1-4c9c-9db4-2a5be6f912a6" ;
                                  in
                                    {
                                      size = size ;
                                      size-input = size-input ;
                                    } ;
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
                                    value = if builtins.hasAttr type output then builtins.getAttr type output else builtins.throw "223c63db-a1d5-48bc-aaca-b4a6c40b15b3" ;
                                  in
                                    {
                                      find = find ;
                                      input = input ;
                                      output = output ;
                                      undefined = undefined ;
                                      value = value ;
                                    } ;
                              mappers =
                                {
                                  input = value : value.input ;
                                } ;
                              predicates =
                                {
                                  identity = x : x ;
                                  is-type = item : item == type ;
                                } ;
                              processed =
                                let
                                  indices = if is-simple then [ ] else if is-list then builtins.genList ( x : x ) ( builtins.length input ) else builtins.attrNames input ;
                                  initial = if is-simple then input else if is-list then [ ] else { } ;
                                  in builtins.foldl' reducers.processed initial indices ;
                              reduced = if is-simple then processed else if is-list then builtins.map ( value : value.lambdas.value value ) processed else builtins.mapAttrs ( name : value : value.lambdas.value value ) processed ;
                              reducers =
                                {
                                  processed =
                                    previous : current :
                                      let
                                        next = caller next-index next-path next-input ;
                                        next-index = index + previous-size ;
                                        next-input = if is-simple then input else if is-list then builtins.elemAt input current else builtins.getAttr current input ;
                                        next-path = builtins.concatLists [ path [ current ] ] ;
                                        previous-size = functions.size-input previous ;
                                        in if is-simple then previous else if is-list then builtins.concatLists [ previous [ next ] ] else previous // { "${ current }" = next ; } ;
                                  size = previous : current : previous + ( functions.size current ) ;
                                } ;
                              size = functions.size input ;
                              track =
                                {
                                  caller = caller ;
                                  functions = functions ;
                                  index = index ;
                                  input = input ;
                                  is-list = is-list ;
                                  is-simple = is-simple ;
                                  lambdas = lambdas ;
                                  mappers = mappers ;
                                  path = path ;
                                  predicates = predicates ;
                                  processed = processed ;
                                  reduced = reduced ;
                                  reducers = reducers ;
                                  size = size ;
                                  type = type ;
                                } ;
                              type = builtins.typeOf input ;
                              in track ;
                        node = caller 0 [ ] input ;
                        in node.lambdas.value node ;
              }
      ) ;
    }
