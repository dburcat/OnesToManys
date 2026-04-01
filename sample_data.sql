-- ============================================
-- Sample Data: Three Characters with Equipment
-- ============================================

-- Insert Characters (Master Table)
INSERT INTO character (id, name, age) VALUES
(1, 'Aragorn the Ranger', 87),
(2, 'Legolas the Archer', 2019),
(3, 'Gimli the Dwarf', 139);

-- Insert Equipment for Aragorn (Character ID 1)
INSERT INTO equipment (id, character_id, piece, name, stat, rarity, worth, description) VALUES
(1, 1, 'Sword', 'Anduril - Flame of the West', 95, 'Legendary', 5000, 'A gleaming sword with ancient elvish runes, forged in the Undying Lands'),
(2, 1, 'Helmet', 'Crown of Gondor', 45, 'Legendary', 3000, 'Silver crown with black rowan emblem, symbol of the Kings of Men'),
(3, 1, 'Armor', 'Mithril Plate', 60, 'Legendary', 4500, 'Silvery-white metal plates with intricate engravings, light yet impenetrable'),
(4, 1, 'Boots', 'Ranger Boots', 25, 'Rare', 800, 'Leather boots with reinforced soles for tracking and journeying');

-- Insert Equipment for Legolas (Character ID 2)
INSERT INTO equipment (id, character_id, piece, name, stat, rarity, worth, description) VALUES
(5, 2, 'Bow', 'Bow of the Mirkwood', 85, 'Legendary', 4200, 'Elegant wooden bow with silver inlays, crafted by Mirkwood elves'),
(6, 2, 'Arrow', 'Elven Arrows', 40, 'Rare', 1500, 'Arrows with precise balance and magical properties for true aim'),
(7, 2, 'Cloak', 'Elven Cloak of Lórien', 35, 'Rare', 2000, 'Deep blue fabric with subtle shimmer, grants protection in forests'),
(8, 2, 'Tunic', 'Tunic of Mirkwood', 30, 'Uncommon', 900, 'Green and grey fabric tunic allowing movement and camouflage');

-- Insert Equipment for Gimli (Character ID 3)
INSERT INTO equipment (id, character_id, piece, name, stat, rarity, worth, description) VALUES
(9, 3, 'Axe', 'Durin''s Axe', 105, 'Legendary', 6000, 'Double-bladed axe forged in Khazad-dûm with mithril edge'),
(10, 3, 'Helmet', 'Iron Crown of Erebor', 50, 'Legendary', 3500, 'Heavy iron helm with gold inlays and mountain crest emblem'),
(11, 3, 'Armor', 'Dwarven Plate Mail', 75, 'Legendary', 5200, 'Interlocking steel plates masterwork quality, passed through generations'),
(12, 3, 'Shield', 'Shield of Durin', 55, 'Rare', 2500, 'Iron-banded shield with hammer emblem, defensive master work');
