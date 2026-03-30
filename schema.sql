-- SQLite Master-Detail Database Schema
-- Character Equipment & Appearance System with ONE-TO-MANY Equipment
-- Created: March 30, 2026

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ============================================================================
-- MASTER TABLE: Character
-- ============================================================================
-- Represents a character with multiple equipment sets, multiple appearances, and one stats set
CREATE TABLE Character (
    character_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    stats_id INTEGER NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (stats_id) REFERENCES Stats(stats_id)
);

-- ============================================================================
-- ARMOR LOOKUP TABLE (Detail type for Equipment.armor)
-- ============================================================================
-- Individual armor variants/types
CREATE TABLE Armor (
    armor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    armor_type TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- WEAPON LOOKUP TABLE (Detail type for Equipment.weapon)
-- ============================================================================
-- Individual weapon variants/types
CREATE TABLE Weapon (
    weapon_id INTEGER PRIMARY KEY AUTOINCREMENT,
    weapon_type TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- CAPE LOOKUP TABLE (Detail type for Equipment.cape)
-- ============================================================================
-- Individual cape variants/lengths
CREATE TABLE Cape (
    cape_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cape_length TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- DETAIL TABLE: Equipment
-- ============================================================================
-- Equipment set for a character - a character can have MULTIPLE equipment sets (loadouts)
-- Each equipment set references exactly ONE armor, ONE weapon, ONE cape
CREATE TABLE Equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    character_id INTEGER NOT NULL,
    equipment_name TEXT NOT NULL DEFAULT 'Default Loadout',
    armor_id INTEGER NOT NULL,
    weapon_id INTEGER NOT NULL,
    cape_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES Character(character_id),
    FOREIGN KEY (armor_id) REFERENCES Armor(armor_id),
    FOREIGN KEY (weapon_id) REFERENCES Weapon(weapon_id),
    FOREIGN KEY (cape_id) REFERENCES Cape(cape_id)
);

-- ============================================================================
-- HAIR LOOKUP TABLE (Detail type for Appearance.hair)
-- ============================================================================
-- Individual hair style variants
CREATE TABLE Hair (
    hair_id INTEGER PRIMARY KEY AUTOINCREMENT,
    hair_style TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- EYES LOOKUP TABLE (Detail type for Appearance.eyes)
-- ============================================================================
-- Individual eye color variants
CREATE TABLE Eyes (
    eyes_id INTEGER PRIMARY KEY AUTOINCREMENT,
    eye_color TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- DETAIL TABLE: Appearance
-- ============================================================================
-- Appearance set for a character - a character can have MULTIPLE appearances (different looks/outfits)
-- Each appearance references exactly ONE hair style and ONE eye color
CREATE TABLE Appearance (
    appearance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    character_id INTEGER NOT NULL,
    appearance_name TEXT NOT NULL DEFAULT 'Default Appearance',
    hair_id INTEGER NOT NULL,
    eyes_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES Character(character_id),
    FOREIGN KEY (hair_id) REFERENCES Hair(hair_id),
    FOREIGN KEY (eyes_id) REFERENCES Eyes(eyes_id)
);

-- ============================================================================
-- DETAIL TABLE: Stats
-- ============================================================================
-- Character ability scores - one set per character
CREATE TABLE Stats (
    stats_id INTEGER PRIMARY KEY AUTOINCREMENT,
    strength INTEGER NOT NULL,
    dexterity INTEGER NOT NULL,
    constitution INTEGER NOT NULL,
    intelligence INTEGER NOT NULL,
    wisdom INTEGER NOT NULL,
    charisma INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES: Foreign Key Lookups and Query Optimization
-- ============================================================================

CREATE INDEX idx_character_stats_id ON Character(stats_id);

CREATE INDEX idx_equipment_character_id ON Equipment(character_id);
CREATE INDEX idx_equipment_armor_id ON Equipment(armor_id);
CREATE INDEX idx_equipment_weapon_id ON Equipment(weapon_id);
CREATE INDEX idx_equipment_cape_id ON Equipment(cape_id);

CREATE INDEX idx_appearance_character_id ON Appearance(character_id);
CREATE INDEX idx_appearance_hair_id ON Appearance(hair_id);
CREATE INDEX idx_appearance_eyes_id ON Appearance(eyes_id);

-- ============================================================================
-- TRIGGERS: Auto-update updated_at timestamp on any record change
-- ============================================================================

CREATE TRIGGER character_update_timestamp
AFTER UPDATE ON Character
BEGIN
    UPDATE Character SET updated_at = CURRENT_TIMESTAMP WHERE character_id = NEW.character_id;
END;

CREATE TRIGGER equipment_update_timestamp
AFTER UPDATE ON Equipment
BEGIN
    UPDATE Equipment SET updated_at = CURRENT_TIMESTAMP WHERE equipment_id = NEW.equipment_id;
END;

CREATE TRIGGER appearance_update_timestamp
AFTER UPDATE ON Appearance
BEGIN
    UPDATE Appearance SET updated_at = CURRENT_TIMESTAMP WHERE appearance_id = NEW.appearance_id;
END;

CREATE TRIGGER stats_update_timestamp
AFTER UPDATE ON Stats
BEGIN
    UPDATE Stats SET updated_at = CURRENT_TIMESTAMP WHERE stats_id = NEW.stats_id;
END;

CREATE TRIGGER armor_update_timestamp
AFTER UPDATE ON Armor
BEGIN
    UPDATE Armor SET updated_at = CURRENT_TIMESTAMP WHERE armor_id = NEW.armor_id;
END;

CREATE TRIGGER weapon_update_timestamp
AFTER UPDATE ON Weapon
BEGIN
    UPDATE Weapon SET updated_at = CURRENT_TIMESTAMP WHERE weapon_id = NEW.weapon_id;
END;

CREATE TRIGGER cape_update_timestamp
AFTER UPDATE ON Cape
BEGIN
    UPDATE Cape SET updated_at = CURRENT_TIMESTAMP WHERE cape_id = NEW.cape_id;
END;

CREATE TRIGGER hair_update_timestamp
AFTER UPDATE ON Hair
BEGIN
    UPDATE Hair SET updated_at = CURRENT_TIMESTAMP WHERE hair_id = NEW.hair_id;
END;

CREATE TRIGGER eyes_update_timestamp
AFTER UPDATE ON Eyes
BEGIN
    UPDATE Eyes SET updated_at = CURRENT_TIMESTAMP WHERE eyes_id = NEW.eyes_id;
END;

-- ============================================================================
-- MASTER-DETAIL RELATIONSHIP DOCUMENTATION
-- ============================================================================
-- 
-- Character (Master) [1] → [*] Equipment (Detail) — ONE-TO-MANY
--   - One Character can have MULTIPLE Equipment sets (different loadouts)
--   - Each Equipment references the Character via character_id FK
--   - Equipment can have a name to distinguish loadouts (e.g., "Combat", "Social", "Stealth")
--   - FOREIGN KEY ensures referential integrity
--
-- Character (Master) [1] → [*] Appearance (Detail) — ONE-TO-MANY
--   - One Character can have MULTIPLE Appearances (different looks/outfits)
--   - Each Appearance references the Character via character_id FK
--   - Appearance can have a name to distinguish looks (e.g., "Casual", "Battle Ready", "Formal")
--   - FOREIGN KEY ensures referential integrity
--
-- Character (Master) [1] → [1] Stats (Detail)
--   - One Character has exactly ONE Stats record
--   - UNIQUE constraint ensures strict 1:1 relationship
--   - FOREIGN KEY ensures referential integrity
--
-- Equipment (Detail) [1] → [1] Armor (Lookup)
--   - One Equipment set references exactly ONE Armor type
--   - FOREIGN KEY enforces referential integrity
--   - Cannot be NULL
--
-- Equipment (Detail) [1] → [1] Weapon (Lookup)
--   - One Equipment set references exactly ONE Weapon type
--   - FOREIGN KEY enforces referential integrity
--   - Cannot be NULL
--
-- Equipment (Detail) [1] → [1] Cape (Lookup)
--   - One Equipment set references exactly ONE Cape length
--   - FOREIGN KEY enforces referential integrity
--   - Cannot be NULL
--
-- Appearance (Detail) [1] → [1] Hair (Lookup)
--   - One Appearance references exactly ONE Hair style
--   - FOREIGN KEY ensures referential integrity
--   - Cannot be NULL
--
-- Appearance (Detail) [1] → [1] Eyes (Lookup)
--   - One Appearance references exactly ONE Eye color
--   - FOREIGN KEY ensures referential integrity
--   - Cannot be NULL