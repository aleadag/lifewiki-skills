{
  description = "OpenClaw plugin for lifewiki";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    obsidian-skills = {
      url = "github:kepano/obsidian-skills";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      obsidian-skills,
    }:
    let
      mkOpenclawPlugin =
        system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        localSkillsDir = ./skills;
        upstreamSkillsDir =
          if builtins.pathExists (obsidian-skills + "/skills") then
            obsidian-skills + "/skills"
          else
            obsidian-skills;
        collectSkillPaths =
          baseDir:
          let
            entries = builtins.readDir baseDir;
            names = builtins.attrNames entries;
            isSkillDir =
              name: entries.${name} == "directory" && builtins.pathExists (baseDir + "/${name}/SKILL.md");
          in
          map (name: baseDir + "/${name}") (lib.filter isSkillDir names);
      in
        {
          name = "lifewiki-skills";
          skills = (collectSkillPaths localSkillsDir) ++ (collectSkillPaths upstreamSkillsDir);
          packages = [ ];
          needs = {
            stateDirs = [ ];
            requiredEnv = [ "LIFEWIKI_VAULT" ];
          };
        };
    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShellNoCC {
        };
      }
    ))
    // {
      openclawPlugin = mkOpenclawPlugin;
    };
}
