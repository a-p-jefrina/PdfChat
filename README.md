# PdfChat
An AI-driven tool designed to streamline document interpretation, specifically tailored for loan and agreement documents.

# Objectives
   1. To help users analyze stock or loan agreements efficiently by utilizing advanced retrieval techniques. 
   
   2. To cover agreement document processing, chunking, query handling, and real-time response generation.
   
   3. To deliver precise and context-aware responses instantly, improving both speed and accuracy.
   
   4. To automate document chunking and generate vector embeddings for efficient information retrieval.  
   
   5. To implement a RAG system using FAISS and Llama2-7B for accurate information retrieval and response generation.  

# Installation
pip install -r requirements.txt

# Note
1. Add your pdf files to the data/ folder or you can use the sample pdf files provided in the folder.

2. Ensure you have downloaded the 8-bit quantised GGML binary file from https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/tree/main and placed it into the models/ folder

3. To start parsing user queries into the application, launch the terminal from the project directory and run the following command:
   
   <code>
      python main.py "user query"
   </code>
   
# Result
![cmd_ans](https://github.com/user-attachments/assets/a8a47b6c-298d-43f7-aa11-23d161187796)

# FlowChart
![image](https://github.com/user-attachments/assets/ce541c9c-d44c-49c2-9897-53a04d166e0a)

# Website Images
![image](https://github.com/user-attachments/assets/c8d4ddc6-248e-42be-80fb-75805e197107)

![image](https://github.com/user-attachments/assets/ce71ff76-fe3a-43f5-947d-155bf0639286)

![image](https://github.com/user-attachments/assets/ceccc7bc-b48e-4186-9142-809131ee1479)


