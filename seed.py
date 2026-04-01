import sqlite3

def seed_database():
    """Seed the database with schema and sample data."""
    conn = sqlite3.connect('characters.db')
    cursor = conn.cursor()
    
    print("Loading schema...")
    # Load schema
    with open('schema.sql', 'r') as f:
        for statement in f.read().split(';'):
            statement = statement.strip()
            if statement:
                try:
                    cursor.execute(statement)
                except Exception as e:
                    print(f"Schema warning: {e}")
    
    print("Loading sample data...")
    # Load sample data
    with open('sample_data.sql', 'r') as f:
        for statement in f.read().split(';'):
            statement = statement.strip()
            if statement:
                try:
                    cursor.execute(statement)
                except Exception as e:
                    print(f"Data warning: {e}")
    
    conn.commit()
    
    # Verify
    cursor.execute("SELECT COUNT(*) FROM character;")
    char_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM equipment;")
    eq_count = cursor.fetchone()[0]
    
    conn.close()
    
    print(f"✓ Database seeded successfully!")
    print(f"  Characters: {char_count}")
    print(f"  Equipment: {eq_count}")

if __name__ == "__main__":
    seed_database()
