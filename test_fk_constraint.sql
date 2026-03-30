-- Test referential integrity constraints
PRAGMA foreign_keys = ON;

-- Test 1: Try to insert Equipment with invalid armor_id (should fail)
INSERT INTO Equipment (armor_id, weapon_id, cape_id) VALUES (999, 1, 1);
