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
                        functions =
                          {
                            find = fun : builtins.head ( builtins.filter ( f : builtins.typeOf f == "lambda" ) [ fun undefined ( x : x ) ] ) ;
                          } ;
                        mappers =
                          {
                           list =
                             {
                               processed = value : value.output ;
                             } ;
                           set =
                             {
                               process = name : value : builtins.listToAttrs [ { name = name ; value = value ; } ] ;
                               processed = name : value : mappers.list.processed "" ;
                             } ;
                          } ;
                        process =
			  first :
                            let
                              fields =
                                {
                                  index = track : first ;
                                  input = track : value ;
                                  is-list = track : track.type == "list" ;
                                  is-simple = track : builtins.any ( t : t == track.type ) [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                                  lambda-input =
                                    track :
				      builtins.getAttr
				        track.type
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
                                  lambda-output = track : functions.find track.lambda-input ;
                                  output = track : track.lambda-output track ;
                                  processed = track : if track.is-simple then track.input else if track.is-list then builtins.map mappers.list.processed track.input else builtins.mapAttrs mappers.set.processed track.input ;
                                  size = track : if track.is-simple then 1 else if track.is-list then builtins.foldl' reducers.size 0 track.input else builtins.foldl' reducers.size 0 ( builtins.attrValues track.input ) ;
                                  type = track : builtins.typeOf track.input ;
                                } ;
                              list =
                                [
                                  sets.input
                                  sets.index
                                  sets.size
                                  sets.type
                                  sets.is-list
                                  sets.is-simple
                                  sets.lambda-input
                                  sets.lambda-output
                                  sets.processed
                                  sets.output
                                ] ;
                              sets = builtins.mapAttrs mappers.set.process fields ;
                              in builtins.foldl' reducers.process { } list ;
                        reducers =
                          {
                            process = previous : current : previous // current ;
                            size = previous : current : previous + current.size ;
                          } ;
			root = process 0 ;
			in builtins.typeOf builtins.concatStringsSep ",\n" ( builtins.mapAttrs ( name : value : "${ name } = ${ builtins.typeOf value }" ) root ) ;
		        # in root.output ;
              }
      ) ;
    }
