import sqlite3

if __name__ == "__main__":
    db = sqlite3.connect("sqlite.db")

    with open("schema.sql", "r") as schema:
        db.executescript(schema.read())

    db.commit()
    db.close()
