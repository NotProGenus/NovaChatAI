
from sqlalchemy import text
from database import engine

try:
    with engine.connect() as conn:
        version = conn.execute(text("SELECT VERSION()")).scalar()

        print("Database Connected Successfully!")
        print("MySQL Version:", version)

except Exception as e:

    print("Database Connection Failed!")
    print("Error:", e)
