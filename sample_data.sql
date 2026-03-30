-- Sample data for SQLite Character Equipment & Appearance database
-- Now with ONE-TO-MANY relationships: Character has multiple Equipment sets AND multiple Appearances

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
INSERT INTO Hair (hair_style, description) VALUES ('Wavy', 'Wavy medium-length hair');

INSERT INTO Eyes (eye_color, description) VALUES ('Blue', 'Bright blue eyes');
INSERT INTO Eyes (eye_color, description) VALUES ('Green', 'Green eyes');
INSERT INTO Eyes (eye_color, description) VALUES ('Brown', 'Brown eyes');

-- ============================================================================
-- INSERT CHARACTER DATA WITH STATS ONLY
-- ============================================================================

-- Character 1: Sir Lancelot
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (18, 14, 16, 10, 12, 15);
INSERT INTO Character (name, stats_id) 
VALUES ('Sir Lancelot', 1);

-- Character 2: Rogue Shadow
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (12, 18, 13, 14, 16, 11);
INSERT INTO Character (name, stats_id) 
VALUES ('Shadow', 2);

-- Character 3: Wizard Aldor
INSERT INTO Stats (strength, dexterity, constitution, intelligence, wisdom, charisma) 
VALUES (10, 12, 14, 18, 16, 13);
INSERT INTO Character (name, stats_id) 
VALUES ('Aldor', 3);

-- ============================================================================
-- INSERT APPEARANCE DATA (1:* relationship - multiple appearances per character)
-- ============================================================================

-- Sir Lancelot has 2 appearances
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (1, 'Battle Ready', 1, 1);
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (1, 'Formal Court', 1, 1);

-- Shadow has 3 appearances
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (2, 'Casual', 2, 2);
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (2, 'Disguise', 1, 3);
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (2, 'Shadow Form', 2, 2);

-- Aldor has 3 appearances
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (3, 'Research Mode', 3, 1);
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (3, 'Battle Mage', 1, 1);
INSERT INTO Appearance (character_id, appearance_name, hair_id, eyes_id) 
VALUES (3, 'Formal Wizard', 1, 3);

-- ============================================================================
-- INSERT EQUIPMENT DATA (1:* relationship - multiple equipment per character)
-- ============================================================================

-- Sir Lancelot has 2 equipment loadouts
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (1, 'Combat', 1, 1, 1);
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (1, 'Ceremonial', 2, 1, 1);

-- Shadow has 3 equipment loadouts
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (2, 'Stealth', 3, 1, 2);
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (2, 'Combat', 3, 2, 1);
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (2, 'Social', 2, 1, 2);

-- Aldor has 2 equipment loadouts
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (3, 'Magical Staff', 2, 3, 1);
INSERT INTO Equipment (character_id, equipment_name, armor_id, weapon_id, cape_id) 
VALUES (3, 'Combat Wand', 2, 1, 1);
