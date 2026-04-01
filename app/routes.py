from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from app import models, schemas

router = APIRouter(prefix="/api", tags=["api"])

# ============================================
# CHARACTER ENDPOINTS
# ============================================

# GET all characters
@router.get("/characters", response_model=list[schemas.Character])
def get_characters(db: Session = Depends(get_db)):
    """Get all characters."""
    characters = db.query(models.Character).all()
    return characters


# GET one character by ID
@router.get("/characters/{char_id}", response_model=schemas.Character)
def get_character(char_id: int, db: Session = Depends(get_db)):
    """Get one character by ID."""
    character = db.query(models.Character).filter(models.Character.id == char_id).first()
    if not character:
        raise HTTPException(status_code=404, detail="Character not found")
    return character


# POST create new character
@router.post("/characters", response_model=schemas.Character)
def create_character(char: schemas.CharacterCreate, db: Session = Depends(get_db)):
    """Create a new character."""
    db_char = models.Character(name=char.name, age=char.age)
    db.add(db_char)
    db.commit()
    db.refresh(db_char)
    return db_char


# PUT update character
@router.put("/characters/{char_id}", response_model=schemas.Character)
def update_character(char_id: int, char: schemas.CharacterCreate, db: Session = Depends(get_db)):
    """Update a character."""
    db_char = db.query(models.Character).filter(models.Character.id == char_id).first()
    if not db_char:
        raise HTTPException(status_code=404, detail="Character not found")
    db_char.name = char.name
    db_char.age = char.age
    db.commit()
    db.refresh(db_char)
    return db_char


# DELETE character
@router.delete("/characters/{char_id}")
def delete_character(char_id: int, db: Session = Depends(get_db)):
    """Delete a character."""
    db_char = db.query(models.Character).filter(models.Character.id == char_id).first()
    if not db_char:
        raise HTTPException(status_code=404, detail="Character not found")
    db.delete(db_char)
    db.commit()
    return {"deleted": True}


# ============================================
# EQUIPMENT ENDPOINTS
# ============================================

# GET all equipment
@router.get("/equipment", response_model=list[schemas.Equipment])
def get_equipment(db: Session = Depends(get_db)):
    """Get all equipment."""
    equipment = db.query(models.Equipment).all()
    return equipment


# GET one equipment by ID
@router.get("/equipment/{eq_id}", response_model=schemas.Equipment)
def get_equipment_item(eq_id: int, db: Session = Depends(get_db)):
    """Get one equipment by ID."""
    equipment = db.query(models.Equipment).filter(models.Equipment.id == eq_id).first()
    if not equipment:
        raise HTTPException(status_code=404, detail="Equipment not found")
    return equipment


# POST create new equipment
@router.post("/equipment", response_model=schemas.Equipment)
def create_equipment(eq: schemas.EquipmentCreate, db: Session = Depends(get_db)):
    """Create new equipment."""
    db_eq = models.Equipment(**eq.dict())
    db.add(db_eq)
    db.commit()
    db.refresh(db_eq)
    return db_eq


# PUT update equipment
@router.put("/equipment/{eq_id}", response_model=schemas.Equipment)
def update_equipment(eq_id: int, eq: schemas.EquipmentCreate, db: Session = Depends(get_db)):
    """Update equipment."""
    db_eq = db.query(models.Equipment).filter(models.Equipment.id == eq_id).first()
    if not db_eq:
        raise HTTPException(status_code=404, detail="Equipment not found")
    for key, value in eq.dict().items():
        setattr(db_eq, key, value)
    db.commit()
    db.refresh(db_eq)
    return db_eq


# DELETE equipment
@router.delete("/equipment/{eq_id}")
def delete_equipment(eq_id: int, db: Session = Depends(get_db)):
    """Delete equipment."""
    db_eq = db.query(models.Equipment).filter(models.Equipment.id == eq_id).first()
    if not db_eq:
        raise HTTPException(status_code=404, detail="Equipment not found")
    db.delete(db_eq)
    db.commit()
    return {"deleted": True}


# ============================================
# RELATIONSHIP ENDPOINTS
# ============================================

# GET character's equipment
@router.get("/characters/{char_id}/equipment", response_model=list[schemas.Equipment])
def get_character_equipment(char_id: int, db: Session = Depends(get_db)):
    """Get all equipment for a character."""
    character = db.query(models.Character).filter(models.Character.id == char_id).first()
    if not character:
        raise HTTPException(status_code=404, detail="Character not found")
    return character.equipment


# POST add equipment to character
@router.post("/characters/{char_id}/equipment", response_model=schemas.Equipment)
def add_equipment_to_character(char_id: int, eq: schemas.EquipmentCreate, db: Session = Depends(get_db)):
    """Add equipment to a character."""
    character = db.query(models.Character).filter(models.Character.id == char_id).first()
    if not character:
        raise HTTPException(status_code=404, detail="Character not found")
    db_eq = models.Equipment(**eq.dict())
    db.add(db_eq)
    db.commit()
    db.refresh(db_eq)
    return db_eq
