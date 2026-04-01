// API Base URL
const API_URL = 'http://localhost:8000/api';

// ============================================
// TAB SWITCHING
// ============================================

document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        const tabName = e.target.dataset.tab;
        
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // Remove active from all buttons
        document.querySelectorAll('.tab-btn').forEach(b => {
            b.classList.remove('active');
        });
        
        // Show selected tab
        document.getElementById(tabName).classList.add('active');
        e.target.classList.add('active');
        
        // Load data for the tab
        if (tabName === 'characters') {
            loadCharacters();
        } else if (tabName === 'equipment') {
            loadEquipment();
            loadCharactersForSelect();
        } else if (tabName === 'relationships') {
            loadRelationships();
        }
    });
});

// Load on page load
window.addEventListener('DOMContentLoaded', () => {
    loadCharacters();
});

// ============================================
// CHARACTER OPERATIONS
// ============================================

// Get all characters
async function loadCharacters() {
    try {
        const response = await fetch(`${API_URL}/characters`);
        const characters = await response.json();
        displayCharacters(characters);
    } catch (error) {
        console.error('Error loading characters:', error);
        document.getElementById('charactersContainer').innerHTML = 
            '<p>Error loading characters</p>';
    }
}

// Display characters
function displayCharacters(characters) {
    const container = document.getElementById('charactersContainer');
    
    if (characters.length === 0) {
        container.innerHTML = '<p class="empty-message">No characters yet</p>';
        return;
    }
    
    container.innerHTML = characters.map(char => `
        <div class="card">
            <div class="card-content">
                <h4>${char.name}</h4>
                <p>Age: ${char.age}</p>
            </div>
            <div class="card-actions">
                <button class="btn-edit" onclick="editCharacter(${char.id}, '${char.name}', ${char.age})">Edit</button>
                <button class="btn-delete" onclick="deleteCharacter(${char.id})">Delete</button>
            </div>
        </div>
    `).join('');
}

// Edit character
function editCharacter(id, name, age) {
    const newName = prompt('Enter new name:', name);
    if (newName === null) return;
    
    const newAge = prompt('Enter new age:', age);
    if (newAge === null) return;
    
    updateCharacter(id, newName, parseInt(newAge));
}

// Update character
async function updateCharacter(id, name, age) {
    try {
        const response = await fetch(`${API_URL}/characters/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, age })
        });
        
        if (response.ok) {
            loadCharacters();
            alert('Character updated!');
        } else {
            alert('Error updating character');
        }
    } catch (error) {
        console.error('Error updating character:', error);
        alert('Error updating character');
    }
}

// Create character
document.getElementById('characterForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const name = document.getElementById('charName').value;
    const age = document.getElementById('charAge').value;
    
    try {
        const response = await fetch(`${API_URL}/characters`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, age: parseInt(age) })
        });
        
        if (response.ok) {
            document.getElementById('characterForm').reset();
            loadCharacters();
            alert('Character created!');
        }
    } catch (error) {
        console.error('Error creating character:', error);
        alert('Error creating character');
    }
});

// Delete character
async function deleteCharacter(id) {
    if (!confirm('Delete this character?')) return;
    
    try {
        await fetch(`${API_URL}/characters/${id}`, { method: 'DELETE' });
        loadCharacters();
        alert('Character deleted!');
    } catch (error) {
        console.error('Error deleting character:', error);
        alert('Error deleting character');
    }
}

// ============================================
// EQUIPMENT OPERATIONS
// ============================================

// Load all equipment
async function loadEquipment() {
    try {
        const response = await fetch(`${API_URL}/equipment`);
        const equipment = await response.json();
        displayEquipment(equipment);
    } catch (error) {
        console.error('Error loading equipment:', error);
        document.getElementById('equipmentContainer').innerHTML = 
            '<p>Error loading equipment</p>';
    }
}

// Display equipment
function displayEquipment(equipment) {
    const container = document.getElementById('equipmentContainer');
    
    if (equipment.length === 0) {
        container.innerHTML = '<p class="empty-message">No equipment yet</p>';
        return;
    }
    
    container.innerHTML = equipment.map(eq => `
        <div class="card">
            <div class="card-content">
                <h4>${eq.name}</h4>
                <p>Type: ${eq.piece} | Stat: ${eq.stat} | Rarity: ${eq.rarity}</p>
                <p>Worth: ${eq.worth} | ${eq.description}</p>
            </div>
            <div class="card-actions">
                <button class="btn-edit" onclick="editEquipment(${eq.id}, ${eq.character_id}, '${eq.piece}', '${eq.name}', ${eq.stat}, '${eq.rarity}', ${eq.worth}, '${eq.description}')">Edit</button>
                <button class="btn-delete" onclick="deleteEquipment(${eq.id})">Delete</button>
            </div>
        </div>
    `).join('');
}

// Edit equipment
function editEquipment(id, charId, piece, name, stat, rarity, worth, description) {
    const newPiece = prompt('Enter piece type:', piece);
    if (newPiece === null) return;
    
    const newName = prompt('Enter equipment name:', name);
    if (newName === null) return;
    
    const newStat = prompt('Enter stat value:', stat);
    if (newStat === null) return;
    
    const newRarity = prompt('Enter rarity (common/uncommon/rare/epic/legendary):', rarity);
    if (newRarity === null) return;
    
    const newWorth = prompt('Enter worth:', worth);
    if (newWorth === null) return;
    
    const newDescription = prompt('Enter description:', description);
    if (newDescription === null) return;
    
    updateEquipment(id, charId, newPiece, newName, parseInt(newStat), newRarity, parseInt(newWorth), newDescription);
}

// Update equipment
async function updateEquipment(id, characterId, piece, name, stat, rarity, worth, description) {
    try {
        const response = await fetch(`${API_URL}/equipment/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ character_id: characterId, piece, name, stat, rarity, worth, description })
        });
        
        if (response.ok) {
            loadEquipment();
            alert('Equipment updated!');
        } else {
            alert('Error updating equipment');
        }
    } catch (error) {
        console.error('Error updating equipment:', error);
        alert('Error updating equipment');
    }
}

// Load characters for dropdown
async function loadCharactersForSelect() {
    try {
        const response = await fetch(`${API_URL}/characters`);
        const characters = await response.json();
        
        const select = document.getElementById('equipCharacterId');
        select.innerHTML = '<option value="">Select Character</option>';
        select.innerHTML += characters.map(char => 
            `<option value="${char.id}">${char.name}</option>`
        ).join('');
    } catch (error) {
        console.error('Error loading characters for select:', error);
    }
}

// Create equipment
document.getElementById('equipmentForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const equipment = {
        character_id: parseInt(document.getElementById('equipCharacterId').value),
        piece: document.getElementById('equipPiece').value,
        name: document.getElementById('equipName').value,
        stat: parseInt(document.getElementById('equipStat').value),
        rarity: document.getElementById('equipRarity').value,
        worth: parseInt(document.getElementById('equipWorth').value),
        description: document.getElementById('equipDescription').value
    };
    
    try {
        const response = await fetch(`${API_URL}/equipment`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(equipment)
        });
        
        if (response.ok) {
            document.getElementById('equipmentForm').reset();
            loadEquipment();
            alert('Equipment created!');
        }
    } catch (error) {
        console.error('Error creating equipment:', error);
        alert('Error creating equipment');
    }
});

// Delete equipment
async function deleteEquipment(id) {
    if (!confirm('Delete this equipment?')) return;
    
    try {
        await fetch(`${API_URL}/equipment/${id}`, { method: 'DELETE' });
        loadEquipment();
        alert('Equipment deleted!');
    } catch (error) {
        console.error('Error deleting equipment:', error);
        alert('Error deleting equipment');
    }
}

// ============================================
// RELATIONSHIPS
// ============================================

async function loadRelationships() {
    try {
        const response = await fetch(`${API_URL}/characters`);
        const characters = await response.json();
        displayRelationships(characters);
    } catch (error) {
        console.error('Error loading relationships:', error);
        document.getElementById('relationshipsContainer').innerHTML = 
            '<p>Error loading relationships</p>';
    }
}

function displayRelationships(characters) {
    const container = document.getElementById('relationshipsContainer');
    
    if (characters.length === 0) {
        container.innerHTML = '<p class="empty-message">No characters</p>';
        return;
    }
    
    container.innerHTML = characters.map(char => `
        <div class="card">
            <div class="card-content">
                <h4>${char.name} (Age: ${char.age})</h4>
                <p>Equipment: ${char.equipment?.length || 0} items</p>
            </div>
        </div>
    `).join('');
}
