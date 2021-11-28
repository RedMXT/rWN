INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_wn', 'Journaliste', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_wn', 'Journaliste', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_wn', 'Journaliste', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('journalist',0,'stagiaire','Stagiaire',12,'{}','{}'),
  ('journalist',1,'report','Reportaire',24,'{}','{}'),
  ('journalist',2,'redac','Rédacteur',36,'{}','{}'),
  ('journalist',3,'resp','Responsable Rédaction',48,'{}','{}'),
  ('journalist',4,'boss','Boss',0,'{}','{}')
;

INSERT INTO `jobs` (name, label) VALUES
	('journalist','Journaliste')
;
