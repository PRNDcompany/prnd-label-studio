# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.8

FROM python:${PYTHON_VERSION}-slim AS python-base

ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=1.6.1 \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    PYSETUP_PATH="/opt/pysetup" \
    #
    PORT=${PORT:-9090} \
    PIP_CACHE_DIR=/.cache \
    WORKERS=1 \
    THREADS=8

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$PATH"
ENV PROJECT_PATH="./prnd_label_studio_ml_backend/convert_polygon_to_brush"

FROM python-base as builder-base

WORKDIR $PYSETUP_PATH

RUN apt-get update; \
    apt-get upgrade -y; \
    apt install --no-install-recommends -y  \
        curl; \
    apt-get autoremove -y

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://install.python-poetry.org | python3 - \
    && poetry --version

FROM builder-base as requirements-stage

WORKDIR $PYSETUP_PATH

COPY ./pyproject.toml ./
COPY ./poetry.lock ./

RUN poetry export -f requirements.txt --without-hashes > /tmp/requirements.txt

COPY $PROJECT_PATH/requirements-base.txt /tmp/requirements-base.txt
COPY $PROJECT_PATH/requirements-test.txt /tmp/requirements-test.txt

FROM python-base as production
ARG TEST_ENV

WORKDIR /app

# Update the base OS
RUN --mount=type=cache,target="/var/cache/apt",sharing=locked \
    --mount=type=cache,target="/var/lib/apt/lists",sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt install --no-install-recommends -y  \
        # for opencv
        ffmpeg libsm6 libxext6 \
        # for git
        git; \
    apt-get autoremove -y


# install base requirements
RUN --mount=type=cache,target=${PIP_CACHE_DIR},sharing=locked \
    --mount=type=bind,from=requirements-stage,source=/tmp/requirements-base.txt,target=/tmp/requirements-base.txt \
    pip install -r /tmp/requirements-base.txt

# install custom requirements
RUN --mount=type=cache,target=${PIP_CACHE_DIR},sharing=locked \
    --mount=type=bind,from=requirements-stage,source=/tmp/requirements.txt,target=/tmp/requirements.txt \
    python -m pip install --disable-pip-version-check --requirement=/tmp/requirements.txt


# install test requirements if needed
# build only when TEST_ENV="true"
RUN --mount=type=cache,target=${PIP_CACHE_DIR},sharing=locked \
    --mount=type=bind,from=requirements-stage,source=/tmp/requirements-test.txt,target=/tmp/requirements-test.txt \
    if [ "$TEST_ENV" = "true" ]; then \
      pip install -r /tmp/requirements-test.txt; \
    fi

COPY $PROJECT_PATH/* .

EXPOSE 9090

CMD gunicorn --preload --bind :$PORT --workers $WORKERS --threads $THREADS --timeout 0 _wsgi:app
