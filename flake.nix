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
                              indices = if is-simple then [ ] else if is-list then builtins.genList ( x : x ) ( builtins.length input ) else builtins.attrNames input ;
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
                                  initial = if is-simple then input else if is-list then [ ] else { } ;
                                  in builtins.foldl' reducers.processed initial indices ;
                              reducers =
                                {
                                  processed =
                                    previous : current :
                                      let
				        size = builtins.foldl' ( previous : current : previous + current.size ) 0 ( if is-simple then [ ] else if is-list then previous else builtins.attrValue previous ) ;
                                        node = caller ( index + size ) ( builtins.concatLists [ path [ current index ] ] ) ( if is-simple then null else if is-list then builtins.elemAt input current else builtins.getAttr current input ) ;
                                        in if is-simple then previous else if is-list then builtins.concatLists [ previous [ ( node.lambdas.value node ) ] ] else previous // { "${ current }" = node.lambdas.value node ; } ;
                                  size =
                                    previous : current :
                                      let
                                        node = caller ( index + previous ) ( builtins.concatLists [ path [ current index ] ] ) ( if is-simple then null else if is-list then builtins.elemAt input current else builtins.getAttr current input ) ;
                                        in previous + node.size ;
                                } ;
                              size = builtins.foldl' reducers.size ( if is-simple then 1 else 0 ) indices ;
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
                                } ;
                              type = builtins.typeOf input ;
                              in track ;
                        node = caller 0 [ ] input ;
                        in node.lambdas.value node ;
              }
      ) ;
    }
