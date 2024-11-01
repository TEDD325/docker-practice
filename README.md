```shell
conda create -n fastapi python=3.11 -y
conda activate fastapi
pip install poetry
poetry init
poetry add fastapi uvicorn python-multipart
python main.py
```