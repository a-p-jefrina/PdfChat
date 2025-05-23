from langchain import PromptTemplate
from langchain.chains import RetrievalQA, ConversationalRetrievalChain
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS

from src.prompts import qa_template
from src.llm import llm

# Build prompt template object


def set_qa_prompt():
    prompt = PromptTemplate(template=qa_template, input_variables=[
                            'context', 'question'])

    return prompt

# Build RetrievalQA object


def build_retrieval_qa(llm, prompt, vectordb):
    dbqa = RetrievalQA.from_chain_type(llm=llm,
                                       chain_type='stuff',
                                       return_source_documents=True,
                                       #    vector count set to 2
                                       retriever=vectordb.as_retriever(
                                           search_kwargs={'k': 2}),
                                       chain_type_kwargs={'prompt': prompt}
                                       )
    return dbqa


# Instantiate QA object

def setup_dbqa():
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2",
                                       model_kwargs={'device': 'cpu'})

    vectordb = FAISS.load_local('vectorstore/db_faiss', embeddings)
    qa_prompt = set_qa_prompt()
    dbqa = build_retrieval_qa(llm, qa_prompt, vectordb)

    return dbqa