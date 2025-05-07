{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    garnix-lib.url = "github:garnix-io/garnix-lib?ref=0573417fc462b0eeed5d762c8fe08093afb35a3d";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };

  outputs = inputs: inputs.garnix-lib.lib.mkModules {
    modules = [];
    config = { ... }: {
      garnix.deployBranch = "main";
    };

    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib."x86_64-linux".run {
        src = ./.;
        hooks = {
          nixfmt-rfc-style.enable = true;
          typstyle.enable = true;
          markdownlint.enable = true;
          mdsh.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          statix.enable = true;
          typos.enable = true;
          proselint.enable = true;
          proselint.settings.config = ''
            {
              "checks": {
                "typography.diacritical_marks": false,
                "typography.symbols.curly_quotes": false,
                "typography.symbols.ellipsis": false
              }
            }
          '';
          check-merge-conflicts.enable = true;
          commitizen.enable = true;
          forbid-new-submodules.enable = true;
          check-case-conflicts.enable = true;
          check-executables-have-shebangs.enable = true;
          check-shebang-scripts-are-executable.enable = true;
          check-symlinks.enable = true;
          check-vcs-permalinks.enable = true;
          end-of-file-fixer.enable = true;
          mixed-line-endings.enable = true;
          tagref.enable = true;
          trim-trailing-whitespace.enable = true;
          check-yaml.enable = true;
          yamlfmt.enable = true;
          check-json.enable = true;
          actionlint.enable = true;
        };
      };
    };

    formatter = inputs.nixpkgs.legacyPackages."x86_64-linux".nixfmt-rfc-style;
  };
}