from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from database import Base

class Character(Base):
    __tablename__ = "character"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    age = Column(Integer, nullable=False)
    
    equipment = relationship("Equipment", back_populates="character", cascade="all, delete-orphan")


class Equipment(Base):
    __tablename__ = "equipment"
    
    id = Column(Integer, primary_key=True, index=True)
    character_id = Column(Integer, ForeignKey("character.id"), nullable=False)
    piece = Column(String(255), nullable=False)
    name = Column(String(255), nullable=False)
    stat = Column(Integer, nullable=False)
    rarity = Column(String(50), nullable=False)
    worth = Column(Integer, nullable=False)
    description = Column(Text, nullable=False)
    
    character = relationship("Character", back_populates="equipment")