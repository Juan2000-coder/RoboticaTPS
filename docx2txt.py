# docx2txt.py
import sys
from docx import Document

def convert_docx_to_text(docx_file):
    doc = Document(docx_file)
    return '\n'.join([para.text for para in doc.paragraphs])

if __name__ == "__main__":
    docx_file = sys.argv[1]
    text = convert_docx_to_text(docx_file)
    sys.stdout.buffer.write(text.encode('utf-8'))