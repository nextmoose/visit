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
                    let
                      visitor =
                        let
                          visitors =
                            let
                              multiple =
                                is-list : specific : track :
                                  let
                                    list = if is-list then builtins.genList ( n : n ) ( builtins.length track.input ) else builtins.attrNames track.input ;
                                    reducer =
                                      previous : current :
                                        let
                                          index = previous.index + ( if is-simple then 1 else 0 ) ;
                                          input = if is-list then builtins.elemAt track.input current else builtins.getAttr current track.input ;
                                          is-simple = builtins.any ( type : builtins.typeOf input == type ) [ "bool" "float" "int" "lambda" "null" "path" "string" ] ;
                                          output = visitor track ;
                                          path = builtins.concatLists [ track.path [ current ] ] ;
                                          track = { index = index ; input = input ; path = path ; type = type ; } ;
					  type = builtins.typeOf input ;
                                          in track // { output = output ; } ;
                                    in single specific ( builtins.foldl' reducer track list ) ;
                              single = specific :
			        let
				  lambda =
                                    if builtins.typeOf specific != "lambda" && builtins.typeOf undefined != "lambda" then builtins.throw "5d979370-ae2e-44ab-a61e-7869292ece02"
                                    else if builtins.typeOf specific == "lambda" then specific
                                    else undefined ;
				  in track : track // { output = lambda track ; type = builtins.typeOf track.input ; } ;
                              in
                                {
                                  bool = single bool ;
                                  float = single float ;
                                  int = single int ;
                                  lambda = single lambda ;
                                  list = multiple true list ;
                                  null = single null ;
                                  path = single path ;
                                  set = multiple false set ;
                                  string = single ;
                                } ;
	                  in track : builtins.getAttr track.type visitors ;
                      in value : visitor { index = 0 ; input = value ; path = [ ] ; type = builtins.typeOf value ; visitor = visitor ; } ;
              }
      ) ;
    }
