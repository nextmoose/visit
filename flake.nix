  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
          utils.url = "github:nextmoose/utils" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils , utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell =
                  let
                    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
		    utils = builtins.getAttr system utils.lib ;
                    generate =
		      utils.argue
                        [
                        ]
                        [
                        ]
                        (
                          input :
                            pkgs.writeShellScriptBin
                            "generate"
                            ''
                              while [ $# -gt 0 ]
                              do
                                case $1 in
				  --destination-directory)
				    DESTINATION-DIRECTORY=$2 &&
				      shift 2 &&
				      break
				    ;;
                                  --resource-directory)
                                    RESOURCE_DIRECTORY=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  --private-file)
                                    PRIVATE_FILE=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  --shell-hook)
                                    SHELL_HOOK=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  *)
                                    ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                                      ${ pkgs.coreutils }/bin/echo $1 &&
                                      ${ pkgs.coreutils }/bin/echo $@ &&
                                      exit 64
                                    ;;
                                esac
                              done &&
                                SOURCE_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                                ${ pkgs.coreutils }/bin/cp ${ ./src/source.nix } $SOURCE_DIRECTORY/flake.nix &&
				${ pkgs.coreutils }/bin/echo $DESTINATION_DIRECTORY > $SOURCE_DIRECTORY/destination-directory.txt &&
				${ pkgs.coreutils }/bin/echo $RESOURCE_DIRECTORY > $SOURCE_DIRECTORY/resource-directory.txt &&
                                ${ pkgs.coreutils }/bin/chmod 0400 $SOURCE_DIRECTORY/flake.nix $SOURCE_DIRECTORY/destination-directory.txt $SOURCE_DIRECTORY/resource-directory.txt &&
                                ${ pkgs.coreutils }/bin/echo $SOURCE_DIRECTORY
                            ''
                        )
                        "cd2330a5-67d3-4919-800a-2ab8edb5d33e"
                        ( self : "OK2" )
                        "IT" ;
                    shell =
		      utils.argue
                        [
                          [
                            "eecebe2b-135e-4f53-a942-8812a66c7467"
                            true
                            (
                              pkgs.mkShell
                                {
                                  buildInputs = [ generate.trace ] ;
                                  shellHook = "${ pkgs.coreutils }/bin/echo WELCOME eecebe2b-135e-4f53-a942-8812a66c7467" ;
                                }
                            )
                            "identity"
                          ]
                        ]
                        [
                          [
                            ( name : pkgs.mkShell { buildInputs = [ generate.trace ] ; shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ name }" ; } )
                            "correct"
                          ]
                        ]
                        (
                          name :
                            pkgs.mkShell
                              {
                                buildInputs = [ generate.trace ] ;
                                shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ name }" ;
                              }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
                        "Emory Merryman" ;
                    scripts =
		      resource-directory : private :
                        {
			  init = "${ pkgs.coreutils }/bin/echo HI ... my resource directory is ${ resource-directory } and my private id is ${ private.id }" ;
                        } ;
                    in shell.trace ;
              }
      ) ;
    }
