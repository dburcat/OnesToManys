# SQLite Master-Detail Database Schema Documentation

## Overview

This database implements a **complete master-detail architecture** for managing RPG characters with their equipment, appearance, and ability scores. The schema enforces strict one-to-one relationships:

- **Master: Character** — the root entity containing a character name
- **Details:**
  - **Equipment** — one equipment set per character (references exactly one Armor, one Weapon, one Cape)
  - **Appearance** — one appearance profile per character (references exactly one Hair style, one Eye color)
  - **Stats** — one ability score set per character (Str, Dex, Con, Int, Wis, Cha)
- **Lookup Tables** — Armor, Weapon, Cape, Hair, Eyes (reference data that can be shared across characters)

## Master-Detail Relationships

### Character → Equipment → {Armor, Weapon, Cape}

**Master: Character**
- Root entity. Each character has a unique identity and name.
- One-to-one relationship with Equipment, Appearance, and Stats (enforced by UNIQUE constraints).

**Detail: Equipment**
- Stores one character's equipment set
- **References exactly ONE each of:**
  - **Armor** — one specific armor type (Heavy, Medium, Light, etc.)
  - **Weapon** — one specific weapon type (Sword, GreatSword, Spear, etc.)
  - **Cape** — one specific cape length (Long, Short, etc.)
- Cannot be NULL (all three references are required)
- CASCADE: Deleting Equipment would cascade if Character had ON DELETE CASCADE, but Character UNIQUE ensures 1:1

**Key Properties:**
- Equipment always has exactly one armor, weapon, and cape
- Armor/Weapon/Cape tables are shared lookups (multiple characters can have the same armor type)
- Type safety through foreign keys to lookup tables

### Character → Appearance → {Hair, Eyes}

**Detail: Appearance**
- Stores one character's appearance profile
- **References exactly ONE each of:**
  - **Hair** — one hair style (Long, Short, etc.)
  - **Eyes** — one eye color (Blue, Green, Red, etc.)
- Cannot be NULL (both references are required)

**Key Properties:**
- Appearance always has exactly one hair style and one eye color
- Hair/Eyes tables are shared lookups (multiple characters can have the same hair style or eye color)
- Each appearance is unique to one character (UNIQUE constraint on appearance_id in Character)

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

### Strict One-to-One Relationships
- **Character ↔ Equipment** — UNIQUE constraint ensures one character has exactly one equipment set
- **Character ↔ Appearance** — UNIQUE constraint ensures one character has exactly one appearance
- **Character ↔ Stats** — UNIQUE constraint ensures one character has exactly one stats set
- **Equipment ↔ Armor/Weapon/Cape** — NOT NULL foreign keys ensure equipment always has all three

### Referential Integrity
- All detail tables enforce **foreign key constraints** to their references
- **Character.equipment_id, Character.appearance_id, Character.stats_id** → NOT NULL, UNIQUE
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

### Query Optimization
- **Foreign key indexes** created on:
  - Character.equipment_id, Character.appearance_id, Character.stats_id
  - Equipment.armor_id, Equipment.weapon_id, Equipment.cape_id
  - Appearance.hair_id, Appearance.eyes_id
- Indexes speed up JOIN operations for retrieving character details

## Table Reference

### Character (Master)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| character_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| name | TEXT | NOT NULL | Character name |
| equipment_id | INTEGER | NOT NULL UNIQUE, FK→Equipment | One equipment set per character |
| appearance_id | INTEGER | NOT NULL UNIQUE, FK→Appearance | One appearance per character |
| stats_id | INTEGER | NOT NULL UNIQUE, FK→Stats | One stats set per character |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last modification timestamp |

### Equipment (Detail)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| equipment_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
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

### Appearance (Detail)
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| appearance_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
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

### 1. Get a Single Character with All Details
```sql
SELECT c.character_id, c.name, 
       e.equipment_id, a.armor_type, w.weapon_type, cp.cape_length,
       ap.appearance_id, h.hair_style, ey.eye_color,
       s.strength, s.dexterity, s.constitution, s.intelligence, s.wisdom, s.charisma
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
JOIN Cape cp ON e.cape_id = cp.cape_id
JOIN Appearance ap ON c.appearance_id = ap.appearance_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
JOIN Stats s ON c.stats_id = s.stats_id
WHERE c.character_id = 1;
```

### 2. Get All Characters with Summary (Equipment + Appearance + Ability Scores)
```sql
SELECT c.character_id, c.name, 
       a.armor_type, w.weapon_type, cp.cape_length,
       h.hair_style, ey.eye_color,
       (s.strength + s.dexterity + s.constitution + s.intelligence + s.wisdom + s.charisma) as total_stats
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
JOIN Cape cp ON e.cape_id = cp.cape_id
JOIN Appearance ap ON c.appearance_id = ap.appearance_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
JOIN Stats s ON c.stats_id = s.stats_id
ORDER BY c.character_id;
```

### 3. Find Characters with Specific Equipment
```sql
SELECT c.character_id, c.name, a.armor_type
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
WHERE a.armor_type = 'Heavy';
```

### 4. Find Characters with High Ability Scores
```sql
SELECT c.character_id, c.name, s.strength, s.dexterity, s.constitution
FROM Character c
JOIN Stats s ON c.stats_id = s.stats_id
WHERE s.strength > 15 OR s.dexterity > 15
ORDER BY s.strength DESC, s.dexterity DESC;
```

### 5. List All Available Equipment Variants (Lookup Data)
```sql
SELECT 'Armor' as type, armor_type as variant_name, description FROM Armor
UNION ALL
SELECT 'Weapon', weapon_type, description FROM Weapon
UNION ALL
SELECT 'Cape', cape_length, description FROM Cape
ORDER BY type, variant_name;
```

### 6. Count Characters by Armor Type
```sql
SELECT a.armor_type, COUNT(c.character_id) as character_count
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
GROUP BY a.armor_type
ORDER BY character_count DESC;
```

### 7. Find Most Popular Hair/Eye Combinations
```sql
SELECT h.hair_style, ey.eye_color, COUNT(c.character_id) as count
FROM Character c
JOIN Appearance ap ON c.appearance_id = ap.appearance_id
JOIN Hair h ON ap.hair_id = h.hair_id
JOIN Eyes ey ON ap.eyes_id = ey.eyes_id
GROUP BY h.hair_style, ey.eye_color
ORDER BY count DESC;
```

### 8. Test Referential Integrity (Orphaned Record Test)
```sql
-- This will FAIL (as intended) because armor_id=999 doesn't exist
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (999, 1, 1);
-- Error: FOREIGN KEY constraint failed
```

### 9. Check Character Modification Times
```sql
SELECT character_id, name, created_at, updated_at,
       CAST((julianday(updated_at) - julianday(created_at)) * 24 * 60 as INTEGER) as minutes_since_creation
FROM Character
ORDER BY updated_at DESC;
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

## Phase 1 Implementation Checklist

- [x] **Master-Detail Hierarchy** — Character → Equipment/Appearance/Stats
  - [x] Character table with UNIQUE constraints on equipment_id, appearance_id, stats_id
  - [x] Equipment detail table with NOT NULL FKs to Armor/Weapon/Cape
  - [x] Appearance detail table with NOT NULL FKs to Hair/Eyes
  - [x] Stats detail table with all 6 ability scores
  
- [x] **Lookup Tables** — Armor, Weapon, Cape, Hair, Eyes
  - [x] Each stores single variant name (armor_type, weapon_type, cape_length, hair_style, eye_color)
  - [x] Shareable across characters (no UNIQUE constraints)
  
- [x] **Foreign Key Constraints** — Referential Integrity
  - [x] PRAGMA foreign_keys = ON in schema
  - [x] All detail/equipment FKs are NOT NULL (cannot create orphaned records)
  - [x] Foreign key violations raise errors (no silent failures)
  
- [x] **Timestamps** — Audit Trail
  - [x] created_at and updated_at on all tables
  - [x] Auto-update triggers for updated_at
  
- [x] **Indexes** — Query Performance
  - [x] Indexes on all foreign key columns for fast JOINs

### Next Steps for Phase 2

1. **REST API Endpoints** — CRUD operations for Character, Equipment, Appearance, Stats
   - GET /characters — list all
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
                            └── UNIQUE: equipment_id, appearance_id, stats_id

                         /          |          \
                        /           |           \
         EQUIPMENT      /    APPEARANCE      STATS
         (Detail)      /      (Detail)       (Detail)
         ├── armor_id (FK)   ├── hair_id (FK)    ├── strength
         ├── weapon_id (FK)  ├── eyes_id (FK)    ├── dexterity
         └── cape_id (FK)    └─ columns         ├── constitution
                                                 ├── intelligence
              /|\                /|\               ├── wisdom
             / | \              / | \              └── charisma
            /  |  \            /  |  \
       ARMOR WEAPON CAPE  HAIR EYES  (Lookup)
       (Lookup tables shared across characters)
```

---

**Database Version:** 2.0 (Character-centric)  
**Created:** March 30, 2026  
**SQLite Version:** 3.x+  
**Target Platform:** Phase 1-3 ListDetails Web Application (OnesToManys)
