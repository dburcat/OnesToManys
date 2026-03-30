-- Sample data for SQLite Character Equipment & Appearance database
-- Insert lookup data first, then character data

-- ============================================================================
-- INSERT LOOKUP DATA (Armor, Weapon, Cape, Hair, Eyes)
-- ============================================================================

INSERT INTO Armor (armor_type, description) VALUES ('Heavy', 'Heavy plate armor');
INSERT INTO Armor (armor_type, description) VALUES ('Medium', 'Medium chain armor');
INSERT INTO Armor (armor_type, description) VALUES ('Light', 'Light leather armor');

INSERT INTO Weapon (weapon_type, description) VALUES ('Sword', 'Long sword');
INSERT INTO Weapon (weapon_type, description) VALUES ('GreatSword', 'Two-handed great sword');
INSERT INTO Weapon (weapon_type, description) VALUES ('Spear', 'Long spear');

INSERT INTO Cape (cape_length, description) VALUES ('Long', 'Full length flowing cape');
INSERT INTO Cape (cape_length, description) VALUES ('Short', 'Short shoulder length cape');

INSERT INTO Hair (hair_style, description) VALUES ('Long', 'Long flowing hair');
INSERT INTO Hair (hair_style, description) VALUES ('Short', 'Short cropped hair');

INSERT INTO Eyes (eye_color, description) VALUES ('Blue', 'Bright blue eyes');
INSERT INTO Eyes (eye_color, description) VALUES ('Green', 'Green eyes');

-- ============================================================================
-- INSERT CHARACTER DATA
-- ============================================================================

-- Character 1: Sir Lancelot
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (1, 1, 1);
INSERT INTO Appearance (hair_id, eyes_id) VALUES (1, 1);
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (18, 14, 16, 10, 12, 15);
INSERT INTO Character (name, equipment_id, appearance_id, stats_id) 
VALUES ('Sir Lancelot', 1, 1, 1);

-- Character 2: Rogue Shadow
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (3, 1, 2);
INSERT INTO Appearance (hair_id, eyes_id) VALUES (2, 2);
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (12, 18, 13, 14, 16, 11);
INSERT INTO Character (name, equipment_id, appearance_id, stats_id) 
VALUES ('Shadow', 2, 2, 2);

-- Character 3: Wizard Aldor
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (2, 3, 1);
INSERT INTO Appearance (hair_id, eyes_id) VALUES (1, 1);
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (10, 12, 14, 18, 16, 13);
INSERT INTO Character (name, equipment_id, appearance_id, stats_id) 
VALUES ('Aldor', 3, 3, 3);
