from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import timeit
from src.utils import setup_dbqa
from db_create import db_create

# Initialize FastAPI app
app = FastAPI()

# Allow CORS for specific origins (including Flutter localhost or other hosts)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:58838", "http://localhost:58838"],  # Add your Flutter app URL here
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (POST, GET, etc.)
    allow_headers=["*"],  # Allows all headers
)

# Setup database when the server starts
db_create()

# Initialize the QA system once at startup
dbqa = setup_dbqa()

class Question(BaseModel):
    query: str

@app.post("/ask")
async def ask_question(question: Question):
    start = timeit.default_timer()

    # Feed input qn to QA object
    response = dbqa({'query': question.query})

    end = timeit.default_timer()

    source_docs = []
    for i, doc in enumerate(response['source_documents']):
        source_docs.append({
            'source_text': doc.page_content,
            'document_name': doc.metadata["source"],
            'page_number': doc.metadata["page"]
        })

    return {
        'answer': response['result'],
        'source_documents': source_docs,
        'response_time': end - start
    }