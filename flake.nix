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
                            find = fun : builtins.trace ( builtins.typeOf fun ) ( builtins.head ( builtins.filter ( f : builtins.typeOf f == "lambda" ) [ fun undefined ( x : x.processed ) ] ) ) ;
                          } ;
                        mappers =
                          {
                           list =
                             {
                               processed = value : value.output ;
                             } ;
                           set =
                             {
                               process = name : value : track : { ${ name } = value track ; } ;
                               processed = name : value : mappers.list.processed "" ;
                             } ;
                          } ;
                        process =
			  first : value :
                            let
                              fields =
                                {
                                  index = track : builtins.trace ">> ${ builtins.typeOf track.input }" first ;
				  input = track : builtins.trace "<< ${ builtins.typeOf value }" { input = value ; } ;
                                  is-list = track : track.type == "list" ;
                                  is-simple = track : builtins.any ( t : t == track.type ) [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                                  lambda-input =
                                    track :
				      builtins.trace ":: ${ track.type }" (
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
                                        } ) ;
                                  lambda-output = track : functions.find track.lambda-input ;
                                  output = track : track.lambda-output track ;
                                  processed = track : if track.is-simple then track.input else if track.is-list then builtins.foldl' reducers.processed { } track.input else builtins.mapAttrs mappers.set.processed track.input ;
                                  size = track : if track.is-simple then 1 else if track.is-list then builtins.foldl' reducers.size 0 track.input else builtins.foldl' reducers.size 0 ( builtins.attrValues track.input ) ;
                                  type = track : builtins.trace ".. ${ builtins.typeOf track.input }" ( builtins.typeOf track.input ) ;
                                } ;
                              processors =
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
                              in builtins.foldl' reducers.process { } processors ;
                        reducers =
                          {
                            process = previous : current : previous // ( current previous ) ;
			    processed =
			      previous : current :
			        let
				  last = builtins.elemAt ( builtins.length previous - 1 ) ;
			          in builtins.concatLists [ previous ( process last.size current ) ] ;
                            size = previous : current : previous + current.size ;
                          } ;
			root = process 0 value ;
		        in root.output ;
              }
      ) ;
    }
