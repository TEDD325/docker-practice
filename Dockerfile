# 베이스 이미지로 Python 3.11 슬림 버전 사용
FROM python:3.11-slim

# 환경 변수 설정
ENV PYTHONUNBUFFERED=1
ENV POETRY_VERSION=1.8.4

# 시스템 패키지 업데이트 및 Poetry 설치에 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl build-essential && \
    rm -rf /var/lib/apt/lists/*

# Poetry 설치
RUN curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION

# Poetry를 PATH에 추가
ENV PATH="/root/.local/bin:$PATH"

# 작업 디렉토리 루트 설정 및 작업 디렉토리가 컨테이너 내에 존재하지 않을 시에 생성
WORKDIR /app

# 종속성 파일을 컨테이너 내부로 복사
COPY pyproject.toml poetry.lock ./
# 가독성을 위해 아래와 같이 작성하는 것을 더 권장(똑같은 의미이지만 가독성을 더 높여준다.)
# 절대경로 상대경로의 차이라고 보면 된다.
# COPY pyproject.toml poetry.lock /app

# 의존성 설치 (Production용 의존성만 설치)
RUN poetry install --no-dev --no-interaction --no-ansi

# 애플리케이션 소스 코드 복사
COPY . .
# COPY . /app

# 컨테이너 내부의 80 포트를 로컬 호스트로 노출
EXPOSE 80

# 컨테이너 시작 시 실행할 명령어
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]