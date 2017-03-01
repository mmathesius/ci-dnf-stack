Feature: Checking transaction changes for installonly packages

Scenario: Executing transaction with installonly packages
     Given repository "TestRepoA" with packages
          | Package  | Tag      | Value                  |
          | TestA    | Provides | installonlypkg(kernel) |
          |          | Version  | 1.0                    |
          | TestA v2 | Provides | installonlypkg(kernel) |
          |          | Version  | 2.0                    |
          | TestA v3 | Provides | installonlypkg(kernel) |
          |          | Version  | 3.0                    |
      When I enable repository "TestRepoA"
       And I successfully run "dnf -y install TestA-1.0 TestA-2.0"
       And I save rpmdb
       And I successfully run "dnf -y install TestA-3.0"
       And I successfully run "dnf -y remove TestA-2.0"
       And I successfully run "dnf -y reinstall TestA-1.0"
      Then rpmdb changes are
          | State       | Packages  |
          | installed   | TestA/3.0 |
          | removed     | TestA/2.0 |
          | reinstalled | TestA/1.0 |
