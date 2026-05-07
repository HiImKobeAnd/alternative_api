{
  description = "An Elixir development shell.";

  inputs.nixpkgs.url = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      overlay = prev: final: rec {
        beamPackages = prev.beamMinimal28Packages;
        elixir = beamPackages.elixir_1_19;
        erlang = beamPackages.erlang;
        elixir-ls = beamPackages.elixir-ls.override {
          elixir = elixir;
          # mixRelease = beamPackages.mixRelease.override { elixir = elixir; };
        };
        hex = beamPackages.hex;
        final.mix2nix = prev.mix2nix.overrideAttrs {
          nativeBuildInputs = [ final.elixir ];
          buildInputs = [ final.erlang ];
        };
      };

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      nixpkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor system;
        in
        {
          default =
            let
              opts =
                with pkgs;
                lib.optional stdenv.isLinux inotify-tools
                ++ lib.optionals stdenv.isDarwin (
                  with darwin.apple_sdk.frameworks;
                  [
                    CoreServices
                    Foundation
                  ]
                );
            in
            pkgs.mkShell {
              packages =
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
                ++ opts;
              shellHook = ''
                # limit mix to current project
                mkdir -p .nix-mix
                export MIX_HOME=$PWD/.nix-mix

                # rewire executables
                export PATH=$MIX_HOME/bin:$PATH
                export PATH=$MIX_HOME/escripts:$PATH

                # limit history to current project
                export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang-history\"'"

                export TAILWIND_PATH="${pkgs.tailwindcss_4}/bin/tailwindcss"
              '';
            };
        }
      );
    };
}
