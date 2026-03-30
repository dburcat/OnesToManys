-- ============================================
-- Sample Data: Three Characters with Equipment
-- ============================================

-- Insert Characters
INSERT INTO character (id, name) VALUES
(1, 'Aragorn the Ranger'),
(2, 'Legolas the Archer'),
(3, 'Gimli the Dwarf');

-- Insert Equipment Sets
INSERT INTO equipment (id, character_id) VALUES
(1, 1),  -- Aragorn's equipment
(2, 2),  -- Legolas's equipment
(3, 3);  -- Gimli's equipment

-- ============================================
-- Aragorn's Equipment Set (id=1)
-- ============================================

INSERT INTO weapon (id, equipment_id, name, attack_power, appearance, rarity, worth) VALUES
(1, 1, 'Anduril - Flame of the West', 95, 'A gleaming sword with ancient elvish runes', 'Legendary', 5000);

INSERT INTO helmet (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(1, 1, 'Crown of Gondor', 45, 'Silver crown with black rowan emblem', 'Legendary', 3000);

INSERT INTO chestplate (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(1, 1, 'Mithril Plate Armor', 60, 'Silvery-white metal plates with intricate engravings', 'Legendary', 4500);

INSERT INTO legpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(1, 1, 'Ranger Leg Guards', 35, 'Leather-reinforced steel greaves with green trim', 'Rare', 1200);

INSERT INTO armpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(1, 1, 'Gauntlets of Grip', 28, 'Steel gauntlets with leather palm reinforcement', 'Uncommon', 800);

INSERT INTO cape (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(1, 1, 'Elven Cloak of Rivendell', 20, 'Grey fabric with subtle shimmer, leaf-pattern edges', 'Rare', 2000);

-- ============================================
-- Legolas's Equipment Set (id=2)
-- ============================================

INSERT INTO weapon (id, equipment_id, name, attack_power, appearance, rarity, worth) VALUES
(2, 2, 'Bow of the Mirkwood', 85, 'Elegant wooden bow with silver inlays', 'Legendary', 4200);

INSERT INTO helmet (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(2, 2, 'Mirkwood Circlet', 30, 'Thin bronze band with leaf motifs', 'Rare', 1500);

INSERT INTO chestplate (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(2, 2, 'Elvish Leather Cuirass', 40, 'Supple leather with interlocking metal scales', 'Rare', 2800);

INSERT INTO legpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(2, 2, 'Swift Leg Wraps', 25, 'Leather and cloth wraps for mobility', 'Uncommon', 600);

INSERT INTO armpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(2, 2, 'Archer Bracers', 22, 'Reinforced leather bracers with string guards', 'Common', 400);

INSERT INTO cape (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(2, 2, 'Cloak of Starlight', 18, 'Deep blue fabric with silver star embroidery', 'Rare', 1800);

-- ============================================
-- Gimli's Equipment Set (id=3)
-- ============================================

INSERT INTO weapon (id, equipment_id, name, attack_power, appearance, rarity, worth) VALUES
(3, 3, 'Durin''s Axe', 105, 'Double-bladed axe forged in Khazad-dûm', 'Legendary', 6000);

INSERT INTO helmet (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(3, 3, 'Iron Crown of Erebor', 50, 'Heavy iron helm with gold inlays and crest', 'Legendary', 3500);

INSERT INTO chestplate (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(3, 3, 'Dwarven Plate Mail', 75, 'Thick interlocking steel plates, masterwork quality', 'Legendary', 5200);

INSERT INTO legpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(3, 3, 'Dwarf-forged Greaves', 55, 'Heavy steel leg protection with geometric patterns', 'Rare', 2000);

INSERT INTO armpiece (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(3, 3, 'Gauntlets of Might', 48, 'Reinforced steel with spiked knuckles', 'Rare', 1600);

INSERT INTO cape (id, equipment_id, name, defense, appearance, rarity, worth) VALUES
(3, 3, 'Cloak of Stone', 25, 'Grey wool with stone-grey fur lining', 'Uncommon', 900);
