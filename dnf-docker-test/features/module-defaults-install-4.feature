Feature: On-disk modulemd data are merged with repodata
# Notes:
# 1. on-disk modulemd-defaults data for a given module completely overrides
#     repodata for that module
# 2. multiple on-disk modulemd-defaults data for a given module will be merged,
#    but that simply means additional streams can be added

  @setup
  Scenario: Testing repository Setup
      Given I run steps from file "modularity-repo-5.setup"
        And a file "/etc/dnf/modules.defaults.d/ModuleConfPD2a.yaml" with
          """
          ---
          document: modulemd-defaults
          version: 1
          data:
            module: ModuleConfPD2
            stream: pepper
            profiles:
              salt: [bacon]
              pepper: [eggs]
          ...
          """
        And a file "/etc/dnf/modules.defaults.d/ModuleConfPD2b.yaml" with
          """
          ---
          document: modulemd-defaults
          version: 1
          data:
            module: ModuleConfPD2
            stream: pepper
            profiles:
              sugar: [bacon]
          ...
          """
       When I enable repository "modularityConf"
        And I successfully run "dnf makecache"

  Scenario: Local system modulemd defaults are merged and override repo defaults
       When I save rpmdb
        And I successfully run "dnf -y module install ModuleConfPD2"
       Then a module ModuleConfPD2 config file should contain
         | Key      | Value   |
         | enabled  | 1       |
         | stream   | pepper  |
         | version  | 1       |
         | profiles | eggs    |
        And rpmdb changes are
         | State     | Packages                 |
         | installed | TestConfC/1-1.modConfPD2 |

  Scenario: Cleanup from previous scenario
       When I successfully run "dnf -y module remove ModuleConfPD2:pepper"
        And I successfully run "dnf -y module disable ModuleConfPD2:pepper"

  @xfail
  # awaiting confirmation of proper understanding of merging defaults
  Scenario: Local system modulemd defaults are merged and override repo defaults
       When I save rpmdb
        And I successfully run "dnf -y module install ModuleConfPD2:sugar"
       Then a module ModuleConfPD2 config file should contain
         | Key      | Value   |
         | enabled  | 1       |
         | stream   | sugar   |
         | version  | 1       |
         | profiles | bacon   |
        And rpmdb changes are
         | State     | Packages                 |
         | installed | TestConfB/1-1.modConfPD2 |

  @xfail
  # due to previous scenario failure
  Scenario: Cleanup from previous scenario
       When I successfully run "dnf -y module remove ModuleConfPD2:sugar"
        And I successfully run "dnf -y module disable ModuleConfPD2:sugar"
