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
                        node = track ;
                        root = visitor ( track 0 [ ] value ) ;
                        track =
                          index : path : value :
                            let
                              tasks =
                                let
                                  eval =
                                    track :
                                      let
                                        eval =
                                          if is-simple then { size = 1 ; }
                                          else if is-list then
                                            let
                                              initial = [ { input = [ ] ; size = 0 ; } ] ;
                                              list = builtins.genList identity ( builtins.length value ) ;
                                              reducer =
                                                previous : current :
                                                  let
                                                    last = builtins.elemAt previous ( builtins.length previous - 1 ) ;
                                                    in builtins.concatLists [ previous [ ( track ( node + last.size ) ( builtins.concatLists path current ) ( builtins.elemAt value current ) ) ] ] ;
                                              in builtins.foldl' reducer initial list
                                          else null ;
                                        in builtins.trace "YES" ( track // eval ) ;
                                  find =
                                    name : value :
                                      let
                                        filtered = builtins.filter ( l : builtins.typeOf l == "lambda" ) [ value undefined identity ] ;
                                        in if builtins.length filtered == 0 then builtins.throw "020ecb5f-9b6d-4e0a-ad14-5005be7b29f5" else builtins.elemAt filtered 0 ;
                                  identity = x : x ;
                                  input =
                                    {
                                      bool = bool ;
                                      float = float ;
                                      int = int ;
                                      lambda = lambda ;
                                      null = null ;
                                      path = path ;
                                      string = string ;
                                    } ;
                                  is-list = type == "list" ;
                                  is-simple = builtins.any ( t : t == type ) [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                                  lambda = if builtins.hasAttr type output then builtins.getAttr type output else builtins.throw "a0015af2-57e5-4a16-8e06-74408562c1bf" ;
                                  output = builtins.mapAttrs find input ;
                                  process = track : ( eval track ) // { output = lambda ( eval track ) ; } ;
                                  visit =
                                    track :
                                      let
                                        p = process track ;
                                        in if builtins.hasAttr "output" p then p.output else builtins.throw "b929aecd-55eb-463c-9659-ca7b1730ca50" ;
                                  in
                                    {
				      eval = eval ;
                                      find = find ;
                                      identity = identity ;
                                      input = input ;
                                      is-list = is-list ;
                                      is-simple = is-simple ;
                                      lambda = lambda ;
                                      output = output ;
				      process = process ;
                                      undefined = undefined ;
                                      visit = visit ;
                                    } ;
                              type = builtins.typeOf value ;
                              in
                                {
                                  input = value ;
                                  index = index ;
                                  path = path ;
                                  tasks = tasks ;
                                  type = type ;
                                } ;
                        visitor = track : track // { output = track.tasks.visit track ; } ;
                        in root.tasks.visit root ;
              }
      ) ;
    }
