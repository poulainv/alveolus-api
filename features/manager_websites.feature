Feature: Manage Webapps
	In order to know some 'new' websites
	As an visitor
	I want to show a list of Webapps
	
	Scenario: Wepapps list
	  Given I have webapps titled Korben, Fleex, Rue89, LeMonde, MyMajor, LaRuche
	  Then I should see "Korben"
	  And I should see "Fleex"
	  
	