# I have based this flake a lot on: https://github.com/Ladas552/Flake-Ocean/blob/b8d7512f76fa0722533c9523a280dd071f8df168/templates/elixir-phoenix/flake.nix#L4
{
  description = "An Elixir development shell.";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlay = prev: final: rec {
          beamPackages = prev.beamMinimal28Packages;
          elixir = beamPackages.elixir_1_19;
          erlang = beamPackages.erlang;
          elixir-ls = beamPackages.elixir-ls.override {
            elixir = elixir;
          };
          hex = beamPackages.hex;
          final.mix2nix = prev.mix2nix.overrideAttrs {
            nativeBuildInputs = [ final.elixir ];
            buildInputs = [ final.erlang ];
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      rec {
        packages.default = { };
        apps.default = flake-utils.lib.mkApp { drv = packages.default; };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ ];
          buildInputs =
            with pkgs;
            [
              sqlite
              elixir
              elixir-ls
              hex
              mix2nix
              nodejs_20
              yarn
            ]
            ++ lib.optionals stdenv.isLinux [
              libnotify
              inotify-tools
            ]
            ++ lib.optionals stdenv.isDarwin [
              terminal-notifier
              darwin.apple_sdk.frameworks.CoreFoundation
              darwin.apple_sdk.frameworks.CoreServices
            ];

          shellHook = ''
            mkdir -p .nix-mix
            mkdir -p .nix-hex
            export MIX_HOME=$PWD/.nix-mix
            export HEX_HOME=$PWD/.nix-hex
            export ERL_LIBS=$HEX_HOME/lib/erlang/lib

            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
            export PATH=$HEX_HOME/bin:$PATH

            export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang-history\"'"

            export TAILWIND_PATH="${pkgs.tailwindcss_4}/bin/tailwindcss"
          '';
        };
      }
    );
}
