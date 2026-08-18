import firebase_admin
from firebase_admin import credentials
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

cred = credentials.Certificate(
    BASE_DIR / "firebase" / "serviceAccountKey.json"
)

if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)