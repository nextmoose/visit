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
		        root = visitor ( track 0 [ ] value ) ;
		        track =
			  index : path : value :
			    let
			      tasks =
			        let
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
				  visit =
				    track :
				      if is-simple then lambda { }
				      else null ;
				  in
				    {
				      find = find ;
				      identity = identity ;
				      input = input ;
				      is-list = is-list ;
				      is-simple = is-simple ;
				      lambda = lambda ;
				      output = output ;
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
			in root.output ;
              }
      ) ;
    }
