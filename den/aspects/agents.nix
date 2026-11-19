{ inputs, ... }:
{
  den.aspects.agents.provides.to-users.homeManager = {
    imports = [ inputs.agent-skills.homeManagerModules.default ];

    programs.agent-skills = {
      enable = true;
      sources.asd-ste100 = {
        path = inputs.asd-ste100-skill;
      };
      skills.enableAll = [ "asd-ste100" ];
      targets.claude.enable = true;
    };
  };
}
