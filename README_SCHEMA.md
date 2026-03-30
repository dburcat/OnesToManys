# SQLite Master-Detail Database Schema Documentation

## Overview

This database implements a **flexible master-detail architecture** for managing RPG characters with multiple equipment loadouts, multiple appearances, and fixed ability scores:

- **Master: Character** — the root entity containing a character name
- **Details:**
  - **Equipment** — **[ONE-TO-MANY]** multiple equipment sets per character (each references one Armor, one Weapon, one Cape)
  - **Appearance** — **[ONE-TO-MANY]** multiple appearance profiles per character (each references one Hair style, one Eye color)
  - **Stats** — [1:1] one ability score set per character (Str, Dex, Con, Int, Wis, Cha)
- **Lookup Tables** — Armor, Weapon, Cape, Hair, Eyes (reference data that can be shared across characters, equipment sets, and appearances)

## Master-Detail Relationships

### Character → Equipment (ONE-TO-MANY) ⭐ New!

**Master: Character**
- Root entity. Each character has a unique identity and name.
- One-to-many relationship with Equipment (character can have multiple loadouts)
- One-to-one relationship with Appearance and Stats (enforced by UNIQUE constraints)

**Detail: Equipment** [Supports Multiple Records Per Character]
- Stores a character's equipment set/loadout
- Each equipment set has a descriptive name (e.g., "Combat", "Stealth", "Social", "Ceremonial")
- **References exactly ONE each of:**
  - **Armor** — one specific armor type (Heavy, Medium, Light, etc.)
  - **Weapon** — one specific weapon type (Sword, GreatSword, Spear, etc.)
  - **Cape** — one specific cape length (Long, Short, etc.)
- All foreign keys are NOT NULL (equipment cannot be incomplete)

**Key Properties:**
- **character_id** is NOT NULL, allowing multiple Equipment records per Character
- Each Equipment has a unique combination of armor_id, weapon_id, cape_id
- Armor/Weapon/Cape tables are shared lookups (multiple equipment sets can use the same armor type)
- Example: Sir Lancelot can have a "Combat" loadout (Heavy Armor, Sword, Long Cape) AND a "Ceremonial" loadout (Medium Armor, Sword, Long Cape)

### Character → Appearance (ONE-TO-MANY) ⭐

**Detail: Appearance** [Supports Multiple Records Per Character]
- Stores a character's appearance profile/look
- Each appearance has a descriptive name (e.g., "Casual", "Battle Ready", "Formal", "Disguise")
- **References exactly ONE each of:**
  - **Hair** — one specific hair style (Long, Short, Wavy, etc.)
  - **Eyes** — one specific eye color (Blue, Green, Brown, etc.)
- All foreign keys are NOT NULL (appearance cannot be incomplete)

**Key Properties:**
- **character_id** is NOT NULL, allowing multiple Appearance records per Character
- Hair/Eyes tables are shared lookups (multiple characters and appearance sets can use the same hair style or eye color)
- Example: Shadow can have a "Casual" appearance (Short hair, Green eyes) AND a "Disguise" appearance (Long hair, Brown eyes)

### Character → Stats

**Detail: Stats**
- Stores one character's ability scores (D&D format)
- **Contains:**
  - Strength (INT)
  - Dexterity (INT)
  - Constitution (INT)
  - Intelligence (INT)
  - Wisdom (INT)
  - Charisma (INT)
- All values are NOT NULL (required)

**Key Properties:**
- One Stats record per character (enforced by UNIQUE constraint on stats_id in Character)
- All ability scores must be defined (no NULL values)

## Database Features

### One-to-Many Relationships
- **Character → Equipment** — Multiple equipment sets per character (enabled by character_id FK in Equipment table)
- **Character → Appearance** — Multiple appearance profiles per character (enabled by character_id FK in Appearance table)
- One-to-One Relationships
- **Character ↔ Stats** — UNIQUE constraint ensures one stats set per character
- **Equipment ↔ Armor/Weapon/Cape** — NOT NULL foreign keys ensure each equipment set has exactly one of each
- **Appearance ↔ Hair/Eyes** — NOT NULL foreign keys ensure each appearance has exactly one hair style and eye color

### Referential Integrity
- All detail tables enforce **foreign key constraints** to their references
- **Equipment.character_id, Appearance.character_id** → NOT NULL (enables 1:* relationships)
- **Character.stats_id** → NOT NULL UNIQUE (enforces 1:1 relationship)
- **Equipment.armor_id, Equipment.weapon_id, Equipment.cape_id** → NOT NULL (cannot be orphaned)
- **Appearance.hair_id, Appearance.eyes_id** → NOT NULL (cannot be orphaned)
- No ON DELETE CASCADE (prevents accidental data loss). Foreign key violations raise errors.

### Timestamp Tracking
- All tables include `created_at` and `updated_at` columns
- **Automatic timestamp management** via triggers:
  - `created_at` defaults to CURRENT_TIMESTAMP on INSERT
  - `updated_at` auto-updates on every UPDATE via triggers
- Useful for audit logging and Phase 3 UI (showing "Last Modified" dates)

### Type Safety
- All NOT NULL constraints on required fields
- All lookup tables store single variant names (armor_type, weapon_type, cape_length, hair_style, eye_color)
- Descriptive names on detail tables (equipment_name, appearance_name) distinguish between multiple records

### Query Optimization
- **Foreign key indexes** created on:
  - Equipment.character_id (for fast lookup of all equipment by character) ⭐
  - Appearance.character_id (for fast lookup of all appearances by character) ⭐
  - Character.stats_id
  - Equipment.armor_id, Equipment.weapon_id, Equipment.cape_id
  - Appearance.hair_id, Appearance.eyes_id
- Indexes speed up JOIN operations for retrieving character details and multiple equipment/appearance sets

## Table Reference

### Character (Master)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| character_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| name | TEXT | NOT NULL | Character name |
| stats_id | INTEGER | NOT NULL UNIQUE, FK→Stats | One stats set per character |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Equipment (Detail) [ONE-TO-MANY]
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| equipment_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| character_id | INTEGER | NOT NULL, FK→Character | Links to character (allows multiple equipment per character) ⭐ |
| equipment_name | TEXT | NOT NULL DEFAULT 'Default Loadout' | Name of this equipment set (e.g., "Combat", "Stealth", "Social") |
| armor_id | INTEGER | NOT NULL, FK→Armor | References one armor type |
| weapon_id | INTEGER | NOT NULL, FK→Weapon | References one weapon type |
| cape_id | INTEGER | NOT NULL, FK→Cape | References one cape length |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Armor (Lookup)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| armor_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| armor_type | TEXT | NOT NULL | Armor variant (e.g., "Heavy", "Medium", "Light") |
| description | TEXT | nullable | Description of armor type |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Weapon (Lookup)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| weapon_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| weapon_type | TEXT | NOT NULL | Weapon variant (e.g., "Sword", "GreatSword", "Spear") |
| description | TEXT | nullable | Description of weapon type |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Cape (Lookup)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| cape_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| cape_length | TEXT | NOT NULL | Cape variant (e.g., "Long", "Short") |
| description | TEXT | nullable | Description of cape length |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Appearance (Detail) [ONE-TO-MANY]
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| appearance_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| character_id | INTEGER | NOT NULL, FK→Character | Links to character (allows multiple appearances per character) ⭐ |
| appearance_name | TEXT | NOT NULL DEFAULT 'Default Appearance' | Name of this appearance profile (e.g., "Casual", "Battle Ready", "Disguise") |
| hair_id | INTEGER | NOT NULL, FK→Hair | References one hair style |
| eyes_id | INTEGER | NOT NULL, FK→Eyes | References one eye color |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Hair (Lookup)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| hair_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| hair_style | TEXT | NOT NULL | Hair variant (e.g., "Long", "Short") |
| description | TEXT | nullable | Description of hair style |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Eyes (Lookup)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| eyes_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| eye_color | TEXT | NOT NULL | Eye color variant (e.g., "Blue", "Green", "Red") |
| description | TEXT | nullable | Description of eye color |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Stats (Detail)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| stats_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| strength | INTEGER | NOT NULL | Strength ability score |
| dexterity | INTEGER | NOT NULL | Dexterity ability score |
| constitution | INTEGER | NOT NULL | Constitution ability score |
| intelligence | INTEGER | NOT NULL | Intelligence ability score |
| wisdom | INTEGER | NOT NULL | Wisdom ability score |
| charisma | INTEGER | NOT NULL | Charisma ability score |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

## Example Queries

### 1. Get a Single Character with ALL Their Equipment Loadouts ⭐
```sql
-- Show one character with ALL their equipment sets (1:* Equipment relationship)
SELECT c.character_id, c.name, 
       e.equipment_id, e.equipment_name,
       a.armor_type, w.weapon_type, cp.cape_length
FROM Character c
JOIN Equipment e ON c.character_id = e.character_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
JOIN Cape cp ON e.cape_id = cp.cape_id
WHERE c.character_id = 1
ORDER BY e.equipment_id;
```

### 2. Get a Single Character with ALL Their Appearance Profiles ⭐
```sql
-- Show one character with ALL their appearance profiles (1:* Appearance relationship)
SELECT c.character_id, c.name, 
       ap.appearance_id, ap.appearance_name,
       h.hair_style, ey.eye_color
FROM Character c
JOIN Appearance ap ON c.character_id = ap.character_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
WHERE c.character_id = 1
ORDER BY ap.appearance_id;
```

### 3. Get Character Summary with Equipment AND Appearance Counts ⭐
```sql
-- Count how many equipment sets AND appearance profiles each character has
SELECT c.character_id, c.name, 
       COUNT(DISTINCT e.equipment_id) as equipment_count,
       COUNT(DISTINCT ap.appearance_id) as appearance_count,
       (s.strength + s.dexterity + s.constitution + s.intelligence + s.wisdom + s.charisma) as total_stats
FROM Character c
LEFT JOIN Equipment e ON c.character_id = e.character_id
LEFT JOIN Appearance ap ON c.character_id = ap.character_id
JOIN Stats s ON c.stats_id = s.stats_id
GROUP BY c.character_id, c.name
ORDER BY c.character_id;
```

### 4. Show All Equipment × Appearance Combinations for One Character (Cartesian Product) ⭐
```sql
-- Show every possible combination of equipment loadouts and appearances for a character
-- Useful for game UI showing all outfit permutations
SELECT 
  c.name,
  e.equipment_name,
  a.armor_type, w.weapon_type, cp.cape_length,
  ap.appearance_name,
  h.hair_style, ey.eye_color
FROM Character c
JOIN Equipment e ON c.character_id = e.character_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
JOIN Cape cp ON e.cape_id = cp.cape_id
JOIN Appearance ap ON c.character_id = ap.character_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
WHERE c.character_id = 2
ORDER BY e.equipment_id, ap.appearance_id;
```

### 5. Find All Characters with a Specific Loadout Name
```sql
SELECT c.character_id, c.name, e.equipment_name, a.armor_type, w.weapon_type
FROM Character c
JOIN Equipment e ON c.character_id = e.character_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
WHERE e.equipment_name = 'Combat';
```

### 6. Find Characters with Heavy Armor in ANY Loadout
```sql
-- One character might have Heavy armor in "Combat" but Medium in "Social"
SELECT DISTINCT c.character_id, c.name, a.armor_type
FROM Character c
JOIN Equipment e ON c.character_id = e.character_id
JOIN Armor a ON e.armor_id = a.armor_id
WHERE a.armor_type = 'Heavy'
ORDER BY c.character_id;
```

### 7. Compare Character Loadouts (All Equipment for One Character)
```sql
SELECT 
  c.name,
  e.equipment_name,
  a.armor_type as armor,
  w.weapon_type as weapon,
  cp.cape_length as cape
FROM Character c
JOIN Equipment e ON c.character_id = e.character_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
JOIN Cape cp ON e.cape_id = cp.cape_id
WHERE c.character_id = 2
ORDER BY e.equipment_name;
```

### 8. Find Characters with High Ability Scores
```sql
SELECT c.character_id, c.name, s.strength, s.dexterity, s.constitution
FROM Character c
JOIN Stats s ON c.stats_id = s.stats_id
WHERE s.strength > 15 OR s.dexterity > 15
ORDER BY s.strength DESC, s.dexterity DESC;
```

### 9. List All Available Equipment Variants (Lookup Data)
```sql
SELECT 'Armor' as type, armor_type as variant_name, description FROM Armor
UNION ALL
SELECT 'Weapon', weapon_type, description FROM Weapon
UNION ALL
SELECT 'Cape', cape_length, description FROM Cape
ORDER BY type, variant_name;
```

### 10. List All Available Appearance Variants (Lookup Data)
```sql
SELECT 'Hair' as type, hair_style as variant_name, description FROM Hair
UNION ALL
SELECT 'Eyes', eye_color, description FROM Eyes
ORDER BY type, variant_name;
```

### 11. Most Common Equipment Combinations
```sql
-- Find the most frequently used armor-weapon combinations across all loadouts
SELECT a.armor_type, w.weapon_type, COUNT(*) as usage_count
FROM Equipment e
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
GROUP BY a.armor_type, w.weapon_type
ORDER BY usage_count DESC;
```

### 9. Find Most Popular Hair/Eye Combinations
```sql
SELECT h.hair_style, ey.eye_color, COUNT(c.character_id) as character_count
FROM Character c
JOIN Appearance ap ON c.appearance_id = ap.appearance_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
GROUP BY h.hair_style, ey.eye_color
ORDER BY character_count DESC;
```

### 10. Test Referential Integrity (Orphaned Record Test)
```sql
-- This will FAIL (as intended) because armor_id=999 doesn't exist
INSERT INTO Equipment (character_id, armor_id, weapon_id, cape_id) VALUES (1, 999, 1, 1);
-- Error: FOREIGN KEY constraint failed
```

### 11. Show Total Equipment Sets per Character
```sql
SELECT c.character_id, c.name, COUNT(e.equipment_id) as total_loadouts
FROM Character c
LEFT JOIN Equipment e ON c.character_id = e.character_id
GROUP BY c.character_id, c.name
ORDER BY total_loadouts DESC, c.name;
```

### 12. Check Equipment and Character Modification Times
```sql
SELECT c.character_id, c.name, c.updated_at as character_updated,
       COUNT(e.equipment_id) as equipment_count,
       MAX(e.updated_at) as latest_equipment_update
FROM Character c
LEFT JOIN Equipment e ON c.character_id = e.character_id
GROUP BY c.character_id
ORDER BY c.updated_at DESC;
```

### 10. List All Lookup Values with Usage Count
```sql
SELECT 'Armor' as type, armor_type, COUNT(DISTINCT e.equipment_id) as use_count
FROM Armor a
LEFT JOIN Equipment e ON a.armor_id = e.armor_id
GROUP BY armor_type
UNION ALL
SELECT 'Hair', hair_style, COUNT(DISTINCT ap.appearance_id)
FROM Hair h
LEFT JOIN Appearance ap ON h.hair_id = ap.hair_id
GROUP BY hair_style
UNION ALL
SELECT 'Eyes', eye_color, COUNT(DISTINCT ap.appearance_id)
FROM Eyes e
LEFT JOIN Appearance ap ON e.eyes_id = ap.eyes_id
GROUP BY eye_color
ORDER BY type, use_count DESC;
```

## Phase 1 Implementation Checklist ⭐ Updated for 1:*

- [x] **Master-Detail Hierarchy** — Character → [Multiple Equipment] / Appearance / Stats
  - [x] Character table (no equipment_id; it's now in Equipment table)
  - [x] Equipment detail table with NOT NULL character_id (supports multiple equipment per character) ⭐
  - [x] Equipment has equipment_name to distinguish loadouts ("Combat", "Stealth", etc.)
  - [x] Equipment table with NOT NULL FKs to Armor/Weapon/Cape
  - [x] Appearance detail table with NOT NULL FKs to Hair/Eyes (still 1:1)
  - [x] Stats detail table with all 6 ability scores (still 1:1)
  
- [x] **Lookup Tables** — Armor, Weapon, Cape, Hair, Eyes
  - [x] Each stores single variant name (armor_type, weapon_type, cape_length, hair_style, eye_color)
  - [x] Shareable across characters AND equipment sets (no UNIQUE constraints)
  
- [x] **Foreign Key Constraints** — Referential Integrity
  - [x] PRAGMA foreign_keys = ON in schema
  - [x] Equipment.character_id NOT NULL (links back to Character)
  - [x] All armor/weapon/cape FKs are NOT NULL (cannot create incomplete equipment)
  - [x] Foreign key violations raise errors (no silent failures)
  
- [x] **Timestamps** — Audit Trail
  - [x] created_at and updated_at on all tables including Equipment
  - [x] Auto-update triggers for updated_at
  
- [x] **Indexes** — Query Performance
  - [x] Indexes on Equipment.character_id (for fast lookup of all equipment by character) ⭐

### Next Steps for Phase 2

1. **REST API Endpoints** — CRUD operations for Character, Equipment, Appearance, Stats
   - GET /characters — list all (with equipment count)
   - GET /characters/{id} — get full character with all details
   - POST /characters — create new character
   - PUT /characters/{id} — update character
   - DELETE /characters/{id} — delete character (cascades to Equipment, Appearance, Stats)

2. **Equipment Management** — Change a character's gear
   - PUT /characters/{id}/equipment — change armor/weapon/cape
   - GET /equipment/armor — list available armor types
   - GET /equipment/weapons — list available weapons
   - GET /equipment/capes — list available capes

3. **Appearance Management** — Change a character's look
   - PUT /characters/{id}/appearance — change hair/eyes
   - GET /appearance/hair — list hair styles
   - GET /appearance/eyes — list eye colors

4. **Ability Scores** — Manage character stats
   - PUT /characters/{id}/stats — update ability scores

### Next Steps for Phase 3

1. **UI Components** — Master-detail views
   - Character list view (all characters)
   - Character detail view (single character with all info)
   - Equipment/Appearance editors (dropdown selectors for variants)
   - Ability score input form

2. **Data Relationships** — Display navigation
   - Character → Equipment (show current armor/weapon/cape)
   - Character → Appearance (show current hair/eyes)
   - Character → Stats (show ability scores)

3. **Audit Trail** — modified_at display
   - Show "Last modified" time on character detail page
   - Track creation and modification timestamps

## Installation & Validation

### Create Database from Schema

```bash
# Remove any existing database
rm -f character_equipment.db

# Create fresh database with schema
sqlite3 character_equipment.db < schema.sql

# Verify tables created
sqlite3 character_equipment.db ".tables"

# Expected output: Appearance Cape Character Equipment Eyes Hair Stats Weapon Armor
```

### Load Sample Data

```bash
# Load the sample character data
sqlite3 character_equipment.db < sample_data.sql

# Verify data loaded
sqlite3 character_equipment.db "SELECT COUNT(*) FROM Character;"
# Expected output: 3
```

### Test Foreign Key Constraints

```bash
# Create a test file
echo "PRAGMA foreign_keys = ON;
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (999, 1, 1);" > test_fk.sql

# Run test (should fail with FOREIGN KEY constraint error)
sqlite3 character_equipment.db < test_fk.sql

# Expected error: FOREIGN KEY constraint failed
```

### Verify Master-Detail Relationships

```bash
# Run a comprehensive character query
sqlite3 character_equipment.db < sample_queries.sql

# Or manually query:
sqlite3 character_equipment.db "
SELECT c.character_id, c.name, e.equipment_id, a.armor_type, w.weapon_type
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
LIMIT 5;"
```

## Files in This Module

- **schema.sql** — Core table definitions, foreign keys, constraints, and auto-update triggers
  - Creates 8 tables: Character, Equipment, Armor, Weapon, Cape, Appearance, Hair, Eyes, Stats
  - Enforces PRAGMA foreign_keys = ON
  - Includes 9 auto-update triggers for timestamps
  
- **relationships.sql** — Indexes, relationship documentation, and recommended Phase 2 queries
  - Foreign key indexes for JOINs performance
  - Relationship documentation with cardinality notes
  - Recommended REST API endpoint queries
  
- **sample_data.sql** — Test data with 3 sample characters
  - Populates lookup tables (Armor, Weapon, Cape, Hair, Eyes)
  - Creates 3 complete characters (Sir Lancelot, Shadow, Aldor)
  - Demonstrates proper foreign key relationships
  
- **README_SCHEMA.md** — This comprehensive documentation with diagrams and examples

## Architecture Diagram

```
                            CHARACTER (Master)
                            ├── character_id (PK)
                            ├── name
                            └── UNIQUE: stats_id

                    /                    |                    \
                   /                     |                     \
         EQUIPMENT [1:*]     APPEARANCE [1:*]              STATS [1:1]
         (Multiple Loadouts)  (Multiple Looks)             (Detail)
         ├── character_id★    ├── character_id★            ├── strength
         ├── equipment_name   ├── appearance_name          ├── dexterity
         ├── armor_id (FK)    ├── hair_id (FK)            ├── constitution
         ├── weapon_id (FK)   ├── eyes_id (FK)            ├── intelligence
         └── cape_id (FK)     └─ columns                  ├── wisdom
                                                           └── charisma
              /|\              /|\
             / | \            / | \
        ARMOR WEAPON CAPE   HAIR EYES  (Lookup tables)
        (Shared across characters and equipment sets/appearances)

★ character_id FK enables the 1:* relationship (multiple records per character)
Note: Equipment and Appearance are independent 1:* relationships
A character with 2 equipment sets and 3 appearances creates 6 combined outfit combinations
```

---

**Database Version:** 3.1 (One-to-Many Equipment AND Appearance)  
**Created:** March 30, 2026  
**Updated:** [Current Date]  
**SQLite Version:** 3.x+  
**Target Platform:** Phase 1-3 ListDetails Web Application (OnesToManys)
