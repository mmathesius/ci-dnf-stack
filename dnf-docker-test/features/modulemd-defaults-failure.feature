Feature: On-disk modulemd data are merged with repodata

# Notes regarding operation of modulemd-defaults data merging:
# 1. All repodata data for each module are merged.
# 2. All on-disk data for each module are merged.
# 3. The merged on-disk data and merged repodata data are then merged,
#    with on-disk data for any module overriding the repodata data.
#    This means on-disk data can add to or change stream profiles
#    found in repodata, but never delete stream profiles.

  @setup
  Scenario: Testing repository Setup
      Given repository "modularityConf" with packages
           | Package              | Tag     | Value |
           | modConfPD2/TestConfA | Version | 1     |
           |                      | Release | 1     |
           | modConfPD2/TestConfB | Version | 1     |
           |                      | Release | 1     |
           | modConfPD2/TestConfC | Version | 1     |
           |                      | Release | 1     |
        And a file "modules.yaml" with type "modules" added into repository "modularityConf"
            """
            ---
            data:
              name: ModuleConfPD2
              summary: Module ModuleConfPD2 summary
              description: Module ModuleConfPD2 description - populated default profile, stream "salt".
              stream: salt
              version: 1
              license:
                module: [MIT]
              profiles:
                default:
                  rpms: [TestConfA]
                bacon:
                  rpms: [TestConfB]
                eggs:
                  rpms: [TestConfC]
              artifacts:
                rpms:
                - TestConfA-0:1-1.modConfPD2.noarch
                - TestConfB-0:1-1.modConfPD2.noarch
                - TestConfC-0:1-1.modConfPD2.noarch
              components:
                rpms:
                  TestConfA: {rationale: 'rationale for TestConfA'}
                  TestConfB: {rationale: 'rationale for TestConfB'}
                  restConfC: {rationale: 'rationale for TestConfC'}
            document: modulemd
            version: 2
            ---
            data:
              name: ModuleConfPD2
              summary: Module ModuleConfPD2 summary
              description: Module ModuleConfPD2 description - populated default profile, stream "pepper".
              stream: pepper
              version: 1
              license:
                module: [MIT]
              profiles:
                default:
                  rpms: [TestConfA]
                bacon:
                  rpms: [TestConfB]
                eggs:
                  rpms: [TestConfC]
              artifacts:
                rpms:
                - TestConfA-0:1-1.modConfPD2.noarch
                - TestConfB-0:1-1.modConfPD2.noarch
                - TestConfC-0:1-1.modConfPD2.noarch
              components:
                rpms:
                  TestConfA: {rationale: 'rationale for TestConfA'}
                  TestConfB: {rationale: 'rationale for TestConfB'}
                  restConfC: {rationale: 'rationale for TestConfC'}
            document: modulemd
            version: 2
            ---
            data:
              name: ModuleConfPD2
              summary: Module ModuleConfPD2 summary
              description: Module ModuleConfPD2 description - populated default profile, stream "sugar".
              stream: sugar
              version: 1
              license:
                module: [MIT]
              profiles:
                default:
                  rpms: [TestConfA]
                bacon:
                  rpms: [TestConfB]
                eggs:
                  rpms: [TestConfC]
              artifacts:
                rpms:
                - TestConfA-0:1-1.modConfPD2.noarch
                - TestConfB-0:1-1.modConfPD2.noarch
                - TestConfC-0:1-1.modConfPD2.noarch
              components:
                rpms:
                  TestConfA: {rationale: 'rationale for TestConfA'}
                  TestConfB: {rationale: 'rationale for TestConfB'}
                  restConfC: {rationale: 'rationale for TestConfC'}
            document: modulemd
            version: 2
            ---
            document: modulemd-defaults
            version: 1
            data:
              module: ModuleConfPD2
              stream: salt
              profiles:
                salt: [default]
                pepper: [bacon]
            ...
            """
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

  @xfail
  # https://bugzilla.redhat.com/show_bug.cgi?id=1582524
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
