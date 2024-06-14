# How to create new ml backend module

## 1. Create a new module
```
cd prnd_label_studio_ml_backend
poetry run label-studio-ml create <MODULE_NAME>
```

- Ref: https://labelstud.io/guide/ml_create


## 2. Implement your model
- Implement your model in the `predict` method of the `Model` class in `prnd_label_studio_ml_backend/<MODULE_NAME>/model.py`.
- Set container for the module in root `docker-compose.yml` file. (change ports if needed)
- Delete requirements.txt file and remove `ml-backend` library in requirements-base.txt (It will be installed using poetry)
- Edit `Dockerfile` following sample [Dockerfile](prnd_label_studio_ml_backend/convert_polygon_to_brush/Dockerfile)
