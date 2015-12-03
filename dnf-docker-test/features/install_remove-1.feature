Feature: DNF/Behave test (install remove test)

Scenario: Install TestA from repository "test-1"
 Given I use the repository "test-1"
 When I execute "dnf" command "install -y TestA" with "success"
 Then package "TestA, TestB" should be "installed"
 And package "TestC" should be "absent"
 When I "install" a package "TestA" with "dnf"
 Then package "TestA, TestB" should be "present"
 When I "remove" a package "TestA" with "dnf"
 Then package "TestA, TestB" should be "removed"
 And package "TestC" should be "absent"

 When I "install" a package "TestD" with "dnf"
 Then package "TestD, TestE" should be "installed"
 When I "remove" a package "TestD" with "dnf"
 Then package "TestD, TestE" should be "removed"

 When I "install" a package "TestF" with "dnf"
 Then package "TestF, TestG, TestH" should be "installed"
 When I "remove" a package "TestF" with "dnf"
 Then package "TestF, TestG, TestH" should be "removed"

 When I execute "dnf" command "install -y TestI" with "fail"
 Then package "TestI, TestJ" should be "absent"

 When I "install" a package "TestK, TestL" with "dnf"
 Then package "TestK, TestL, TestM" should be "installed"
 When I "remove" a package "TestK" with "dnf"
 Then package "TestK" should be "removed"
 And package "TestL, TestM" should be "present"
 And package "TestL, TestM" should be "unupgraded"
 When I "remove" a package "TestL" with "dnf"
 Then package "TestL, TestM" should be "removed"

 When I execute "dnf" command "install -y ProvideA" with "success"
 Then package "TestO, TestC" should be "installed"
 When I execute "dnf" command "remove -y ProvideA" with "success"
 Then package "TestO, TestC" should be "removed"

 When I execute "dnf" command "install -y http://127.0.0.1/repo/test-1/TestB-1.0.0-1.noarch.rpm" with "success"
 Then package "TestB" should be "installed"
 When I execute "dnf" command "remove -y TestB" with "success"
 Then package "TestB" should be "removed"

 When I execute "dnf" command "install -y /var/www/html/repo/test-1/TestB-1.0.0-1.noarch.rpm" with "success"
 Then package "TestB" should be "installed"
 When I execute "dnf" command "remove -y TestB" with "success"
 Then package "TestB" should be "removed"