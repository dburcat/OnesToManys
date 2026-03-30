-- Useful Queries for Character Equipment & Appearance Database
-- These queries demonstrate common operations for Phase 2 REST API development

-- ============================================================================
-- QUERY 1: Get complete character profile (for REST GET /characters/{id})
-- ============================================================================
SELECT c.character_id, c.name, c.created_at, c.updated_at,
       -- Equipment details
       e.equipment_id, a.armor_type, w.weapon_type, cp.cape_length,
       -- Appearance details
       ap.appearance_id, h.hair_style, ey.eye_color,
       -- Stats details
       s.stats_id, s.strength, s.dexterity, s.constitution, 
       s.intelligence, s.wisdom, s.charisma
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

-- ============================================================================
-- QUERY 2: List all characters (for REST GET /characters)
-- ============================================================================
SELECT c.character_id, c.name, 
       a.armor_type, w.weapon_type, cp.cape_length,
       h.hair_style, ey.eye_color,
       (s.strength + s.dexterity + s.constitution + s.intelligence + s.wisdom + s.charisma) as total_stats,
       c.updated_at
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

-- ============================================================================
-- QUERY 3: Get all armor types with usage count (for REST GET /equipment/armor)
-- ============================================================================
SELECT a.armor_id, a.armor_type, a.description, 
       COUNT(DISTINCT e.equipment_id) as in_use_by_count
FROM Armor a
LEFT JOIN Equipment e ON a.armor_id = e.armor_id
GROUP BY a.armor_id, a.armor_type, a.description
ORDER BY a.armor_type;

-- ============================================================================
-- QUERY 4: Get all weapon types with usage count (for REST GET /equipment/weapons)
-- ============================================================================
SELECT w.weapon_id, w.weapon_type, w.description,
       COUNT(DISTINCT e.equipment_id) as in_use_by_count
FROM Weapon w
LEFT JOIN Equipment e ON w.weapon_id = e.weapon_id
GROUP BY w.weapon_id, w.weapon_type, w.description
ORDER BY w.weapon_type;

-- ============================================================================
-- QUERY 5: Get all cape lengths with usage count
-- ============================================================================
SELECT cp.cape_id, cp.cape_length, cp.description,
       COUNT(DISTINCT e.equipment_id) as in_use_by_count
FROM Cape cp
LEFT JOIN Equipment e ON cp.cape_id = e.cape_id
GROUP BY cp.cape_id, cp.cape_length, cp.description
ORDER BY cp.cape_length;

-- ============================================================================
-- QUERY 6: Get all hair styles with usage count (for REST GET /appearance/hair)
-- ============================================================================
SELECT h.hair_id, h.hair_style, h.description,
       COUNT(DISTINCT ap.appearance_id) as in_use_by_count
FROM Hair h
LEFT JOIN Appearance ap ON h.hair_id = ap.hair_id
GROUP BY h.hair_id, h.hair_style, h.description
ORDER BY h.hair_style;

-- ============================================================================
-- QUERY 7: Get all eye colors with usage count (for REST GET /appearance/eyes)
-- ============================================================================
SELECT ey.eyes_id, ey.eye_color, ey.description,
       COUNT(DISTINCT ap.appearance_id) as in_use_by_count
FROM Eyes ey
LEFT JOIN Appearance ap ON ey.eyes_id = ap.eyes_id
GROUP BY ey.eyes_id, ey.eye_color, ey.description
ORDER BY ey.eye_color;

-- ============================================================================
-- QUERY 8: Find characters by armor type (for REST GET /characters?armor=Heavy)
-- ============================================================================
SELECT c.character_id, c.name, a.armor_type
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
WHERE a.armor_type = 'Heavy'
ORDER BY c.name;

-- ============================================================================
-- QUERY 9: Find characters by weapon type (for REST GET /characters?weapon=Sword)
-- ============================================================================
SELECT c.character_id, c.name, w.weapon_type
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
WHERE w.weapon_type = 'Sword'
ORDER BY c.name;

-- ============================================================================
-- QUERY 10: Find characters with high ability scores (for REST GET /characters?min_strength=15)
-- ============================================================================
SELECT c.character_id, c.name, s.strength, s.dexterity, s.constitution
FROM Character c
JOIN Stats s ON c.stats_id = s.stats_id
WHERE s.strength > 15
ORDER BY s.strength DESC;

-- ============================================================================
-- QUERY 11: Get character statistics (for analytics/reporting)
-- ============================================================================
SELECT 
    COUNT(DISTINCT c.character_id) as total_characters,
    COUNT(DISTINCT e.armor_id) as unique_armor_types_in_use,
    COUNT(DISTINCT e.weapon_id) as unique_weapons_in_use,
    AVG(s.strength) as avg_strength,
    AVG(s.dexterity) as avg_dexterity,
    AVG(s.constitution) as avg_constitution,
    AVG(s.intelligence) as avg_intelligence,
    AVG(s.wisdom) as avg_wisdom,
    AVG(s.charisma) as avg_charisma
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Stats s ON c.stats_id = s.stats_id;

-- ============================================================================
-- QUERY 12: Get most popular armor-weapon combinations
-- ============================================================================
SELECT a.armor_type, w.weapon_type, COUNT(*) as combination_count
FROM Character c
JOIN Equipment e ON c.equipment_id = e.equipment_id
JOIN Armor a ON e.armor_id = a.armor_id
JOIN Weapon w ON e.weapon_id = w.weapon_id
GROUP BY a.armor_type, w.weapon_type
ORDER BY combination_count DESC;

-- ============================================================================
-- QUERY 13: Get characters sorted by modification time (for REST GET /characters?sort=recent)
-- ============================================================================
SELECT c.character_id, c.name, c.updated_at,
       CAST((julianday('now') - julianday(c.updated_at)) * 24 as INTEGER) as hours_since_update
FROM Character c
ORDER BY c.updated_at DESC;

-- ============================================================================
-- QUERY 14: Check for orphaned records (data integrity check)
-- ============================================================================
-- This query checks if any Equipment records reference non-existent Armor/Weapon/Cape
SELECT 'orphaned_armor' as issue, e.equipment_id FROM Equipment e
WHERE e.armor_id NOT IN (SELECT armor_id FROM Armor)
UNION ALL
SELECT 'orphaned_weapon', e.equipment_id FROM Equipment e
WHERE e.weapon_id NOT IN (SELECT weapon_id FROM Weapon)
UNION ALL
SELECT 'orphaned_cape', e.equipment_id FROM Equipment e
WHERE e.cape_id NOT IN (SELECT cape_id FROM Cape);

-- ============================================================================
-- QUERY 15: Validate referential integrity for Appearance
-- ============================================================================
-- This query checks if any Appearance records reference non-existent Hair/Eyes
SELECT 'orphaned_hair' as issue, ap.appearance_id FROM Appearance ap
WHERE ap.hair_id NOT IN (SELECT hair_id FROM Hair)
UNION ALL
SELECT 'orphaned_eyes', ap.appearance_id FROM Appearance ap
WHERE ap.eyes_id NOT IN (SELECT eyes_id FROM Eyes);
