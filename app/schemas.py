from pydantic import BaseModel
from typing import List, Optional

# ============================================
# CHARACTER SCHEMAS
# ============================================

class CharacterBase(BaseModel):
    """Base schema with common fields for Character."""
    name: str
    age: int


class CharacterCreate(CharacterBase):
    """Schema for creating a new character (POST request)."""
    pass


class Character(CharacterBase):
    """Schema for returning a character (GET response)."""
    id: int
    
    class Config:
        from_attributes = True


# ============================================
# EQUIPMENT SCHEMAS
# ============================================

class EquipmentBase(BaseModel):
    """Base schema with common fields for Equipment."""
    piece: str
    name: str
    stat: int
    rarity: str
    worth: int
    description: str


class EquipmentCreate(EquipmentBase):
    """Schema for creating a new equipment (POST request)."""
    character_id: int


class Equipment(EquipmentBase):
    """Schema for returning equipment (GET response)."""
    id: int
    character_id: int
    
    class Config:
        from_attributes = True


# ============================================
# RELATIONSHIPS - WITH NESTED DATA
# ============================================

class CharacterWithEquipment(Character):
    """Character with all their equipment included."""
    equipment: List[Equipment] = []


class EquipmentWithCharacter(Equipment):
    """Equipment with the character who owns it."""
    character: Character
